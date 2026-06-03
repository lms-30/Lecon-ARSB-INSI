#!/usr/bin/env bash
# ============================================================
#  DEVSECOPS STACK - SCRIPT DE DÉMARRAGE GLOBAL
#  
#  Lance l'ensemble de la stack dans le bon ordre:
#    1. Réseau Docker partagé
#    2. HashiCorp Vault
#    3. SonarQube + PostgreSQL
#    4. Jenkins
#
#  UTILISATION:
#    chmod +x start-all.sh
#    ./start-all.sh [--build]
#
#  OPTIONS:
#    --build   Rebuild toutes les images Docker
#    --stop    Arrêter tous les services
#    --status  Afficher l'état de tous les services
# ============================================================

set -euo pipefail

# --- Couleurs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_step()    { echo -e "\n${CYAN}${BOLD}▶ $1${NC}"; }
log_success() { echo -e "  ${GREEN}✓${NC} $1"; }
log_warn()    { echo -e "  ${YELLOW}⚠${NC} $1"; }
log_error()   { echo -e "  ${RED}✗${NC} $1"; exit 1; }
log_info()    { echo -e "  ${BLUE}ℹ${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_FLAG=""

# --- Traitement des arguments ---
case "${1:-}" in
  --build)  BUILD_FLAG="--build" ;;
  --stop)   stop_all; exit 0 ;;
  --status) show_status; exit 0 ;;
esac

# ============================================================
#  FONCTIONS
# ============================================================

check_prerequisites() {
  log_step "Vérification des prérequis"
  
  command -v docker      >/dev/null 2>&1 || log_error "Docker non installé"
  command -v docker-compose >/dev/null 2>&1 || \
    (docker compose version >/dev/null 2>&1 || log_error "docker-compose non installé")
  
  log_success "Docker installé: $(docker --version)"
  
  # Vérifier vm.max_map_count pour Elasticsearch/SonarQube
  local max_map_count
  max_map_count=$(cat /proc/sys/vm/max_map_count 2>/dev/null || echo "0")
  
  if [ "$max_map_count" -lt 262144 ]; then
    log_warn "vm.max_map_count trop bas ($max_map_count). Application du correctif..."
    sudo sysctl -w vm.max_map_count=262144
    log_success "vm.max_map_count défini à 262144"
  else
    log_success "vm.max_map_count OK: $max_map_count"
  fi
}

check_env_files() {
  log_step "Vérification des fichiers .env"
  
  local missing=0
  
  for service in jenkins sonarqube vault; do
    if [ ! -f "$SCRIPT_DIR/$service/.env" ]; then
      log_warn ".env manquant pour $service. Copie depuis .env.example..."
      cp "$SCRIPT_DIR/$service/.env.example" "$SCRIPT_DIR/$service/.env"
      log_warn "  → Éditez $service/.env avant de continuer en production !"
      missing=$((missing + 1))
    else
      log_success "$service/.env trouvé"
    fi
  done
  
  if [ $missing -gt 0 ]; then
    log_warn "$missing fichier(s) .env créés depuis les exemples"
    log_warn "Modifiez les mots de passe par défaut avant usage en production !"
  fi
}

start_network() {
  log_step "Démarrage du réseau Docker partagé"
  
  if docker network inspect devsecops-network >/dev/null 2>&1; then
    log_success "Réseau devsecops-network déjà existant"
  else
    cd "$SCRIPT_DIR/network"
    docker compose up -d
    log_success "Réseau devsecops-network créé"
  fi
}

start_vault() {
  log_step "Démarrage de HashiCorp Vault"
  
  cd "$SCRIPT_DIR/vault"
  docker compose up -d $BUILD_FLAG
  
  log_info "Attente du démarrage de Vault..."
  local attempt=0
  while [ $attempt -lt 20 ]; do
    if curl -sf http://localhost:8200/v1/sys/health > /dev/null 2>&1; then
      log_success "Vault opérationnel: http://localhost:8200"
      return 0
    fi
    sleep 3
    attempt=$((attempt + 1))
  done
  
  log_warn "Vault démarré mais peut nécessiter un unseal manuel"
  log_info "  → Lancez: ./vault/scripts/init-vault.sh"
}

start_sonarqube() {
  log_step "Démarrage de SonarQube"
  
  cd "$SCRIPT_DIR/sonarqube"
  docker compose up -d $BUILD_FLAG
  
  log_info "SonarQube démarre (peut prendre 2-3 minutes)..."
  log_info "  → URL: http://localhost:9000"
  log_info "  → Login par défaut: admin / admin"
}

start_jenkins() {
  log_step "Démarrage de Jenkins"
  
  cd "$SCRIPT_DIR/jenkins"
  docker compose up -d $BUILD_FLAG
  
  log_info "Jenkins démarre (peut prendre 1-2 minutes)..."
  log_info "  → URL: http://localhost:8080"
}

show_status() {
  log_step "État de la Stack DevSecOps"
  
  echo ""
  echo -e "  ${BOLD}SERVICE         STATUT          URL${NC}"
  echo    "  ─────────────────────────────────────────────────"
  
  for service in vault sonarqube sonarqube-db jenkins; do
    local status
    status=$(docker inspect -f '{{.State.Status}}' "$service" 2>/dev/null || echo "absent")
    local color="${RED}"
    [ "$status" = "running" ] && color="${GREEN}"
    
    printf "  %-15s ${color}%-15s${NC}\n" "$service" "$status"
  done
  
  echo ""
  echo -e "  ${BOLD}INTERFACES WEB:${NC}"
  echo -e "    Jenkins    → ${CYAN}http://localhost:8080${NC}"
  echo -e "    SonarQube  → ${CYAN}http://localhost:9000${NC}"
  echo -e "    Vault UI   → ${CYAN}http://localhost:8200${NC}"
}

stop_all() {
  log_step "Arrêt de la Stack DevSecOps"
  
  for service in jenkins sonarqube vault; do
    cd "$SCRIPT_DIR/$service"
    docker compose down
    log_success "$service arrêté"
  done
}

print_summary() {
  echo ""
  echo -e "${CYAN}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║          STACK DEVSECOPS DÉMARRÉE AVEC SUCCÈS          ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║                                                          ║"
  echo "║  Jenkins    →  http://localhost:8080                    ║"
  echo "║  SonarQube  →  http://localhost:9000                    ║"
  echo "║  Vault UI   →  http://localhost:8200                    ║"
  echo "║                                                          ║"
  echo "╠══════════════════════════════════════════════════════════╣"
  echo "║  PROCHAINES ÉTAPES:                                      ║"
  echo "║  1. Initialiser Vault: ./vault/scripts/init-vault.sh    ║"
  echo "║  2. Configurer SonarQube: http://localhost:9000         ║"
  echo "║  3. Mettre à jour jenkins/.env avec les tokens          ║"
  echo "║  4. Redémarrer Jenkins pour appliquer la config         ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

# ============================================================
#  EXÉCUTION PRINCIPALE
# ============================================================
main() {
  echo -e "${CYAN}${BOLD}"
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║    DevSecOps Stack - Jenkins + SonarQube + Vault    ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  
  check_prerequisites
  check_env_files
  start_network
  start_vault
  start_sonarqube
  start_jenkins
  show_status
  print_summary
}

main "$@"
