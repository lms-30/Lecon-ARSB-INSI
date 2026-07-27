- **Garantir la disponibilité** des données en cas de perte, corruption, attaque
- **Préserver l’intégrité et la confidentialité** des sauvegardes
- **Minimiser les temps d’indisponibilité** et les pertes de données

## Règles 3-2-1-1-0

1. Conserver au moins trois copies de nos données (une sauvegarde de production, une sauvegarde locale et une sauvegarde distante)
2. Stockez vos copies sur **deux types de supports distincts** (disque dur, serveur de stockage, NAS, cloud)
3. Conservez une copie de vos données dans un emplacement physique différent de votre site principal
4. il faut stocke une copie de données sur un support non connecté à Internet.
5. Avant de faire une sauvegarde, il faut assurer que les données sauvegardées sont sans erreur (0 erreur)
6. Il faut que les logs du backup doivent envoyé en SIEM pour assurer la surveillance continue
7. il faut faire une sauvegarde régulièrement ou périodiquement (par jour (données critiques), par 3 jours ou par semaine pour le données normal)
8. Gestion de droit d'accès aux serveurs backup
9. Il faut toujours chiffrer les données
