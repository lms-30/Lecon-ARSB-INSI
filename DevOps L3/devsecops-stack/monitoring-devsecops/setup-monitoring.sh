#!/usr/bin/env bash
# ============================================================
#  MONITORING - SCRIPT DE CONFIGURATION POST-DÉMARRAGE
#  Configure Vault pour exposer ses métriques à Prometheus
# ============================================================

set -uo pipefail

VAULT_TOKEN="${VAULT_TOKEN:-hvs.KOtoq0LtmmtZ7c5WdM4uD6Hq}"
GREEN='\033[0;32m'; BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $1"; }
log_step()    { echo -e "\n${CYAN}▶ $1${NC}"; }

v() { docker exec -e VAULT_TOKEN="$VAULT_TOKEN" -e VAULT_ADDR="http://127.0.0.1:8200" vault vault "$@"; }

# ============================================================
#  1. TOKEN PROMETHEUS POUR VAULT
# ============================================================
setup_vault_metrics() {
  log_step "Configuration des métriques Vault pour Prometheus"

  # Politique lecture métriques
  docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault policy write prometheus-metrics - << 'EOF'
path "sys/metrics" {
  capabilities = ["read"]
}
EOF

  # Token dédié Prometheus (longue durée)
  PROM_TOKEN=$(v token create \
    -policy=prometheus-metrics \
    -ttl=8760h \
    -format=json | jq -r '.auth.client_token')

  # Sauvegarder pour Prometheus
  echo "$PROM_TOKEN" > prometheus/vault_token
  log_success "Token Vault pour Prometheus créé: prometheus/vault_token"
}

# ============================================================
#  2. IMPORTER LES DASHBOARDS GRAFANA COMMUNAUTAIRES
# ============================================================
import_grafana_dashboards() {
  log_step "Import des dashboards Grafana communautaires"

  local grafana_url="http://localhost:3000"
  local credentials="admin:${GRAFANA_ADMIN_PASSWORD:-Grafana@DevSecOps2026!}"

  # Attendre Grafana
  local attempt=0
  while [ $attempt -lt 20 ]; do
    if curl -sf "$grafana_url/api/health" > /dev/null 2>&1; then
      break
    fi
    sleep 3
    attempt=$((attempt+1))
  done

  # Dashboard Node Exporter (ID: 1860)
  curl -sf -u "$credentials" \
    -X POST "$grafana_url/api/dashboards/import" \
    -H "Content-Type: application/json" \
    -d '{
      "dashboard": null,
      "folderId": 0,
      "overwrite": true,
      "inputs": [{"name": "DS_PROMETHEUS", "type": "datasource", "pluginId": "prometheus", "value": "Prometheus"}],
      "id": 1860
    }' > /dev/null && log_success "Dashboard Node Exporter importé (ID: 1860)" || true

  # Dashboard cAdvisor (ID: 14282)
  curl -sf -u "$credentials" \
    -X POST "$grafana_url/api/dashboards/import" \
    -H "Content-Type: application/json" \
    -d '{
      "dashboard": null,
      "folderId": 0,
      "overwrite": true,
      "inputs": [{"name": "DS_PROMETHEUS", "type": "datasource", "pluginId": "prometheus", "value": "Prometheus"}],
      "id": 14282
    }' > /dev/null && log_success "Dashboard Docker cAdvisor importé (ID: 14282)" || true

  log_success "Dashboards importés !"
}

# ============================================================
#  MAIN
# ============================================================
main() {
  echo -e "${CYAN}"
  echo "╔══════════════════════════════════════════════════╗"
  echo "║    Monitoring - Configuration post-démarrage    ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo -e "${NC}"

  setup_vault_metrics
  import_grafana_dashboards

  echo ""
  log_success "Configuration monitoring terminée !"
  echo ""
  echo -e "  Grafana     → ${CYAN}http://localhost:3000${NC}  (admin / Grafana@DevSecOps2026!)"
  echo -e "  Prometheus  → ${CYAN}http://localhost:9090${NC}"
  echo -e "  Alertmanager→ ${CYAN}http://localhost:9093${NC}"
}

main "$@"
