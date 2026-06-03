def chiffrer_utf8(texte, cle):
    # Convertit la chaîne UTF-8 en bytes
    data = texte.encode("utf-8")
    # Chiffre chaque octet (0–255)
    resultat = bytes((b + cle) % 256 for b in data)
    return resultat

def dechiffrer_utf8(data, cle):
    resultat = bytes((b - cle) % 256 for b in data)
    # Décodage UTF-8 sécurisé
    return resultat.decode("utf-8", errors="replace")


texte_original = "Bonjour ! Tous le monde 😀 @lms"
cle = 42

# Chiffrement
chiffre = chiffrer_utf8(texte_original, cle)
print("Texte original :", texte_original)
print("Texte chiffré  :", chiffre)

# Déchiffrement
dechiffre = dechiffrer_utf8(chiffre, cle)
print("Déchiffré      :", dechiffre)
