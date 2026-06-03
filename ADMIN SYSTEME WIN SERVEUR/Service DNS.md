adresse IP publique : adresse IP d'une machine sur internet
adresse IP privé : adresse Ip d'une machine en Local
Ny routeur dia manana cache DNS

### Définition

Les système de DNS


### Fonctionnement du DNS

il fonction avec une protocole UDP sur le Port 53

**Resolveur** : verifier le nom de domaine dans le serveur racine s'il ne contient pas dans son cache l'adresse IP de nom de domaine démander par l'utilisateur
**Serveur racine** : raha ohatra ka tsy hitan'ny serveur Resolveur ny nom de domaine anakiray dia alefany mankany @ serveur racine

**serveur TLD** : fournit l'address du serveur DNS
**Serveur faisant autorité** : renvoi l'adresse IP du nom de domaine démander au Resolveur DNS
**Reponse au Client** : en fin, le resolveur DNS renvoi l'IP du nom de domaine démander par l'utilisateur au client


### Type de serveurs DNS

Serveurs DNS faisant autorité : contient tous les informations de tous les nom de domaines (A(addresse IP an'le nom de domaine), CNAME, MX (serveur mail ampiasain'ny domaine anakiray), DMARC, SPF, DKIM, TXT, SOA)

Serveur DNS recursifs : Tsy misy enregistrement DNS


### Importance du Serveur DNS

1. simplification de navigation sur l'internet
2. Facilitation de la communication entre les utilisateur et ressources en ligne
3. amélioration de la rapidité d'accès aux sites web 
### Composant principeaux DNS
Serveurs DNS récursifs : 
Serveurs de noms racine :
Serveurs TLD


### Hiérarechie des domaines
**Racine du DNS (Serveur racine)** : au sommet de la hiérarechie se trouve les serveurs racine, qui ne contients DNS spécifiques mais dirigent les requête
Domaines de prémier niveau (TLD)
Domaines de deuxième niveau
Sous-domaines

### Structure d'un nom de domaine
Un nom de domaine complet (FQDN - Full Qualified Domaine Name) est composé de plusieurs parties, séparées par des points, et se lit généralement de droit à gauche.

**TLD** : indique le type ou localisation du domaine
**Domaine de deuxième niveau** : fournit l'identité principale du site
**sous-domaines**: Offrent une organisation supplémentaire et peuvent représenter différentes services ou sections d'un site.

### Type d'enregistrements DNS

#### 1. Enregistrement A (Address) :
Un enregistrement A  associe une a un adreese IPv4

Exemple : www.google.com IN A 192.0.0.2
#### 2. Enregistreme AAA
L'enregistrement AAA Semble au enregistrement A mais de type enregistrement IPv6

Exemple : www.google.com IN AAA fe80::250:56ff:fec0:8
#### 3. Enregistrement CNAME (Canonnical Name)
Un enregistrement CNAME est un alias ou un raccourci qui permet de dire : "Ce nom pointe vers le  même endroit qu'un autre nom"

Exemple : mail.exemple.com IN CNAME www.example.com

#### 4. L'enregistreme MX (Mail Exchange)
spécifie le serveur de messagerie responsable de la livraisons des courielles pour une domaine particulier.

Exemple : exemple.com IN MX 10 mail.example.com

10 = ordre de Priorité
#### 5. Enregistrement NS (Name Server)
designe qui est le serveur du nom de domaine d'un domaine

Déclaration : Sylvain.com IN NS ns1.stephano.com
#### 6. Enregistrement TXT (Text)

Permet d'associer de chaîne arbitraire d'un domaine, utilisé pour divers politiques anti-spam (SPF)
Déclaration : exemple.com N TXT "v=spf1 include:spf.google.com ~all"
#### 7.Enregistrement PTR (Pointer)
ilaina @resaka DNS renversé, mba ahafana mi-verifier hoe io nom de domaine io de mi-correspondre @na Adresse IP anakiray.
#### 8. Enregistrement SOA (Start of Authority)
Enregistrement qui contient informztion du zone DNS

exemle.com IN SOA ns1.exemple.com. admin.exemple.com 
(  ............
   ............
   ............
   ............
)

