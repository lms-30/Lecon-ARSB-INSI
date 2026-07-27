### Configuration du serveur DHCP et le sous réseau
1) Attribuer les adresses IP aux interfaces
![[Pasted image 20260609192349.png]]
2) Choix de l'interface réseau
![[Pasted image 20260609152417.png]]

3) Définition de plage d'adresse de chaque sous réseau
![[Pasted image 20260609153325.png]]

4) Configurer les IP statiques
![[Pasted image 20260609193317.png]]

5) Affecter manuellement à la machine Windows une adresse IP appartenant à la seconde plage
![[Pasted image 20260609202539.png]]

6) Activer le routage IP sur Debian et configurer les règles nécessaires pour que les trois
machines (Debian, Parrot, Windows) puissent communiquer entre elles, malgré l’appartenance
à des sous-réseaux distincts.
![[Pasted image 20260614103105.png]]
![[Pasted image 20260614103235.png]]
![[Pasted image 20260614105316.png]]

**teste connectivité depuis le machine de l'attaquant**
![[Pasted image 20260614110301.png]]

### Partie 2 – Phase d’attaque
1) Démarre la console Metasploit :

```
sudo msfconsole
```

![[Pasted image 20260614111307.png]]

![[Pasted image 20260614111714.png]]
![[Pasted image 20260614111804.png]]
![[Pasted image 20260614112116.png]]

Extraction et Cracking des Mots de Passe
![[Pasted image 20260614113735.png]]
![[Pasted image 20260614114227.png]]
![[Pasted image 20260614114904.png]]
![[Pasted image 20260614115849.png]]

### Mise en place d’une protection avec iptables

Voici les script shell:
![[Pasted image 20260616082447.png]]
![[Pasted image 20260616082600.png]]
![[Pasted image 20260616082629.png]]
![[Pasted image 20260616083047.png]]

### Teste de script :

Lancer le script Sur la Debian:
![[Pasted image 20260616084624.png]]
**Option 1:**
Sur debian on choisi l'option 1 :
![[Pasted image 20260616085934.png]]
Sur Parrot OS : essaie d'accèder par ssh
avant :
![[Pasted image 20260616085815.png]]
après :
![[Pasted image 20260616090446.png]]

**Option 7:**
Sur debian on choisi l'option 7 :
![[Pasted image 20260616090714.png]]

Sur la machine **Windows XP**, lance un ping vers la Debian
![[Pasted image 20260616090922.png]]

Depuis **Parrot OS**
pinguer la Debian et Windows XP
![[Pasted image 20260616091257.png]]