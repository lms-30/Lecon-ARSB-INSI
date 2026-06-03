
## structure des fichiers

```
├── .env

├── docker-compose.yml

├── filebeat.yml

├── logstash.conf

└── metricbeat.yml
```
Elasticsearch et Kibana pourront démarrer à partir du fichier docker-compose, tandis que Filebeat, Metricbeat et Logstash nécessiteront une configuration supplémentaire via des fichiers yml.

## Fichier d'environnement

Nous définirons les variables à transmettre à docker-compose via le fichier .env. Ces paramètres nous permettront de configurer les ports, les limites de mémoire, les versions des composants, etc.
### .env
```
# Password for the 'elastic' user (at least 6 characters)
ELASTIC_PASSWORD=changeme

# Password for the 'kibana_system' user (at least 6 characters)
KIBANA_PASSWORD=changeme

# Version of Elastic products
STACK_VERSION=8.7.1

# Set the cluster name
CLUSTER_NAME=docker-cluster

# Set to 'basic' or 'trial' to automatically start the 30-day trial
LICENSE=basic
#LICENSE=trial

# Port to expose Elasticsearch HTTP API to the host
ES_PORT=9200

# Port to expose Kibana to the host
KIBANA_PORT=5601

# Increase or decrease based on the available host memory (in bytes)
ES_MEM_LIMIT=1073741824
KB_MEM_LIMIT=1073741824
LS_MEM_LIMIT=1073741824


ENCRYPTION_KEY=c34d38b3a14956121ff2170e5030b471551370178f43e5626eec58b04a30fae2

```
- Notons que le mot de passe par défaut « changeme » et la clé d’exemple doivent être modifiés.
- nous spécifions ici les ports **9200** et **5601** pour **Elasticsearch** et **Kibana** respectivement


Nous utilisons ici la variable d'environnement `STACK_VERSION` afin de la transmettre à chaque service (conteneur) de notre fichier `docker-compose.yml`.

Avec Docker, il est préférable de spécifier directement le numéro de version plutôt que d'utiliser une balise comme ` :latest` pour un contrôle optimal de l'environnement. Pour les composants d'Elastic Stack, la balise `:latest` n'est pas prise en charge ; nous avons donc besoin des numéros de version pour extraire les images.

## Configuration et nœud Elasticsearch

### docker-compose.yml (conteneur « setup »)
```
version: "3.8"


volumes:
 certs:
   driver: local
 esdata01:
   driver: local
 kibanadata:
   driver: local
 metricbeatdata01:
   driver: local
 filebeatdata01:
   driver: local
 logstashdata01:
   driver: local


networks:
 default:
   name: elastic
   external: false


services:
 setup:
   image: docker.elastic.co/elasticsearch/elasticsearch:${STACK_VERSION}
   volumes:
     - certs:/usr/share/elasticsearch/config/certs
   user: "0"
   command: >
     bash -c '
       if [ x${ELASTIC_PASSWORD} == x ]; then
         echo "Set the ELASTIC_PASSWORD environment variable in the .env file";
         exit 1;
       elif [ x${KIBANA_PASSWORD} == x ]; then
         echo "Set the KIBANA_PASSWORD environment variable in the .env file";
         exit 1;
       fi;
       if [ ! -f config/certs/ca.zip ]; then
         echo "Creating CA";
         bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip;
         unzip config/certs/ca.zip -d config/certs;
       fi;
       if [ ! -f config/certs/certs.zip ]; then
         echo "Creating certs";
         echo -ne \
         "instances:\n"\
         "  - name: es01\n"\
         "    dns:\n"\
         "      - es01\n"\
         "      - localhost\n"\
         "    ip:\n"\
         "      - 127.0.0.1\n"\
         "  - name: kibana\n"\
         "    dns:\n"\
         "      - kibana\n"\
         "      - localhost\n"\
         "    ip:\n"\
         "      - 127.0.0.1\n"\
         > config/certs/instances.yml;
		 bin/elasticsearch-certutil cert --silent --pem -out                              config/certs/certs.zip --in config/certs/instances.yml --ca-cert                 config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key;
         unzip config/certs/certs.zip -d config/certs;
       fi;
       echo "Setting file permissions"
       chown -R root:root config/certs;
       find . -type d -exec chmod 750 \{\} \;;
       find . -type f -exec chmod 640 \{\} \;;
       echo "Waiting for Elasticsearch availability";
       until curl -s --cacert config/certs/ca/ca.crt https://es01:9200 | grep -q        "missing authentication credentials"; do sleep 30; done;
       echo "Setting kibana_system password";
       until curl -s -X POST --cacert config/certs/ca/ca.crt -u                         "elastic:${ELASTIC_PASSWORD}" -H "Content-Type: application/json"                https://es01:9200/_security/user/kibana_system/_password -d "                    {\"password\":\"${KIBANA_PASSWORD}\"}" | grep -q "^{}"; do sleep 10; done;
       echo "All done!";
     '
   healthcheck:
     test: ["CMD-SHELL", "[ -f config/certs/es01/es01.crt ]"]
     interval: 1s
     timeout: 5s
     retries: 120

```
### docker-compose.yml (conteneur 'es01')
```
 es01:
   depends_on:
     setup:
       condition: service_healthy
   image: docker.elastic.co/elasticsearch/elasticsearch:${STACK_VERSION}
   labels:
     co.elastic.logs/module: elasticsearch
   volumes:
     - certs:/usr/share/elasticsearch/config/certs
     - esdata01:/usr/share/elasticsearch/data
   ports:
     - ${ES_PORT}:9200
   environment:
     - node.name=es01
     - cluster.name=${CLUSTER_NAME}
     - discovery.type=single-node
     - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
     - bootstrap.memory_lock=true
     - xpack.security.enabled=true
     - xpack.security.http.ssl.enabled=true
     - xpack.security.http.ssl.key=certs/es01/es01.key
     - xpack.security.http.ssl.certificate=certs/es01/es01.crt
     - xpack.security.http.ssl.certificate_authorities=certs/ca/ca.crt
     - xpack.security.transport.ssl.enabled=true
     - xpack.security.transport.ssl.key=certs/es01/es01.key
     - xpack.security.transport.ssl.certificate=certs/es01/es01.crt
     - xpack.security.transport.ssl.certificate_authorities=certs/ca/ca.crt
     - xpack.security.transport.ssl.verification_mode=certificate
     - xpack.license.self_generated.type=${LICENSE}
   mem_limit: ${ES_MEM_LIMIT}
   ulimits:
     memlock:
       soft: -1
       hard: -1
   healthcheck:
     test:
       [
         "CMD-SHELL",
         "curl -s --cacert config/certs/ca/ca.crt https://localhost:9200 | grep -q 'missing authentication credentials'",
       ]
     interval: 10s
     timeout: 10s
     retries: 120
```

