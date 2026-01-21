
ZTNA vs VPN : https://www.fortinet.com/fr/resources/cyberglossary/ztna-vs-vpn
			https://www.42gears.com/solutions/capabilities/zero-trust-network-access/
Choix de pare-feu open source : https://geekflare.com/fr/best-open-source-firewall/
Outil d'authentification : https://jumpcloud.com/fr/blog/radius-pros-cons



## ✅ Objectif

Tu veux que :

- Lorsqu’un utilisateur s’authentifie via **le portail captif de pfSense**
    
- L’attribut **`Filter-Id`** (défini dans FreeRADIUS) détermine **quel type de filtrage** (accès autorisé ou interdit) s'applique
    

---

## 📦 Prérequis

1. ✅ **FreeRADIUS est configuré avec des utilisateurs contenant `Filter-Id`**
    
2. ✅ pfSense utilise ce serveur RADIUS pour **le portail captif**
    
3. ✅ Tu actives l'option dans pfSense pour **prendre en compte `Filter-Id`**
    
4. ✅ Tu crées les **ACLs correspondantes dans pfSense**
    

---

## 🔧 Étape 1 : Ajouter l’attribut `Filter-Id` dans FreeRADIUS

Exemple `/etc/freeradius/3.0/users` ou via base MySQL/daloRADIUS :

text

CopierModifier

`admin1 Cleartext-Password := "admin123"     Filter-Id := "ALLOW_DB"  webuser1 Cleartext-Password := "web123"     Filter-Id := "ALLOW_WEB"  invité Cleartext-Password := "guest123"     Filter-Id := "INTERNET_ONLY"`

---

## ⚙️ Étape 2 : Activer l’option dans pfSense pour interpréter `Filter-Id`

1. Va dans **Services > Captive Portal**
    
2. Clique sur **l'interface LAN/VPN** concernée
    
3. Va dans l’onglet **"Authentication"**
    
4. Active **"Use RADIUS MAC authentication"** si nécessaire
    
5. Très important : active l’option **"RADIUS Attributes"** :
    
    - ✅ `Per-user bandwidth restriction`
        
    - ✅ **`RADIUS Filter-ID`**
        
    
    ✅ Cela permet à pfSense **de lire l’attribut `Filter-Id`** et d'appliquer une **policy d'accès prédéfinie**
    

---

## 🎯 Étape 3 : Créer les règles d’ACL dans pfSense

Tu dois maintenant créer **des règles d'accès nommées** dans pfSense correspondant aux valeurs `Filter-Id`.

---

### 📍 Exemple concret :

#### 🔸 1. Aller dans :

**Services > Captive Portal > ACLs** (ou `Firewall > Aliases` si VLAN/Firewall direct)

#### 🔸 2. Créer une règle ACL nommée `ALLOW_WEB`

- **Name** : `ALLOW_WEB`
    
- **Action** : Pass
    
- **Destination IP** : IP de ton serveur Web (ex : `192.168.2.50`)
    
- **Port** : `80`
    
- **Description** : `Autorise accès au serveur web`
    

#### 🔸 3. Créer une règle `ALLOW_DB` :

- **Name** : `ALLOW_DB`
    
- **Action** : Pass
    
- **Destination IP** : IP du serveur BDD (ex : `192.168.2.100`)
    
- **Port** : `3306`
    

#### 🔸 4. Créer une règle `INTERNET_ONLY` :

- **Name** : `INTERNET_ONLY`
    
- **Action** : Pass
    
- **Destination** : any
    
- **Port** : `443` (HTTPS uniquement)
    

Et ajouter une règle de blocage par défaut en dessous si besoin.

---

## 🔁 Étape 4 : Test

1. Connecte-toi via le portail captif avec l’utilisateur `admin1`
    
2. pfSense recevra le `Filter-Id := ALLOW_DB`
    
3. Il appliquera uniquement la règle d’accès définie dans **Captive Portal > ACLs**
    
4. Essaye de faire une requête vers un autre port (ex : 80), ça doit échouer
    

---

## 🧠 Résumé du fonctionnement

|Élément|Fonction|
|---|---|
|`Filter-Id` dans RADIUS|Attribut qui indique à pfSense quelle ACL appliquer|
|pfSense (portail captif)|Récupère le Filter-Id et applique une **ACL du même nom**|
|Règle d’ACL dans pfSense|Doit avoir exactement le **même nom que le Filter-Id**|

---

## 🚀 Option bonus : filtrage par groupe RADIUS (Filter-Id dynamique)

Si tu utilises **MySQL + daloRADIUS**, tu peux associer un **groupe à plusieurs utilisateurs**, chacun avec un `Filter-Id`, ce qui permet :

- `group_web` → `Filter-Id = ALLOW_WEB`
    
- `group_db` → `Filter-Id = ALLOW_DB`