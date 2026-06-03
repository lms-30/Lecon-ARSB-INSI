# ============================================================
#  VAULT POLICY - JENKINS
#  Permissions minimales pour Jenkins (principe du moindre privilège)
# ============================================================

# Secrets des projets Jenkins (lecture seule)
path "secret/data/jenkins/*" {
  capabilities = ["read", "list"]
}

# Secrets d'infrastructure (lecture seule)
path "infra/data/*" {
  capabilities = ["read", "list"]
}

# Lister les secrets disponibles
path "secret/metadata/*" {
  capabilities = ["list"]
}

path "infra/metadata/*" {
  capabilities = ["list"]
}

# Gestion du token AppRole
path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}
