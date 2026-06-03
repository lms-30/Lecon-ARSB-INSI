#!/usr/bin/env bash
# ============================================================
#  HASHICORP VAULT - SCRIPT D'INITIALISATION COMPLET
#  
#  Ce script configure Vault pour l'environnement DevSecOps:
#    1. Initialise Vault (génère les unseal keys & root token)
#    2. Unseal Vault
#    3. Configure les moteurs de secrets
#    4. Crée les politiques Jenkins
#    5. Configure l'authentification AppRole pour Jenkins
#    6. Active l'audit logging
#
#  UTILISATION:
#    chmod +x init-vault.sh
#    ./init-vault.sh
#
#  SORTIE:
#    Les credentials générés sont sauvegardés dans vault-init.json
#    GARDEZ CE FICHIER EN SÉCURITÉ ET NE LE COMMITEZ PAS !
# ============================================================

set -uo pipefail

# --- Configuration ---
VAULT_ADDR="${VAULT_ADDR:-http://localhost:8200}"
INIT_OUTPUT_FILE="vault-init.json"
POLICIES_DIR="./policies"

# --- Couleurs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
log_step()    { echo -e "\n${CYAN}════════════════════════════════════════${NC}"; echo -e "${CYAN}  ÉTAPE: $1${NC}"; echo -e "${CYAN}════════════════════════════════════════${NC}"; }

# --- Vérifications préalables ---
check_prerequisites() {
  log_step "Vérification des prérequis"
  
  command -v docker exec -i vault vault >/dev/null 2>&1 || log_error "docker exec -i vault vault CLI non trouvé. Installez HashiCorp Vault CLI."
  command -v curl  >/dev/null 2>&1 || log_error "curl non trouvé."
  command -v jq    >/dev/null 2>&1 || log_error "jq non trouvé. Installez jq."
  
  log_success "Tous les prérequis sont satisfaits"
}

# --- Attendre que Vault soit prêt ---
wait_for_vault() {
  log_step "Attente de Vault"
  local max_attempts=30
  local attempt=0
  
  while [ $attempt -lt $max_attempts ]; do
    if curl -s "${VAULT_ADDR}/v1/sys/health" > /dev/null 2>&1; then
      log_success "Vault est accessible"
      return 0
    fi
    attempt=$((attempt + 1))
    log_info "Tentative $attempt/$max_attempts..."
    sleep 3
  done
  
  log_error "Vault n'est pas accessible après $max_attempts tentatives"
}

# --- Initialiser Vault ---
init_vault() {
  log_step "Initialisation de Vault"
  
  local status
  status=$(curl -s "${VAULT_ADDR}/v1/sys/health" | jq -r '.initialized' 2>/dev/null || echo "false")
  
  if [ "$status" = "true" ]; then
    log_warn "Vault est déjà initialisé. Chargement de vault-init.json..."
    if [ ! -f "$INIT_OUTPUT_FILE" ]; then
      log_error "vault-init.json introuvable. Impossible de continuer."
    fi
    VAULT_TOKEN=$(jq -r '.root_token' "$INIT_OUTPUT_FILE")
    UNSEAL_KEY_1=$(jq -r '.unseal_keys_b64[0]' "$INIT_OUTPUT_FILE")
    UNSEAL_KEY_2=$(jq -r '.unseal_keys_b64[1]' "$INIT_OUTPUT_FILE")
    UNSEAL_KEY_3=$(jq -r '.unseal_keys_b64[2]' "$INIT_OUTPUT_FILE")
    return 0
  fi
  
  log_info "Initialisation de Vault avec 5 clés (seuil: 3)..."
  
  local init_output
  init_output=$(docker exec -i vault vault operator init \
    -key-shares=5 \
    -key-threshold=3 \
    -format=json)
  
  echo "$init_output" > "$INIT_OUTPUT_FILE"
  chmod 600 "$INIT_OUTPUT_FILE"
  
  VAULT_TOKEN=$(echo "$init_output" | jq -r '.root_token')
  UNSEAL_KEY_1=$(echo "$init_output" | jq -r '.unseal_keys_b64[0]')
  UNSEAL_KEY_2=$(echo "$init_output" | jq -r '.unseal_keys_b64[1]')
  UNSEAL_KEY_3=$(echo "$init_output" | jq -r '.unseal_keys_b64[2]')
  
  log_success "Vault initialisé !"
  log_warn "═══════════════════════════════════════════════════════"
  log_warn "  Les clés de déchiffrement sont dans: $INIT_OUTPUT_FILE"
  log_warn "  SAUVEGARDEZ CE FICHIER EN LIEU SÛR !"
  log_warn "  Ne le commitez JAMAIS dans votre dépôt Git !"
  log_warn "═══════════════════════════════════════════════════════"
}

