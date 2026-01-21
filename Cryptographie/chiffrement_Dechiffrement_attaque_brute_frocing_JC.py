def chiffrer_cesar(texte, cle=3):
    texte_chiffre = ""
    for caractere in texte:
        if 'a' <= caractere <= 'z':
            nouvel_indice = (ord(caractere) - ord('a') + cle) % 26
            texte_chiffre += chr(ord('a') + nouvel_indice)
        elif 'A' <= caractere <= 'Z':
            nouvel_indice = (ord(caractere) - ord('A') + cle) % 26
            texte_chiffre += chr(ord('A') + nouvel_indice)
        else:
            texte_chiffre += caractere
    return texte_chiffre

def dechiffrer_cesar(texte_chiffre, cle=3):
    return chiffrer_cesar(texte_chiffre, -cle)

def brute_force_cesar(texte):
    for cle in range(26):
        dechiffre = chiffrer_cesar(texte, -cle)
        print(f"Clé = {cle} → {dechiffre}")

message_original = "Bonjour, le monde secret de Cesar !"
cle_personnalisee = 5 # On peut changer cette clé (par defaut elle est 3)

# 1. Chiffrement avec la clé par défaut (K=3)
chiffre_defaut = chiffrer_cesar(message_original)
print(f"Message original: {message_original}")
print(f"Chiffré (K=3):     {chiffre_defaut}")

# 2. Déchiffrement avec la clé par défaut
dechiffre_defaut = dechiffrer_cesar(chiffre_defaut)
print(f"Déchiffré (K=3):   {dechiffre_defaut}\n")

# 3. Attaque frequence

Attaque = brute_force_cesar(chiffre_defaut)
print(Attaque)

