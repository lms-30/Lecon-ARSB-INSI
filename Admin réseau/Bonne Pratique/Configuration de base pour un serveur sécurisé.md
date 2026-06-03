# Configuration de base pour un serveur sécurisé

Voici les configurations essentielles à mettre en place pour sécuriser un nouveau serveur :

## Sécurité système

**Mise à jour du système** - Entreprendre par mettre à jour tous les paquets existants pour corriger les vulnérabilités connues.

**Création d'un utilisateur non-root** - Ne jamais utiliser root pour les opérations quotidiennes. Créez un utilisateur avec droits sudo limités.

**Configuration SSH sécurisée** - Désactivez l'authentification par mot de passe et l'accès root direct via SSH. Utilisez uniquement l'authentification par clés SSH. Changez le port par défaut (22) si nécessaire et limitez les utilisateurs autorisés.

**Pare-feu (firewall)** - Configurez iptables ou ufw pour bloquer tout le trafic par défaut, puis ouvrez uniquement les ports nécessaires à vos services (par exemple : 80/443 pour HTTP/HTTPS, votre port SSH personnalisé).

**Fail2ban** - Installer ce service pour bannir automatiquement les IP qui tentent des connexions malveillantes répétées.

**Désactivation des services inutiles** - Arrêtez et désactivez tous les services qui ne sont pas nécessaires pour réduire la surface d'attaque.

## Configuration réseau

**Adresse IP fixe** - Configurez une IP statique pour garantir la stabilité du service.

**Configuration DNS** - Définissez des serveurs DNS fiables (par exemple : 8.8.8.8, 1.1.1.1 ou ceux de votre hébergeur).

**Hostname approprié** - Définissez un nom d'hôte cohérent avec votre infrastructure.

**Limitation du débit et protection DDoS** - Configurez des limites de connexions simultanées pour prévenir les attaques par déni de service.

## Surveillance et journaux

**Centralisation des logs** - Configurez syslog ou un système de journalisation centralisé pour surveiller l'activité du serveur.

**Système de surveillance** - Mettez en place des outils de surveillance (CPU, RAM, disque, réseau) pour détecter les anomalies.

**Sauvegardes automatiques** - Planifiez des sauvegardes régulières de vos données et configurations critiques.

## Bonnes pratiques supplémentaires

**SELinux ou AppArmor** - Activez ces systèmes de contrôle d'accès obligatoire selon votre distribution.

**Chiffrement des communications** - Utilisez exclusivement SSL/TLS pour les services web et autres protocoles sensibles.

**Politique de mots de passe forte** - Imposer des mots de passe complexes et leur renouvellement régulier.

**Audits de sécurité réguliers** - Planifiez des scans de vulnérabilités et des revues de configuration périodiques.


# Exemple Script Ansible pour sécuriser un serveur

Je vais vous créer un playbook Ansible complet pour automatiser la sécurisation de votre serveur.

### 2. Créer les fichiers

Créez trois fichiers dans ce dossier :

