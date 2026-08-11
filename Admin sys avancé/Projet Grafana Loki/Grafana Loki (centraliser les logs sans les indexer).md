## Démarrer Loki en local

Le plus simple est un conteneur unique avec un stockage sur disque. On écrit d'abord une configuration minimale de **développement** : authentification désactivée, anneau en mémoire, index **TSDB** et stockage **filesystem**.

loki-config.yaml :
```
auth_enabled: false

server:
  http_listen_port: 3100

common:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory
  replication_factor: 1
  path_prefix: /loki

schema_config:
  configs:
    - from: 2026-08-10
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  filesystem:
    directory: /loki/chunks

limits_config:
  retention_period: 168h  # 7 jours
```

On lance ensuite Loki en épinglant la version, pour un résultat **reproductible** :
```
docker run -d --name loki -p 3100:3100 \
  -v "$(pwd)/loki-config.yaml:/etc/loki/config.yaml" \
  grafana/loki:3.7.3 -config.file=/etc/loki/config.yaml
```

**Vérification** : `curl http://localhost:3100/ready` doit répondre `ready`
![[Pasted image 20260810090739.png]]

## L'architecture de Loki

Loki repose sur **trois briques** complémentaires. Comprendre leur rôle aide à diagnostiquer un flux de logs qui n'arrive pas.

| Composant         | Rôle                                                          |
| ----------------- | ------------------------------------------------------------- |
| **Grafana Alloy** | Agent qui collecte les logs et les pousse vers Loki           |
| **Loki**          | Stocke les logs, les organise par labels, répond aux requêtes |
| **Grafana**       | Interface de requête et de visualisation                      |
### Les labels, clé de voûte de Loki

**Loki n'indexe pas le contenu des logs, il les range par labels**, exactement comme Prometheus range ses métriques. Un flux de logs est identifié par un ensemble de labels :

```
{namespace="production", app="frontend", pod="frontend-abc123"}
```

Ces labels permettent de **filtrer** rapidement, de **corréler** avec les métriques Prometheus (mêmes labels) et de **réduire les coûts** (pas d'index massif). Leur choix est donc décisif, et c'est aussi là que se cache le principal piège, la cardinalité, détaillé plus bas.

## Collecter les logs avec Grafana Alloy

**Grafana Alloy est l'agent de collecte recommandé, successeur de Promtail** (déprécié depuis 2025). C'est un collecteur unifié, bâti sur l'OpenTelemetry Collector, qui rassemble logs, métriques et traces. On le configure en déclarant une **source** de logs et une **destination** `loki.write`.

L'exemple ci-dessous lit tous les fichiers `.log` d'un dossier, leur attache le label `app`, et les pousse vers Loki :

config.alloy

```
local.file_match "app" {
  path_targets = [{"__path__" = "/logs/*.log", "app" = "demo"}]
}

loki.source.file "app" {
  targets    = local.file_match.app.targets
  forward_to = [loki.write.default.receiver]
}

loki.write "default" {
  endpoint {
    url = "http://loki:3100/loki/api/v1/push"
  }
}
```


On lance Alloy en montant la configuration et les logs à collecter :
```
docker run -d --name alloy \
  -v "$(pwd)/config.alloy:/etc/alloy/config.alloy" \
  -v "$(pwd)/logs:/logs" \
  grafana/alloy:v1.17.1 \
  run /etc/alloy/config.alloy
```
