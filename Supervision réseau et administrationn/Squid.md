En `iptables`, **PREROUTING** et **POSTROUTING** sont deux chaînes (étapes de traitement) de la table `nat` qui permettent de modifier les paquets réseau à leur arrivée ou à leur départ pour configurer un comme 

1. PREROUTING (Avant le routage)

- **Définition :** Cette opération intercepte les paquets dès qu'ils arrivent sur la carte réseau du serveur, **avant** que le noyau Linux ne décide où les envoyer. 
- **Rôle pour Squid :** Elle sert à réaliser une redirection (appelée DNAT ou REDIRECT). Lorsqu'un utilisateur du réseau demande une page web (port 80) sur Internet, l'opération PREROUTING intercepte la requête et la redirige en douce vers le port local (ex: 3128) où Squid écoute, créant ainsi un "proxy transparent".
- **Exemple de commande :**  
    `iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 3128`

2. POSTROUTING (Après le routage)

- **Définition :** Cette opération traite les paquets **juste avant qu'ils ne quittent** le pare-feu ou le routeur pour aller vers leur destination finale.
- **Rôle pour Squid :** Elle sert principalement au masquage d'adresse (SNAT ou MASQUERADE). Quand Squid traite une requête et va chercher le site web sur Internet, le paquet doit porter l'adresse IP publique ou externe du routeur. Postrouting se charge de modifier l'adresse source pour que la réponse revienne bien au pare-feu


#### Proxy transparent
Dans le contexte du logiciel informatique **Squid**, un **proxy transparent** est ==une configuration où le trafic réseau des utilisateurs est redirigé automatiquement vers le serveur proxy sans nécessiter la moindre configuration manuelle dans les navigateurs ou applications clients==


