Installer localement Ansible et puller une image debian et ubuntu à partir script Ansible

**1. Installer Ansible localement**
```
sudo apt update
sudo apt install -y ansible

```
**Vérification :**
```
ansible --version
```
**2. Vérifier l’inventaire local**

Ansible peut travailler **en local**, sans serveur distant.

Crée un inventaire simple :
```
mkdir ansible-docker
cd ansible-docker
nano hosts

```
**Contenu du fichier `hosts` :**
```
[local]
localhost ansible_connection=local

```
**3. Installer la collection Docker pour Ansible**

Ansible utilise des **modules** → pour Docker, on installe une collection officielle.
```
ansible-galaxy collection install community.docker

```
**4. Créer le playbook Ansible**
Crée le fichier :
```
nano pull_images.yml

```
Contenu du playbook :
```
---
- name: Pull images Debian et Ubuntu avec Ansible
  hosts: local
  become: false

  tasks:
    - name: Pull image Debian
      community.docker.docker_image:
        name: debian
        tag: latest
        source: pull

    - name: Pull image Ubuntu
      community.docker.docker_image:
        name: ubuntu
        tag: latest
        source: pull

```

**5. Exécuter le script Ansible :**
```
ansible-playbook -i hosts pull_images.yml

```