1. `securiser-serveur.yml`- Le playbook principal
```
---
- name: Configuration et sécurisation d'un serveur Linux
  hosts: all
  become: yes
  vars:
    # Variables à personnaliser
    admin_user: "admin"
    ssh_port: 2222
    allowed_ssh_users: "admin"
    
  tasks:
    # ===== MISE À JOUR DU SYSTÈME =====
    - name: Mise à jour du cache des paquets (Debian/Ubuntu)
      apt:
        update_cache: yes
        cache_valid_time: 3600
      when: ansible_os_family == "Debian"

    - name: Mise à jour de tous les paquets
      apt:
        upgrade: dist
        autoremove: yes
      when: ansible_os_family == "Debian"

    # ===== CRÉATION UTILISATEUR ADMIN =====
    - name: Créer un utilisateur administrateur
      user:
        name: "{{ admin_user }}"
        shell: /bin/bash
        groups: sudo
        append: yes
        create_home: yes
        state: present

    - name: Créer le répertoire .ssh pour l'utilisateur
      file:
        path: "/home/{{ admin_user }}/.ssh"
        state: directory
        owner: "{{ admin_user }}"
        group: "{{ admin_user }}"
        mode: '0700'

    - name: Ajouter la clé SSH publique
      authorized_key:
        user: "{{ admin_user }}"
        state: present
        key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
      ignore_errors: yes

    - name: Configurer sudo sans mot de passe pour l'utilisateur admin
      lineinfile:
        path: /etc/sudoers.d/{{ admin_user }}
        line: "{{ admin_user }} ALL=(ALL) NOPASSWD:ALL"
        create: yes
        mode: '0440'
        validate: 'visudo -cf %s'

    # ===== CONFIGURATION SSH SÉCURISÉE =====
    - name: Sauvegarder la configuration SSH originale
      copy:
        src: /etc/ssh/sshd_config
        dest: /etc/ssh/sshd_config.backup
        remote_src: yes
        force: no

    - name: Configurer SSH - Désactiver root login
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PermitRootLogin'
        line: 'PermitRootLogin no'
        state: present

    - name: Configurer SSH - Désactiver authentification par mot de passe
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PasswordAuthentication'
        line: 'PasswordAuthentication no'
        state: present

    - name: Configurer SSH - Changer le port
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?Port'
        line: "Port {{ ssh_port }}"
        state: present

    - name: Configurer SSH - Limiter les utilisateurs autorisés
      lineinfile:
        path: /etc/ssh/sshd_config
        line: "AllowUsers {{ allowed_ssh_users }}"
        state: present

    - name: Redémarrer le service SSH
      service:
        name: ssh
        state: restarted
        enabled: yes

    # ===== INSTALLATION ET CONFIGURATION FIREWALL =====
    - name: Installer UFW
      apt:
        name: ufw
        state: present
      when: ansible_os_family == "Debian"

    - name: Configurer UFW - Autoriser le nouveau port SSH
      ufw:
        rule: allow
        port: "{{ ssh_port }}"
        proto: tcp

    - name: Configurer UFW - Autoriser HTTP
      ufw:
        rule: allow
        port: '80'
        proto: tcp

    - name: Configurer UFW - Autoriser HTTPS
      ufw:
        rule: allow
        port: '443'
        proto: tcp

    - name: Activer UFW
      ufw:
        state: enabled
        policy: deny

    # ===== INSTALLATION FAIL2BAN =====
    - name: Installer Fail2ban
      apt:
        name: fail2ban
        state: present
      when: ansible_os_family == "Debian"

    - name: Créer la configuration locale de Fail2ban
      copy:
        dest: /etc/fail2ban/jail.local
        content: |
          [DEFAULT]
          bantime = 3600
          findtime = 600
          maxretry = 5
          
          [sshd]
          enabled = true
          port = {{ ssh_port }}
          logpath = %(sshd_log)s
          backend = %(sshd_backend)s
        mode: '0644'

    - name: Démarrer et activer Fail2ban
      service:
        name: fail2ban
        state: restarted
        enabled: yes

    # ===== DÉSACTIVATION DES SERVICES INUTILES =====
    - name: Lister les services inutiles à désactiver
      service:
        name: "{{ item }}"
        state: stopped
        enabled: no
      loop:
        - avahi-daemon
        - cups
        - bluetooth
      ignore_errors: yes

    # ===== CONFIGURATION RÉSEAU =====
    - name: Définir le hostname
      hostname:
        name: "{{ inventory_hostname }}"

    - name: Configurer les serveurs DNS
      lineinfile:
        path: /etc/resolv.conf
        line: "{{ item }}"
        create: yes
      loop:
        - "nameserver 8.8.8.8"
        - "nameserver 8.8.4.4"
        - "nameserver 1.1.1.1"

    # ===== SÉCURITÉ SYSTÈME =====
    - name: Installer des outils de sécurité essentiels
      apt:
        name:
          - unattended-upgrades
          - logwatch
          - aide
          - rkhunter
        state: present
      when: ansible_os_family == "Debian"

    - name: Configurer les mises à jour automatiques
      copy:
        dest: /etc/apt/apt.conf.d/50unattended-upgrades
        content: |
          Unattended-Upgrade::Allowed-Origins {
              "${distro_id}:${distro_codename}-security";
          };
          Unattended-Upgrade::AutoFixInterruptedDpkg "true";
          Unattended-Upgrade::Remove-Unused-Dependencies "true";
        mode: '0644'

    # ===== LIMITES DE SÉCURITÉ =====
    - name: Configurer les limites système
      pam_limits:
        domain: '*'
        limit_type: hard
        limit_item: nproc
        value: '100'

    - name: Désactiver IPv6 si non utilisé
      sysctl:
        name: "{{ item }}"
        value: '1'
        state: present
        reload: yes
      loop:
        - net.ipv6.conf.all.disable_ipv6
        - net.ipv6.conf.default.disable_ipv6

    - name: Activer la protection SYN flood
      sysctl:
        name: net.ipv4.tcp_syncookies
        value: '1'
        state: present
        reload: yes

    # ===== MESSAGE FINAL =====
    - name: Afficher un message de confirmation
      debug:
        msg: |
          ================================================
          Configuration terminée avec succès !
          ================================================
          - Utilisateur admin créé: {{ admin_user }}
          - Port SSH changé: {{ ssh_port }}
          - Firewall activé (UFW)
          - Fail2ban configuré
          - Mises à jour automatiques activées
          
          IMPORTANT: Testez la connexion SSH sur le nouveau port
          avant de fermer cette session !
          
          Commande de test:
          ssh -p {{ ssh_port }} {{ admin_user }}@{{ inventory_hostname }}
          ================================================
```
## ⚙️ Ce que fait le playbook

- ✅ Met à jour le système
- ✅Créez un utilisateur admin avec sudo
- ✅ Sécuriser SSH (root désactif, changer le port)
- ✅ Configurer le pare-feu UFW
- ✅ Installer et configurer Fail2ban
- ✅ Désactivez les services inutiles
- ✅ Configurer le DNS
- ✅ Activez les mises à jour automatiques
- ✅ Renforcer la sécurité réseau



2. `hosts.ini`- L'inventaire des serveurs

Parfait ! Voici le playbook Ansible complet. Maintenant, créons également les fichiers nécessaires pour l'utiliser :
```
# Fichier d'inventaire Ansible
# Remplacez les valeurs par vos vraies informations

[servers]
# Format: nom_serveur ansible_host=IP_DU_SERVEUR
serveur1 ansible_host=192.168.1.100
# serveur2 ansible_host=192.168.1.101

[servers:vars]
# Variables communes à tous les serveurs
ansible_user=root
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3

# Si vous utilisez un port SSH non-standard pour la connexion initiale
# ansible_port=22
```

**Important** : Avant d'exécuter, modifiez les variables `admin_user`, `ssh_port`et `allowed_ssh_users`dans le playbook selon vos préférences !