# Fiche de révision — PowerShell

## 1. Généralités à retenir par cœur

| Point | Réponse type examen |
|---|---|
| Qu'est-ce que PowerShell ? | Framework de gestion et d'automatisation de tâches développé par Microsoft, construit sur .NET |
| Différence avec un shell classique (bash) ? | PowerShell manipule des **objets** (instances .NET) dans le pipeline, pas du texte brut |
| Convention de nommage des cmdlets | **Verbe-Nom** (ex : `Get-Process`, `Set-Item`, `New-Object`) |
| Extension des scripts | `.ps1` |
| Comment trouver une cmdlet ? | `Get-Command` |
| Comment explorer un objet ? | `Get-Member` (propriétés + méthodes) |
| Comment afficher l'aide ? | `Get-Help <cmdlet>` (ajouter `-Full`, `-Examples`, ou `-Online`) |

---

## 2. Les 5 piliers du fonctionnement

1. **Cmdlets** — commandes atomiques Verbe-Nom (`Get-Service`, `Stop-Process`…)
2. **Pipeline (`|`)** — transmet des **objets** (pas du texte) d'une cmdlet à l'autre
3. **Objets** — chaque résultat a des propriétés et des méthodes, héritage direct de .NET
4. **Modules** — regroupements de cmdlets/fonctions/scripts pour un domaine (ex : `ActiveDirectory`, `Az`)
5. **Scripts (.ps1)** — automatisation de tâches complexes, réutilisables

**Piège classique d'examen** : *"Pourquoi le pipeline PowerShell est-il plus puissant que celui de bash ?"*
→ Parce qu'il transmet des objets structurés (avec propriétés typées) et non du texte à re-parser.

---

## 3. Variables et types

```powershell
$maVariable = "Bonjour PowerShell"      # typage implicite
[int]$nombre = 42                       # typage explicite (fortement typé)
[string]$texte = "Hello"
```

- Toute variable commence par `$`
- Le typage est **optionnel** mais recommandé pour la robustesse (`[int]`, `[string]`, `[bool]`, `[datetime]`…)
- Vérifier le type : `$nombre.GetType()`

### Tableaux
```powershell
$monTableau = @("un", "deux", "trois")
[int[]]$nombres = @(1,2,3,4)
$monTableau[0]        # accès par index
$monTableau.Count     # nombre d'éléments
```

### Hashtables (tables associatives clé/valeur)
```powershell
$maHashtable = @{
    Nom    = "Jean"
    Age    = 25
    Ville  = "Antananarivo"
}
$maHashtable["Nom"]          # accès par clé
$maHashtable.Age             # accès par propriété
$maHashtable.Keys            # liste des clés
$maHashtable.Values          # liste des valeurs
```

---

## 4. Structures de contrôle

**Boucles**
```powershell
foreach ($item in $collection) { ... }
for ($i = 0; $i -lt 10; $i++) { ... }
while ($condition) { ... }
do { ... } while ($condition)
```

**Conditions**
```powershell
if ($condition) {
    ...
} elseif ($autreCondition) {
    ...
} else {
    ...
}
```

**Opérateurs de comparaison (piège fréquent : pas de `==` ou `<`)**
| Opérateur | Sens |
|---|---|
| `-eq` | égal |
| `-ne` | différent |
| `-lt` / `-le` | inférieur / inférieur ou égal |
| `-gt` / `-ge` | supérieur / supérieur ou égal |
| `-like` | comparaison avec joker (`*`) |
| `-match` | comparaison avec regex |
| `-and`, `-or`, `-not` | opérateurs logiques |

---

## 5. Fonctions

```powershell
Function Bonjour {
    param($nom)
    Write-Output "Bonjour, $nom"
}
Bonjour -nom "Marie"
```

- Mot-clé `Function`
- Paramètres déclarés avec `param(...)`
- On peut typer les paramètres : `param([string]$nom, [int]$age)`
- On peut rendre un paramètre obligatoire : `param([Parameter(Mandatory=$true)][string]$nom)`

---

## 6. Write-Host vs Write-Output (très classique en examen)

