La sécurité informatique regroupe l'ensemble des techniques, outils, politiques et procédures mise en oeuvre pour protéger les systèmes informatiques, les réseaux, et les données.

---

# 🧠 1. Rappel : Asterisk et sécurité

**Asterisk** est un serveur de téléphonie (VoIP).  
Il utilise principalement :

- SIP (port **5060 UDP**) → signalisation
- RTP (ports **10000–20000 UDP**) → audio

👉 Problème : exposé sur Internet = **très ciblé par les attaques**

---

# ⚠️ 2. Menaces principales

Sur un serveur Asterisk mal sécurisé :

### 🔴 a) Bruteforce SIP

- Attaquant teste des mots de passe
- Exemple : extensions 1000, 1001…

### 🔴 b) Toll fraud (fraude téléphonique)

- Appels internationaux → facture énorme

### 🔴 c) Scan SIP

- Détection automatique des ports ouverts

---

# 🔥 3. Rôle de iptables

**iptables** = pare-feu Linux  
👉 Permet de **contrôler le trafic réseau entrant/sortant**

Objectif :

- Bloquer les IP malveillantes
- Autoriser uniquement ce qui est nécessaire

---

# 🧱 4. Structure des règles iptables

Les chaînes principales :

- `INPUT` → trafic entrant
- `OUTPUT` → trafic sortant
- `FORWARD` → routage

Les actions :

- `ACCEPT` → autoriser
- `DROP` → bloquer silencieusement
- `REJECT` → bloquer avec réponse

---

# ⚙️ 5. Configuration de base (sécurisée)

## 🧹 a) Reset des règles

```
iptables -F  
iptables -X  
iptables -Z
```

---

## 🔒 b) Politique par défaut (très important)

```
iptables -P INPUT DROP  
iptables -P OUTPUT ACCEPT  
iptables -P FORWARD DROP

```
👉 Tout est bloqué sauf ce qu’on autorise

---

## ✅ c) Autoriser le trafic local

```
iptables -A INPUT -i lo -j ACCEPT
```

---

## 🔁 d) Autoriser connexions établies

```
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

👉 essentiel pour ne pas casser les connexions

---

# ☎️ 6. Autoriser Asterisk (SIP + RTP)

## 📡 SIP (port 5060 UDP)

```
iptables -A INPUT -p udp --dport 5060 -j ACCEPT
```

---

## 🔊 RTP (audio)

```
iptables -A INPUT -p udp --dport 10000:20000 -j ACCEPT
```

---

# 🛡️ 7. Sécurisation avancée (TRÈS IMPORTANT)

## 🚫 a) Limiter les attaques bruteforce SIP

```
iptables -A INPUT -p udp --dport 5060 -m recent --name SIP --set  
iptables -A INPUT -p udp --dport 5060 -m recent --name SIP --update --seconds 60 --hitcount 10 -j DROP
```

👉 Si une IP fait +10 requêtes en 60 sec → bloquée

---

## 🌍 b) Autoriser uniquement certaines IP (idéal)

Exemple : ton IP ou réseau

```
iptables -A INPUT -p udp -s 192.168.1.0/24 --dport 5060 -j ACCEPT  
iptables -A INPUT -p udp --dport 5060 -j DROP
```

👉 🔥 Très sécurisé : seuls clients connus peuvent se connecter

---

## 🚷 c) Bloquer une IP spécifique

```
iptables -A INPUT -s 1.2.3.4 -j DROP
```

---

# 🧠 8. Bonnes pratiques

### ✅ Toujours :

- Utiliser des mots de passe forts dans Asterisk
- Changer port SIP (optionnel)
- Désactiver les comptes inutilisés

### 🔐 Coupler avec :

- **Fail2ban** (très recommandé)
- Logs Asterisk (`/var/log/asterisk/messages`)

---

# 🧪 9. Exemple complet (configuration type)

```
iptables -F  
  
iptables -P INPUT DROP  
iptables -P OUTPUT ACCEPT  
iptables -P FORWARD DROP  
  
```
# Loopback  
```
iptables -A INPUT -i lo -j ACCEPT  
```
  
# Connexions établies  
```
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
```
  
# SSH (important)  
```
iptables -A INPUT -p tcp --dport 22 -j ACCEPT  
```
  
# SIP  
```
iptables -A INPUT -p udp --dport 5060 -j ACCEPT  
```
  
# RTP  
```
iptables -A INPUT -p udp --dport 10000:20000 -j ACCEPT  
```
  
# Anti bruteforce SIP  
```
iptables -A INPUT -p udp --dport 5060 -m recent --name SIP --set  
iptables -A INPUT -p udp --dport 5060 -m recent --name SIP --update --seconds 60 --hitcount 10 -j DROP
```

---

# 🚀 10. Résumé simple

- Asterisk = très exposé → doit être protégé
- iptables = filtre réseau essentiel
- Principe clé :  
    👉 **"Tout bloquer sauf le nécessaire"**

---