# --- Unseal Vault ---
unseal_vault() {
  log_step "Déchiffrement (Unseal) de Vault"
  
  local sealed
  sealed=$(curl -s "${VAULT_ADDR}/v1/sys/health" | jq -r '.sealed' 2>/dev/null || echo "true")
  
  if [ "$sealed" = "false" ]; then
    log_success "Vault est déjà déchiffré"
    return 0
  fi
  
  log_info "Application des clés de déchiffrement..."
  docker exec -i vault vault operator unseal "$UNSEAL_KEY_1" > /dev/null
  docker exec -i vault vault operator unseal "$UNSEAL_KEY_2" > /dev/null
  docker exec -i vault vault operator unseal "$UNSEAL_KEY_3" > /dev/null
  
  log_success "Vault est déchiffré et opérationnel"
}

# --- Configurer les moteurs de secrets ---
setup_secrets_engines() {
  log_step "Configuration des moteurs de secrets"
  export VAULT_TOKEN
  
  # KV v2 pour les secrets des projets
  docker exec -i vault vault secrets enable -path="secret" kv-v2 2>/dev/null || \
    log_warn "Le moteur secret/kv-v2 existe déjà"
  log_success "Moteur KV v2 activé: secret/"
  
  # KV v2 pour les credentials d'infrastructure
  docker exec -i vault vault secrets enable -path="infra" kv-v2 2>/dev/null || \
    log_warn "Le moteur infra/kv-v2 existe déjà"
  log_success "Moteur KV v2 activé: infra/"
  
  # Moteur PKI (pour les certificats TLS)
  docker exec -i vault vault secrets enable pki 2>/dev/null || \
    log_warn "Le moteur PKI existe déjà"
  docker exec -i vault vault secrets tune -max-lease-ttl=8760h pki
  log_success "Moteur PKI activé"

  # Création de secrets de démonstration pour Jenkins
  docker exec -i vault vault kv put secret/jenkins/sonarqube \
    token="CHANGEME_SONAR_TOKEN" \
    url="http://sonarqube:9000"
  
  docker exec -i vault vault kv put secret/jenkins/git \
    username="your-git-user" \
    token="CHANGEME_GIT_TOKEN"
  
  docker exec -i vault vault kv put infra/docker/registry \
    username="registry-user" \
    password="CHANGEME_REGISTRY_PASS" \
    url="registry.example.com"
  
  log_success "Secrets de démonstration créés"
}

# --- Créer les politiques ---
setup_policies() {
  log_step "Configuration des politiques de sécurité"
  
  # Politique Jenkins (lecture uniquement)
  cat > /tmp/jenkins-policy.hcl << 'POLICY'
# Politique Jenkins DevSecOps
# Jenkins peut lire les secrets mais pas les modifier

# Accès aux secrets des projets (lecture seule)
path "secret/data/jenkins/*" {
  capabilities = ["read", "list"]
}

# Accès aux secrets d'infrastructure (lecture seule)
path "infra/data/*" {
  capabilities = ["read", "list"]
}

# Liste des secrets disponibles
path "secret/metadata/*" {
  capabilities = ["list"]
}

path "infra/metadata/*" {
  capabilities = ["list"]
}

# Renouvellement de token
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Lookup de son propre token
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
POLICY

  docker exec -i vault vault policy write jenkins-policy /tmp/jenkins-policy.hcl
  log_success "Politique jenkins-policy créée"

  # Politique Admin (gestion complète)
  cat > /tmp/admin-policy.hcl << 'POLICY'
# Politique Administrateur - Accès complet
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
POLICY

  docker exec -i vault vault policy write admin-policy /tmp/admin-policy.hcl
  log_success "Politique admin-policy créée"
  
  # Copier les politiques dans le dossier policies
  mkdir -p "$POLICIES_DIR"
  cp /tmp/jenkins-policy.hcl "$POLICIES_DIR/jenkins-policy.hcl"
  cp /tmp/admin-policy.hcl "$POLICIES_DIR/admin-policy.hcl"
}

