# --- Chiffrement César ---
def chiffrement_cesar(texte, cle):
    resultat = ""
    for char in texte:
        if char.isalpha(): 
            base = ord('a') if char.islower() else ord('A')
            nouveau_char = chr((ord(char) - base + cle) % 26 + base)
            resultat += nouveau_char
        else:
            resultat += char
    return resultat


# --- Déchiffrement César ---
def dechiffrement_cesar(texte, cle):
    return chiffrement_cesar(texte, -cle)


# --- Brute-force (test toutes les clés de 0 à 25) ---
def brute_force_cesar(texte):
    print("=== BRUTE FORCE ===")
    for cle in range(26):
        tentative = dechiffrement_cesar(texte, cle)
        print(f"Clé {cle:02} : {tentative}")


# EXEMPLE D’UTILISATION
if __name__ == "__main__":
    texte = "Bonjour tout le monde"
    cle = 5

    # Chiffrement
    chiffre = chiffrement_cesar(texte, cle)
    print("Texte chiffré :", chiffre)

    # Déchiffrement
    dechiffre = dechiffrement_cesar(chiffre, cle)
    print("Texte déchiffré :", dechiffre)

    # Brute force
    brute_force_cesar(chiffre)
