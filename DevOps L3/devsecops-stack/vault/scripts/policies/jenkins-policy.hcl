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
