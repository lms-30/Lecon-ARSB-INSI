**Cryptosystème** : (Notion : algorithme de chiffrement et déchiffrement, notion de clé,message chiffré, message claire)


**Loi de Kerchoff** : 
- Pour avoir une chiffrement parfait (ou sécurisé), 
- La sécurité résident dans la clé
- Donc la clé doit être caché

**Chiffrement symétrique** : c'est une chiffrement qui utilise le même clé pour ouvrir/fermer une message.
1. Boite en S(Substitution) : il assure la confusion (la difficulté d'avoir le message chiffré à partir de la clé)
2. Boite en P(Permutation ou Transposition) : il assure la diffusion ( la difficulté d'avoir le message chiffré à partir d'un message clair)

**La sécurité d'un chiffrement symétrique** ça vient du partage de clé

Pour avoir une diffusion : On utilisa Pbox

**Quel est la relation entre la sécurité et moi ?** : c'est le secret et la confiance (cas pratique peut être 50 % émetteur et 50 % récepteur)

**Pourquoi on utilise de chiffrement symétrique ?**
- Le secret et la confiance
- Le temps de chiffrement


# Base 64

Pading : fenoina le données rahaohatra ka ts 




AES :  Advanced Encryption Standart

Condition : communication



# Chiffrement Asymatrique

### 1. Concept 

Condition : communication

Clé privé :
Clé publique : 

Exemple : Bob et Alice
Bob veux envoyer une message à Alice 

Alors Bob demande la clé publique à Alice pour mettre une message 
Bob peut chiffrer le message à partir du clé publique d'Alice mais seul Alice peut déchiffrer le message à partir d'une clé privé d'Alice

**Sécurité :** Problème à sens unique par rapport clé

##### Principe du chiffrement Asymétrique
- Tout le monde peut chiffrer à partir de la clé publique
- Seul le destinataire peut déchiffrer à partir de sa clé privé

### RSA : Rivest Shamir Adleman

            clé publique (d, n)
Bob ----------------------------------------------- Alice(va faire keygen(générateur de la paire de clé (clé publique et clé privé )))

Keygen va généré 
- d'abord deux nombres p et q
- faire la multiplication : n = p x q
- phi(n) = (p-1)(q-1)
- e aléatoire : (e,n) clé privé
- d = e(−1) mod(phi(n))

**vérification** :  si PGCD(e,phi(n)) = 1, donc le chiffrement est bonne

<<<<<<< HEAD

## Résumé :

### Chifrement a clé privé :
Securité: partage de clé

Secret: 50% - 50%

Tout le monde peut chiffrer le message a partir de clé

Le destinateur peut dechiffrer le message a partir de clé

**Comment créer un chiffrement symetrique?**
- P-box(boite de permutation)
- S-box(boite de substitution)
- Plusieurs iteration

Mode block cipher



**Chiffrement a cle public:**

communication clé
Securité: prob sens unique
Tout le monde peut chiffre

**Fonction de hachage**
{0,1}* :   0 et 1 repeter plusieur fois
Apina izay tsy ampy: **padding(bourage)**

=======
>>>>>>> b43adc8c77255ca319db4aa9eada86a8158b98ac


## Type d'authentification

- something you now : authentification par mot de passe
- something  you have : authentification par certificat
- something you are :authentification par empreinte

**2FA:** double authetification (il utilise les 2 de ces trois types)
MFA : authentification multiple

près-image de première ordre : on vous une mot de mot de passe, chercher le résumé de cette mot de passe
près-image de séconde ordre : on vous une  qui on le même résumé




HMAC : HMAC signifie « ==Hash-based Message Authentication Code== » (Code d'authentification de message basé sur le hachage). C'est un mécanisme de sécurité cryptographique qui utilise une fonction de hachage (comme SHA-256) et une clé secrète partagée pour garantir à la fois l'**intégrité** et l'**authenticité** d'un message, prouvant qu'il n'a pas été altéré.


SHA3-256 : mampiase ana structure en éponges
SHA256 : miampiasa ana structure



## Chiffrement

**Qui peut chiffrer ? A partir de quelle clé ?**

Tout le mode peut faire un chiffrement à partir de la clé publique du destinateur.

**Qui peut déchiffrer ? à partir de quelle clé ?**
Seul le destinataire peut déchiffrer à partir de sa clé privé

**Q'est qui **



**Comment on fait de la signature ?**
on peut faire la signature à partir de de l'information haché 

**Qui peut signer ?**
seul le l'autorité de certificat peut signer à partir de son clé privé de hash de l'information de la destinateur

**Qui peut vérifier la signature ?**
Tout le monde peut vérifier la signature à partir de clé publique de la destination

**Comment être sûr que la clé publique appartient bien au destinataire et pas à un attaquant ?**
En **authentification par certificat**, la **méthode de challenge** (ou _challenge–response_) est un **mécanisme de vérification** qui permet de prouver que le client **possède réellement la clé privée** associée à son certificat — **sans jamais l’envoyer**.

Fonctionnement :
- Le destinataire possède une **clé publique** et une **clé privée**.
- Sa **clé publique est placée dans un certificat numérique**.
- Une **autorité de certification (CA)** vérifie l’identité du destinataire.
- La CA **signe le certificat**, ce qui prouve que la clé publique est fiable.
- Le destinataire envoie son **certificat** au client.
- Le client **vérifie la signature de la CA**.
- Si la CA est de confiance, le client **fait confiance à la clé publique**.
- Le client sait alors que **la clé publique appartient bien au destinataire**.