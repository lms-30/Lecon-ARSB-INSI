POwershell est framework de gestion et d'automatisation des taches développé par Microsoft.

Il est constriut sur .NET


#### Fonctionnement

Powershell fonctionne selon une approche orienté objet et utilise un pipeline pour traité les données.


Les principaux de bases de fonctionnemnt :

- **cmdlets** : les comdlets sont des commandes spécifiques dans powershell. il suivre le standard **verbe-nom**
- **pipeline** : Le pipeline utilise un pipeline, ce qui permet de passer la sortie d'une commande entrée  à une autre commande.
- **Objets** : Contrairement aux autres shell qui renvoie du texte brute, powershell renvoie des objet.
- **Modules**: les modules sont collection de cmdlets, des fonctions et de scripts PowerShell regroupés pour une tâche spécifique.
- Scripts : PowerShell permet d'écrire des script (.ps1) pour automatiser des tâches complexes


> [!NOTE] Automatisation des tâches
> PowerSell permet d'automatiser la gestion de nombreux apects d'un sytème, y compris la gestion des utilisateurs, des processus, des fichiers et de configurations réseau.
> 


> [!NOTE] Gestion des objets Système
> PowerShell peut gérer presque tous les aspects d'un système d'exploitation va des cmdlets, comme les services, les processus, les événements, les registres, et même les configuration réseau.


> [!NOTE] Gestion à distance
> Grâce à PowerShell Remoting, il est possible de gérer des machines à distance, ce qui permet de centraliser la gestion des serveurs et des postes de travail.


> [!NOTE] Intéroperabilité avec des autres applications
> PowerShell peut interagir avec des autres appliactions Windows comme SQL Server


#### Notion à Savoir

> [!NOTE] LES Commandes (Cmdlets)
> 
> une abrievation de command-lety, une commande spécifique de PowerShell
> 
> Pour trouver une cmdlet, untile Get-Command 



Variables et Types de données


le variable sont crée avec $



Pipelines




Les Structures de contrôle

Boucle : foreach, for, while, et do.....while
Condition : if , elsif, et else pour gérer l'instruction


Les Fonctions 
Créer des fonctions personnalisées avec 'Function' pour réutiliser du code. Par exemple :

```
Function Bonjour {
	param($nom)
	Write-Output "Bonjour, $nom"
}
```



> [!NOTE] Objets et Propriétés
> - PowerShell est orienté objet, chaque élément manipulé eest un objet avec des propriétés et des méthodes.
>  - Utilisez Get-Member pour explorer les propriétés et méthodes d'un objet: Get-Process | Get-Member

Gestion des Fichiers et Dossiers


Les modules et Importation
PowerShell utilise des modules pour étendre



Scripts et Exécution
Un script

Gestion de l'aide et Documentation


> [!NOTE] Déclaration d'un variable
> En powershell, vous pouveez 
> $mavariable="Bonjour powershell"


> [!NOTE] Type de Varaible
> [int]$nombre = 42
> 
> [string]$text = "Hello"


> [!NOTE] Déclaration de tableau
> Pour déclarer un tableau, on utilise '@()' pour initaliser plusieurs valeurs dans la même variable
> $monTableau = @("un","deux","trois")
> 
> Vous pouvez également déclarer un tableau de type spécifique
> [int[]]$nombres = @(1,2,3,4)


### Les Hashtables

> [!NOTE] Déclaration des hashtables
> 

#### Différence entre Wriet-Host et Write-Output en PowerShell
Affichage simple
```
Write-Host "Hello, world!"
```

**Utilisation avec une direction**


**Traitement dans une variable**
- Write-Host
```
$a = Write-Host "Bonjour avec Write-Host"
Write-Host "Contenu de la variable a : $a"
```
- Write-Output
```
$b = Write-Output "Bonjour avec Write-Output"  
Write-Output "Contenu de la variable b : $b"
```

**Utilisation dans un pipeline**
- Write-Host
```
Write-Host "pipeline avec Write-Host" | ForEach-Object{"Traitement: $_"}
```
- Write-Output
```
Write-Output "pipeline avec Write-Output" | ForEach-Object{"Traitement: $_"}
```

### Mesure Object

Exporter le service dans une fichier
```
Get-Service | out-file servs.txt
ou
Get-Service > servs.txt
```
Voir le contenue de l'out-file sur powershell
```
Get-Content servs.txt
```


