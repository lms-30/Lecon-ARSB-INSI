ui = true

storage "file" {
  path = "/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr     = "http://vault:8200"
cluster_addr = "http://vault:8201"
log_level    = "info"

telemetry {
  disable_hostname          = true
  prometheus_retention_time = "30s"
}