Maintenant, lançons `docker-compose up`.

### Dépannage des erreurs de configuration de la mémoire virtuelle

Lors du premier démarrage du nœud Elasticsearch, de nombreux utilisateurs rencontrent des difficultés lors de la configuration de la mémoire virtuelle et reçoivent un message d'erreur tel que :

```
{"@timestamp":"2023-04-14T13:16:22.148Z", "log.level":"ERROR", "message":"node validation exception\n[1] bootstrap checks failed. You must address the points described in the following [1] lines before starting Elasticsearch.\nbootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server","process.thread.name":"main","log.logger":"org.elasticsearch.bootstrap.Elasticsearch","elasticsearch.node.name":"es01","elasticsearch.cluster.name":"docker-cluster"}
```
Le point essentiel à retenir ici est que la taille maximale des zones de mémoire virtuelle vm.max_map_count [65530] est trop faible, augmentez-la à au moins [262144].

En définitive, la commande sysctl -w vm.max_map_count=262144 doit être exécutée à l'endroit où les conteneurs sont hébergés.

N'oubliez pas que le conteneur d'installation s'arrêtera intentionnellement une fois la génération des certificats et des mots de passe terminée.

Nous pouvons utiliser une commande pour copier le fichier ca.crt hors du conteneur es01-1. N'oubliez pas que le nom de l'ensemble de conteneurs dépend du répertoire depuis lequel le fichier docker-compose.yml est exécuté. Par exemple, mon répertoire est « elasticstack_docker », ma commande ressemblerait donc à ceci, d'après la capture d'écran ci-dessus :
```
docker cp es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt /tmp/.
```

Une fois le certificat téléchargé, exécutez une commande curl pour interroger le nœud Elasticsearch :
```
curl --cacert /tmp/ca.crt -u elastic:changeme https://localhost:9200
```
Notez que nous accédons à Elasticsearch via **localhost** :9200

## Kibana

Pour la configuration de Kibana, nous utiliserons le certificat généré précédemment. Nous préciserons également que ce nœud ne démarrera que lorsqu'il aura vérifié que le nœud Elasticsearch mentionné ci-dessus est opérationnel.

