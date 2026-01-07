La vulnérabilité CVE-2025-1974 a été identifiée en corrélant la version du contrôleur Kubernetes Ingress-NGINX installée avec les bases de données publiques de vulnérabilités.  
Cette vulnérabilité correspond à une exécution de code à distance non authentifiée au niveau du contrôleur d’admission Ingress-NGINX, permettant à un attaquant distant d’envoyer des requêtes AdmissionReview malveillantes afin d’injecter des configurations Ingress non autorisées. Combinée à d’autres vulnérabilités (CVE-2025-24514, CVE-2025-1097 ou CVE-2025-1098), elle peut conduire à une compromission complète du cluster Kubernetes.


