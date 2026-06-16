### Installation
1. Téléchargez et exécutez l'assistant d'installation de Wazuh.
```
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```

Une fois l'assistant terminé l'installation, la sortie affiche les informations d'accès et un message qui confirme que l'installation a été réussie. Et afficher l’identifiant de l'admin et son mot de passe.

2. Accédez à l'interface Web de Wazuh avec `https://<WAZUH_DASHBOARD_IP_ADDRESS>` et se connecter en tant que administrateur

- **Nom d'utilisateur** : `admin`
    
- **Mot de passe** : `<ADMIN_PASSWORD>`


### Déploiement

Déploiement d'agents Wazuh sur les terminaux Linux

1. Ajoutez le dépôt Wazuh pour télécharger les paquets officiels.

- Installez les paquets suivants en cas de manquant:
```
apt-get install gnupg apt-transport-https
```
- Installez la clé GPG
```
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
```
- Ajouter le dépôt
```
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
```
- Mettre à jour les informations du paquet:
```
apt-get update
```

2. Déployer un agent de Wazuh

- Sélectionnez votre gestionnaire de paquets et exécutez la commande ci-dessous. Remplacer le `WAZUH_MANAGER`valeur avec votre adresse IP ou nom d'hôte Wazuh manager:
```
WAZUH_MANAGER="10.0.0.2" apt-get install wazuh-agent
```
- Activez et démarrez le service d'agent Wazuh.
```
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent
```

### Utilisation basique