### docker-compose.yml (conteneur 'kibana')
```
kibana:
   depends_on:
     es01:
       condition: service_healthy
   image: docker.elastic.co/kibana/kibana:${STACK_VERSION}
   labels:
     co.elastic.logs/module: kibana
   volumes:
     - certs:/usr/share/kibana/config/certs
     - kibanadata:/usr/share/kibana/data
   ports:
     - ${KIBANA_PORT}:5601
   environment:
     - SERVERNAME=kibana
     - ELASTICSEARCH_HOSTS=https://es01:9200
     - ELASTICSEARCH_USERNAME=kibana_system
     - ELASTICSEARCH_PASSWORD=${KIBANA_PASSWORD}
     - ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES=config/certs/ca/ca.crt
     - XPACK_SECURITY_ENCRYPTIONKEY=${ENCRYPTION_KEY}
     - XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY=${ENCRYPTION_KEY}
     - XPACK_REPORTING_ENCRYPTIONKEY=${ENCRYPTION_KEY}
   mem_limit: ${KB_MEM_LIMIT}
   healthcheck:
     test:
       [
         "CMD-SHELL",
         "curl -s -I http://localhost:5601 | grep -q 'HTTP/1.1 302 Found'",
       ]
     interval: 10s
     timeout: 10s
     retries: 120
```
Dans notre section `environment`, notez que nous spécifions `ELASTICSEARCH_HOSTS=https://es01:9200`.

Une simple connexion avec l'identifiant et le mot de passe fournis devrait nous permettre d'accéder directement à une nouvelle instance de Kibana.

## Metricbeat

Lorsque Kibana et Elasticsearch sont opérationnels et communiquent entre eux, configurons Metricbeat pour assurer une surveillance continue.

Cela nécessitera une configuration dans notre fichier docker-compose, ainsi que dans un fichier metricbeat.yml distinct .

### docker-compose.yml (conteneur 'metricbeat01')
```
 metricbeat01:
   depends_on:
     es01:
       condition: service_healthy
     kibana:
       condition: service_healthy
   image: docker.elastic.co/beats/metricbeat:${STACK_VERSION}
   user: root
   volumes:
     - certs:/usr/share/metricbeat/certs
     - metricbeatdata01:/usr/share/metricbeat/data
     - "./metricbeat.yml:/usr/share/metricbeat/metricbeat.yml:ro"
     - "/var/run/docker.sock:/var/run/docker.sock:ro"
     - "/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro"
     - "/proc:/hostfs/proc:ro"
     - "/:/hostfs:ro"
   environment:
     - ELASTIC_USER=elastic
     - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
     - ELASTIC_HOSTS=https://es01:9200
     - KIBANA_HOSTS=http://kibana:5601
     - LOGSTASH_HOSTS=http://logstash01:9600
```
ci, nous exposons au conteneur Metricbeat, en lecture seule, les informations de l'hôte concernant les processus, le système de fichiers et le démon Docker. Cela permet à Metricbeat de collecter les données à envoyer à Elasticsearch.

### metricbeat.yml
```
metricbeat.config.modules:
 path: ${path.config}/modules.d/*.yml
 reload.enabled: false


metricbeat.modules:
- module: elasticsearch
 xpack.enabled: true
 period: 10s
 hosts: ${ELASTIC_HOSTS}
 ssl.certificate_authorities: "certs/ca/ca.crt"
 ssl.certificate: "certs/es01/es01.crt"
 ssl.key: "certs/es01/es01.key"
 username: ${ELASTIC_USER}
 password: ${ELASTIC_PASSWORD}
 ssl.enabled: true


- module: logstash
 xpack.enabled: true
 period: 10s
 hosts: ${LOGSTASH_HOSTS}


- module: kibana
 metricsets:
   - stats
 period: 10s
 hosts: ${KIBANA_HOSTS}
 username: ${ELASTIC_USER}
 password: ${ELASTIC_PASSWORD}
 xpack.enabled: true


- module: docker
 metricsets:
   - "container"
   - "cpu"
   - "diskio"
   - "healthcheck"
   - "info"
   #- "image"
   - "memory"
   - "network"
 hosts: ["unix:///var/run/docker.sock"]
 period: 10s
 enabled: true


processors:
 - add_host_metadata: ~
 - add_docker_metadata: ~


output.elasticsearch:
 hosts: ${ELASTIC_HOSTS}
 username: ${ELASTIC_USER}
 password: ${ELASTIC_PASSWORD}
 ssl:
   certificate: "certs/es01/es01.crt"
   certificate_authorities: "certs/ca/ca.crt"
   key: "certs/es01/es01.key"
```
Notre instance Metricbeat nécessite que les nœuds ES01 et Kibana soient opérationnels avant son démarrage.

