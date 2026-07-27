### Comment fonctionne ACL
Les hôtes de 192.168.1.0/24 peut accèder au réseau 10.0.1.0/24
Les hôtes
ACL 1:
 - Si source IP = 192.168.1.0/24 puis on permis
 - Si source IP = 192.168.2.0/24 puis on refuse
 - Si source IP = n'importe puis on permit

Condition :
Les hôtes de 192.168.1.0/24 peut accéder au réseau 10.0.1.0/24
Les hôtes de 192.168.2.0/24 ne peut pas accéder au réseau 10.0.1.0/24

Un maximum ACL peut appliquer sur une seul interface par direction
		- Inbound (in interface)= maximum un ACL
		- OutBound (exit interfec)= maximum un ACL
Configurer ACL dans le mode de configuration globale (pas encore effectif)
L'ACL devrai appliquer sur une interface
ACL sont appliqués sur inbound ou outbound


Si un paquet ne figure pas dans les entrées ACL, donc il est bloqué

ACL 2:
	Si source IP = 192.168.1.0/24 puis on permis
	Si source IP = 192.168.0.0/16 puis on refuse
	Si source IP = n'import puis on refuse

### Types ACL
1) ACLs Standard : basé seulement sur adresse IP source
	- ACL standard Numéroté

