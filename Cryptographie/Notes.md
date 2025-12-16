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