N'oubliez pas de définir vos règles originales !
![[Pasted image 20251120102424.png]]
![[Pasted image 20251120102453.png]]

Metricbeat est également configuré pour surveiller l'hôte du conteneur via /var/run/docker.sock. La vérification d'Elastic Observability vous permet de visualiser les métriques provenant de votre hôte.
![[image8.png]]

## Filebeat

Maintenant que le cluster est stable et supervisé par Metricbeat, examinons Filebeat pour l'ingestion des journaux. Filebeat sera utilisé ici de deux manières différentes :

### docker-compose.yml (conteneur 'filebeat01')
```
 filebeat01:
   depends_on:
     es01:
       condition: service_healthy
   image: docker.elastic.co/beats/filebeat:${STACK_VERSION}
   user: root
   volumes:
     - certs:/usr/share/filebeat/certs
     - filebeatdata01:/usr/share/filebeat/data
     - "./filebeat_ingest_data/:/usr/share/filebeat/ingest_data/"
     - "./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro"
     - "/var/lib/docker/containers:/var/lib/docker/containers:ro"
     - "/var/run/docker.sock:/var/run/docker.sock:ro"
   environment:
     - ELASTIC_USER=elastic
     - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
     - ELASTIC_HOSTS=https://es01:9200
     - KIBANA_HOSTS=http://kibana:5601
     - LOGSTASH_HOSTS=http://logstash01:9600
```
## fichierbeat.yml
```
filebeat.inputs:
- type: filestream
 id: default-filestream
 paths:
   - ingest_data/*.log


filebeat.autodiscover:
 providers:
   - type: docker
     hints.enabled: true


processors:
- add_docker_metadata: ~


setup.kibana:
 host: ${KIBANA_HOSTS}
 username: ${ELASTIC_USER}
 password: ${ELASTIC_PASSWORD}


output.elasticsearch:
 hosts: ${ELASTIC_HOSTS}
 username: ${ELASTIC_USER}
 password: ${ELASTIC_PASSWORD}
 ssl.enabled: true
 ssl.certificate_authorities: "certs/ca/ca.crt"
```
## Logstash

Notre dernier conteneur à donner vie n'est autre que Logstash.

### docker-compose.yml (conteneur 'logstash01')
```
 logstash01:
   depends_on:
     es01:
       condition: service_healthy
     kibana:
       condition: service_healthy
   image: docker.elastic.co/logstash/logstash:${STACK_VERSION}
   labels:
     co.elastic.logs/module: logstash
   user: root
   volumes:
     - certs:/usr/share/logstash/certs
     - logstashdata01:/usr/share/logstash/data
     - "./logstash_ingest_data/:/usr/share/logstash/ingest_data/"
     - "./logstash.conf:/usr/share/logstash/pipeline/logstash.conf:ro"
   environment:
     - xpack.monitoring.enabled=false
     - ELASTIC_USER=elastic
     - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
     - ELASTIC_HOSTS=https://es01:9200
```
### logstash.conf
```
input {
 file {
   #https://www.elastic.co/guide/en/logstash/current/plugins-inputs-file.html
   #default is TAIL which assumes more data will come into the file.
   #change to mode => "read" if the file is a compelte file.  by default, the file will be removed once reading is complete -- backup your files if you need them.
   mode => "tail"
   path => "/usr/share/logstash/ingest_data/*"
 }
}


filter {
}


output {
 elasticsearch {
   index => "logstash-%{+YYYY.MM.dd}"
   hosts=> "${ELASTIC_HOSTS}"
   user=> "${ELASTIC_USER}"
   password=> "${ELASTIC_PASSWORD}"
   cacert=> "certs/ca/ca.crt"
 }
}
```
La configuration de Logstash est très similaire à celle de Filebeat. Nous utilisons également un montage de volume et mappons un dossier nommé `/logstash_ingest_data/` de l'hôte vers le conteneur Logstash. Vous pouvez tester les nombreux plugins [d'entrée](https://www.elastic.co/guide/en/logstash/current/input-plugins.html) et [de filtrage](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html) en modifiant le fichier `logstash.yml` . Déposez ensuite vos données dans le dossier `/logstash_ingest_data/` . Il peut être nécessaire de redémarrer le conteneur Logstash après la modification du fichier `logstash.yml` .  
  
Notez que le nom de l'index de sortie de Logstash est « logstash-%{+YYYY.MM.dd} ». Pour visualiser les données, vous devrez [créer une vue de données](https://www.elastic.co/guide/en/kibana/current/data-views.html#settings-create-pattern) pour le modèle « logstash-* », comme indiqué ci-dessous.