| Critère | `Write-Host` | `Write-Output` |
|---|---|---|
| Destination | Console **uniquement** | Flux de sortie (pipeline) |
| Récupérable dans une variable ? | **Non** (`$a` sera vide/`$null`) | **Oui** |
| Utilisable dans un pipeline ? | **Non** (rien à transmettre) | **Oui**, transmet l'objet à la cmdlet suivante |
| Cas d'usage | Affichage cosmétique pour l'utilisateur | Retourner un résultat exploitable par un script |

```powershell
$a = Write-Host "Test"      # $a est vide
$b = Write-Output "Test"    # $b contient "Test"

Write-Host "x" | ForEach-Object { "Traitement: $_" }    # ne fait rien (pas d'objet transmis)
Write-Output "x" | ForEach-Object { "Traitement: $_" }  # affiche "Traitement: x"
```

**Retenir** : `Write-Output` = pour le pipeline / la logique du script. `Write-Host` = pour l'affichage humain.

---

## 7. Gestion des objets système

```powershell
Get-Process                      # liste des processus
Get-Process | Get-Member         # propriétés/méthodes de l'objet process
Get-Service                      # liste des services
Stop-Service -Name "Spooler"
Get-EventLog -LogName System     # journaux d'événements
Get-ItemProperty HKLM:\...       # lecture du registre
Get-NetIPAddress                 # config réseau
```

---

## 8. Fichiers, export et redirection

```powershell
Get-Service | Out-File servs.txt      # exporte vers un fichier
Get-Service > servs.txt               # équivalent avec redirection
Get-Content servs.txt                 # lit le contenu du fichier
Get-ChildItem                         # équivalent de "ls" / "dir"
Copy-Item, Move-Item, Remove-Item     # gestion fichiers/dossiers
```

Autres formats d'export utiles à connaître : `Export-Csv`, `ConvertTo-Json`, `Export-Clixml`.

---

## 9. Modules

```powershell
Get-Module -ListAvailable   # modules installés
Import-Module <NomModule>   # charger un module
Install-Module <NomModule>  # installer depuis PowerShell Gallery
```

---

## 10. PowerShell Remoting (gestion à distance)

```powershell
Enable-PSRemoting                          # active le remoting sur la machine
Enter-PSSession -ComputerName Serveur01    # session interactive à distance
Invoke-Command -ComputerName Serveur01 -ScriptBlock { Get-Process }
```
Repose sur **WinRM** (Windows Remote Management). Permet de centraliser la gestion de plusieurs machines.

---

## 11. Questions probables type examen

1. Pourquoi dit-on que PowerShell est orienté objet ? *(chaque sortie de cmdlet est un objet .NET avec propriétés/méthodes, pas du texte)*
2. Quelle est la convention de nommage des cmdlets et pourquoi ? *(Verbe-Nom, pour la cohérence et la découvrabilité)*
3. Quelle cmdlet permet de découvrir les propriétés d'un objet retourné ? *(`Get-Member`)*
4. Différence fondamentale entre le pipeline Unix/bash et celui de PowerShell ? *(texte vs objets structurés)*
5. Expliquer pourquoi `$a = Write-Host "texte"` laisse `$a` vide.
6. Écrire une fonction qui prend un nom en paramètre et affiche un message de bienvenue.
7. Différence entre `Get-Service | Out-File` et `Get-Service > fichier.txt` ? *(résultat identique, syntaxe différente — redirection vs cmdlet)*
8. Citer 3 cmdlets liées à la gestion des processus/services.
9. Comment gérer une machine à distance avec PowerShell ? *(PowerShell Remoting / WinRM, `Invoke-Command`, `Enter-PSSession`)*
10. Quelle est la différence entre un tableau et une hashtable ?

---

## 12. Auto-évaluation rapide

Essaie d'écrire, sans regarder tes notes :
- une fonction avec un paramètre obligatoire typé
- une boucle `foreach` qui filtre les services arrêtés (`Where-Object {$_.Status -eq "Stopped"}`)
- une commande qui exporte les 5 processus consommant le plus de mémoire en CSV

Si tu veux, envoie-moi tes réponses et je les corrige.
