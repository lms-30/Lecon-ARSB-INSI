### Exercice 1
1. **Configuration initiale du serveur**
• Attribuez à la machine l’adresse IP suivante : 192.168.50.5
![[Pasted image 20260713073437.png]]

• Installez le serveur web Apache2
![[Pasted image 20260713073606.png]]
• Vérifiez le bon fonctionnement du serveur en accédant à la page de test par défaut
![[Pasted image 20260713073809.png]]
2. **Installation et configuration de Squid**
• Installez le proxy Squid
![[Pasted image 20260713073924.png]]
• Configurez Squid de manière à bloquer toutes les adresses IP du réseau
192.168.50.0/24
![[Pasted image 20260713074210.png]]
![[Pasted image 20260713074410.png]]

3. **Mise en place d’une restriction temporelle**
• Modifiez la configuration de Squid pour que le blocage soit actif uniquement les
dimanches entre 08h00 et 12h00
![[Pasted image 20260713074550.png]]
![[Pasted image 20260713074640.png]]

4. **Blocage d’un site spécifique**
• Configurez Squid pour interdire l’accès à une URL précise (au choix ou imposée par
l’enseignant)
![[Pasted image 20260713075158.png]]
![[Pasted image 20260713074827.png]]
5. **Modification du port de Squid**
• Changez le port d’écoute par défaut de Squid
![[Pasted image 20260713075253.png]]
• Adaptez l’ensemble de la configuration afin d’assurer le bon fonctionnement du proxy
après ce changement
