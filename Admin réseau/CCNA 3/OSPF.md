**Backbone area**(area 0) est un aire que les autres airs devraient connectées.


**Un aire (area)** : est une ensembe de routeurs et de liaisons, partages le même LSDB.

**Internal routers**(routeurs interne) : un routeur avec des interfaces dans le même area.

**Area Border Routers**(ABRs) : ce sont des routeurs avec des interfaces dans airs multiples.
	Il gèrent les LSDB separées dans chaque air ou ils sont connectées
	
	Bonnes Pratiques :
		Un ABR maximum 2 airs (area) sinon plantage de routeur

**Un intra-area Route** : un route vers une destination interieure de la même air OSPF.

**Un Inter-area Route** : est un route vers une destination au différentes air OSPF.


> [!NOTE] NB
> Air OSPF devrait contique (tsy maintsy mahazo miza le air)

Tous les airs OSPF devrons avoir au moins un routeur ABR connecté au Backbone area.

**ASBR** : est un routeur qui sortir vers l'internet.

