import string
from collections import Counter

# ---------------------------
# Texte de référence
# ---------------------------
reference_text = "bonjour les amis".lower()

# ---------------------------
# Fréquence des lettres
# ---------------------------
def letter_frequency(text):
    letters = [c for c in text.lower() if c in string.ascii_lowercase]
    total = len(letters)
    count = Counter(letters)
    freq = {c: count[c] / total if total > 0 else 0 for c in string.ascii_lowercase}
    return freq

# ---------------------------
# Déchiffrement César
# ---------------------------
def decrypt_cesar(text, key):
    result = ""
    for char in text:
        if char.isalpha():
            new_char = chr((ord(char) - ord('a') - key) % 26 + ord('a'))
            result += new_char
        else:
            result += char
    return result

# ---------------------------
# Chiffrement César
# ---------------------------
def encrypt_cesar(text, key):
    result = ""
    for char in text:
        if char.isalpha():
            new_char = chr((ord(char) - ord('a') + key) % 26 + ord('a'))
            result += new_char
        else:
            result += char
    return result

# ---------------------------
# Attaque fréquentielle
# ---------------------------
def attack_frequencies(cipher_text):

    # Fréquences lettres référence & chiffré
    ref_freq = letter_frequency(reference_text)
    cipher_freq = letter_frequency(cipher_text)

    # Lettres triées par fréquence
    ref_sorted = sorted(ref_freq.items(), key=lambda x: x[1], reverse=True)
    cipher_sorted = sorted(cipher_freq.items(), key=lambda x: x[1], reverse=True)

    print("\n=== Lettre la plus fréquente (référence) ===")
    print(ref_sorted[0])

    print("\n=== Lettre la plus fréquente (texte chiffré) ===")
    print(cipher_sorted[0])

    # Lettre la plus fréquente du texte chiffré
    cipher_letter = cipher_sorted[0][0]

    # -----------------------------------------------------------
    # Générer toutes les clés possibles selon fréquence française
    # -----------------------------------------------------------
    print("\n=== Clés possibles selon ordre des fréquences ===")
    possible_keys = []

    for ref_letter, _ in ref_sorted:
        key = (ord(cipher_letter) - ord(ref_letter)) % 26
        possible_keys.append(key)
        print(f"ref='{ref_letter}' → clé = {key}")

    print("\nListe des clés possibles :")
    print(possible_keys)

    # -----------------------------------------------------------
    # Brute‑force ordonné (plus probable → moins probable)
    # -----------------------------------------------------------
    print("\n=== BRUTE FORCE AVEC CLÉS POSSIBLES ===")
    for k in possible_keys:
        print(f"\n--- Essai clé {k} ---")
        print(decrypt_cesar(cipher_text, k))

# ---------------------------
# Programme principal
# ---------------------------
if __name__ == "__main__":

    clear_text = input("Entrez un mot clair : ").lower()
    key = int(input("Entrez la clé (0-25) : "))

    # Chiffrer
    cipher_text = encrypt_cesar(clear_text, key)

    print("\n=== TEXTE CHIFFRÉ ===")
    print(cipher_text)

    # Attaque fréquentielle
    attack_frequencies(cipher_text)
