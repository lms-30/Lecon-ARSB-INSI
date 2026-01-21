
1. **Teraform** (IaC = Infrestrucure as Code) : un outil open source d'**Infrastructure as Code (IaC)** de HashiCorp qui permet de décrire, provisionner et gérer l'infrastructure cloud et on-premise (réseaux, machines virtuelles, bases de données) de manière automatisée, déclarative et reproductible à partir de fichiers de configuration
idempontants : il n'exécute qu'un seul fois une tâche (il n’exécute une tâche qu'il a déjà exécuté)

	main.tf : fochier pour constriure l'infrastructure as code

- EC2
- S3
- IAM
2. **Ansible** (configuration management) : un puissant outil open-source d'automatisation qui simplifie la gestion des configurations, le déploiement d'applications et l'orchestration de tâches informatiques complexes sur des serveurs

	playbook.yml : fichier responsable d'installation et configuration 
	inventory.ini : fichier pour déclaré l'adresse IP des machine qu'on va faire des installations ou un configuration
3. **Jenkins** :  (CI/CD avancé)
	jenkinsfile : fichier de configuration de jenkins
 4. **Github** : (versionning)
 5. **Trivy** (scan de vulnérabilité image docker) : 
6. **SonorQube** : une plateforme open-source essentielle pour l'**analyse continue de la qualité et de la sécurité du code source**
7. **DockerHub** (Registry)