# --- Configurer l'authentification AppRole pour Jenkins ---
setup_approle() {
  log_step "Configuration AppRole pour Jenkins"
  
  docker exec -i vault vault auth enable approle 2>/dev/null || \
    log_warn "AppRole est déjà activé"
  
  # Créer le role Jenkins avec TTL court
  docker exec -i vault vault write auth/approle/role/jenkins-role \
    secret_id_ttl=0 \
    token_ttl=1h \
    token_max_ttl=4h \
    policies="jenkins-policy" \
    bind_secret_id=true
  
  # Récupérer le Role ID
  VAULT_ROLE_ID=$(docker exec -i vault vault read -format=json auth/approle/role/jenkins-role/role-id | jq -r '.data.role_id')
  
  # Générer un Secret ID
  VAULT_SECRET_ID=$(docker exec -i vault vault write -format=json -f auth/approle/role/jenkins-role/secret-id | jq -r '.data.secret_id')
  
  log_success "AppRole jenkins-role configuré"
  echo ""
  echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║         CREDENTIALS JENKINS POUR VAULT                  ║${NC}"
  echo -e "${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"
  echo -e "${GREEN}║${NC}  VAULT_ROLE_ID   : ${YELLOW}${VAULT_ROLE_ID}${NC}"
  echo -e "${GREEN}║${NC}  VAULT_SECRET_ID : ${YELLOW}${VAULT_SECRET_ID}${NC}"
  echo -e "${GREEN}╠══════════════════════════════════════════════════════════╣${NC}"
  echo -e "${GREEN}║  Copiez ces valeurs dans:                               ║${NC}"
  echo -e "${GREEN}║    → jenkins/.env (VAULT_ROLE_ID et VAULT_SECRET_ID)   ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
  
  # Sauvegarder dans un fichier
  {
    echo "# Jenkins Vault AppRole Credentials"
    echo "# Généré le: $(date)"
    echo "VAULT_ROLE_ID=${VAULT_ROLE_ID}"
    echo "VAULT_SECRET_ID=${VAULT_SECRET_ID}"
  } > vault-jenkins-credentials.env
  chmod 600 vault-jenkins-credentials.env
}

# --- Activer l'audit logging ---
setup_audit() {
  log_step "Configuration de l'audit logging"
  
  docker exec -i vault vault audit enable file \
    file_path=/vault/audit/audit.log \
    log_raw=false 2>/dev/null || \
    log_warn "L'audit file est déjà activé"
  
  log_success "Audit logging activé: /vault/audit/audit.log"
}

# ============================================================
#  EXÉCUTION PRINCIPALE
# ============================================================
main() {
  echo -e "${CYAN}"
  echo "╔══════════════════════════════════════════════════╗"
  echo "║    HashiCorp Vault - Initialisation DevSecOps    ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo -e "${NC}"
  
  export VAULT_ADDR
  
  check_prerequisites
  wait_for_vault
  init_vault
  unseal_vault
  setup_secrets_engines
  setup_policies
  setup_approle
  setup_audit
  
  echo ""
  log_success "═══════════════════════════════════════════════════"
  log_success "  Vault est prêt pour l'environnement DevSecOps !"
  log_success "  UI: ${VAULT_ADDR}"
  log_success "  Root Token: $(jq -r '.root_token' $INIT_OUTPUT_FILE)"
  log_success "═══════════════════════════════════════════════════"
}

main "$@"
