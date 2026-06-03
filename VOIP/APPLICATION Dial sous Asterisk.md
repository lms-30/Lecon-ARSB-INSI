
## Syntaxe complète de l'application Dial

```
exten => NUMERO_APPELE, PRIORITE, Dial(TECHNOLOGIE/DESTINATION, DUREE, OPTIONS)
```

| Paramètre     | Description                                                |
| ------------- | ---------------------------------------------------------- |
| `TECHNOLOGIE` | Protocole utilisé : `SIP`,  `PJSIP`, `IAX2`, `DAHDI`...    |
| `DESTINATION` | Numéro ou nom du pair à appeler                            |
| `DUREE`       | Temps maximum de sonnerie (en secondes). Vide = illimité   |
| `OPTIONS`     | Comportement supplémentaire (écoute, enregistrement, etc.) |

## Appel sortant — Exemple avec préfixe

L'utilisateur compose **9** + le numéro → Asterisk retire le **9** et envoie le reste vers le trunk SIP du FAI.

```
exten => _9.,1,Dial(SIP/trunk_fai/${EXTEN:1},60,tT)
```

> `${EXTEN:1}` supprime le premier caractère (le préfixe **9**) avant d'envoyer le numéro.

---

## 🌐 Formats acceptés par le FAI

|Format|Exemple|
|---|---|
|`0XXXXXXXXX`|`0612345678`|
|`+33XXXXXXXXX`|`+33612345678`|
|`0033XXXXXXXXX`|`0033612345678`|

## ✅ Conditions (Pattern Matching) pour chaque format

### Condition : `0XXXXXXXXX`

```
exten => _0XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},60,tT)
```

> `X` = n'importe quel chiffre de **0 à 9**. 10 chiffres au total.

### Condition : `+33XXXXXXXXX`

```
exten => _+33XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},60,tT)
```

### Condition : `0033XXXXXXXXX`

```
exten => _0033XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},60,tT)
```

---

## 🔠 Wildcards (Jokers) utilisés dans les patterns

|Wildcard|Signification|
|---|---|
|`X`|Un chiffre de **0 à 9**|
|`Z`|Un chiffre de **1 à 9**|
|`N`|Un chiffre de **2 à 9**|
|`.`|**N'importe quelle séquence** de caractères (1 ou plusieurs)|
|`!`|**N'importe quelle séquence** (0 ou plusieurs) — correspondance immédiate|
|`[15-7]`|Un chiffre parmi : 1, 5, 6 ou 7|

##  TOUTES LES OPTIONS de l'application Dial

### Options de transfert

|Option|Rôle|
|---|---|
|`t`|L'**appelé** peut transférer l'appel en tapant `#`|
|`T`|L'**appelant** peut transférer l'appel en tapant `#`|
|`k`|L'**appelé** peut mettre en attente (park) en tapant `#`|
|`K`|L'**appelant** peut mettre en attente (park) en tapant `#`|

> 💡 Le transfert renvoie l'appel vers un autre poste ou contexte sans raccrocher.

---

### Options d'écoute et de chuchotement

|Option|Rôle|
|---|---|
|`w`|L'**appelant** peut activer le mode chuchotement via `*1`|
|`W`|L'**appelé** peut activer le mode chuchotement via `*1`|
|`x`|L'**appelant** peut couper le son (mute)|
|`X`|L'**appelé** peut couper le son (mute)|

>  Le chuchotement permet à un superviseur de parler **uniquement à l'agent** sans que le client entende.

---

###  Options de durée et de délai

|Option|Rôle|
|---|---|
|`S(n)`|Raccroche automatiquement après **n secondes** de conversation|
|`sd(n)`|Attend **n secondes** avant de lancer la sonnerie|
|`D(digits)`|Envoie des **chiffres DTMF** dès la réponse (ex: pour naviguer dans un menu automatique)|
|`d`|Autorise l'appelé à répondre en envoyant un DTMF `#`|

> 💡 `S(300)` est utile pour limiter la durée des appels à 5 minutes maximum.

---

### 🔔 Options de sonnerie et de musique

|Option|Rôle|
|---|---|
|`r`|Génère une **tonalité de sonnerie** côté appelant même si l'appelé n'a pas encore décroché|
|`R`|Comme `r` mais seulement si l'appelé est **joignable**|
|`m`|Joue la **musique d'attente** (MOH) au lieu de la sonnerie|
|`m(classe)`|Joue une classe MOH **spécifique** (ex: `m(jazz)`)|
|`M(macro)`|Exécute une **macro** Asterisk au début de la communication|

> 💡 `m` remplace la tonalité par une musique, utile pour les files d'attente ou les entreprises.

---

### 📣 Options de présentation et d'identité (CallerID)

|Option|Rôle|
|---|---|
|`o`|Conserve le **CallerID original** de l'appelant entrant|
|`O`|Présente le CallerID original **en mode operator**|
|`e`|Utilise le CallerID de **l'extension locale**|
|`f(num)`|Force un **CallerID spécifique** pour l'appel sortant|

ini

```ini
; Forcer l'affichage du numéro entreprise 0102030405 sur tous les appels sortants
exten => _0XXXXXXXXX,1,Set(CALLERID(num)=0102030405)
exten => _0XXXXXXXXX,2,Dial(SIP/trunk_fai/${EXTEN},60,tT)
```

---

### 📼 Options d'enregistrement

|Option|Rôle|
|---|---|
|`G(contexte)`|Bascule vers un **autre contexte** après la fin de l'appel|
|`n`|N'interrompt **pas** l'appel si l'appelé n'est pas joignable|

Pour enregistrer un appel, on utilise **`MixMonitor`** avant Dial :

ini

```ini
exten => _0XXXXXXXXX,1,MixMonitor(/var/spool/asterisk/monitor/${UNIQUEID}.wav)
exten => _0XXXXXXXXX,2,Dial(SIP/trunk_fai/${EXTEN},60,tT)
exten => _0XXXXXXXXX,3,StopMixMonitor()
```

> 💡 `MixMonitor` enregistre les **deux côtés** de la conversation dans un seul fichier audio.

---

### 🔀 Options d'appel simultané (Ringall)

Dial permet d'appeler **plusieurs destinations en même temps** — le premier qui décroche prend l'appel.

ini

```ini
; Appeler le poste 101, 102 et 103 simultanément
exten => 100,1,Dial(SIP/101&SIP/102&SIP/103,30,tT)
```

> 💡 On sépare les destinations avec `&`. Utile pour une équipe de support.

---

### ⛓️ Options de file d'attente et de redirection

|Option|Rôle|
|---|---|
|`h`|Exécute un **contexte de raccrochage** côté appelé|
|`H`|Exécute un **contexte de raccrochage** côté appelant|
|`i`|Ignore les erreurs sur les canaux qui échouent (si multi-destinations)|
|`j`|Continue à la priorité **n+101** si tous les canaux sont occupés|
|`L(x:y:z)`|**Limite la durée** : x = durée max (ms), y = avertissement avant fin, z = fréquence rappel|

ini

```ini
; Limiter l'appel à 5 min, avertir à 1 min de la fin, rappel toutes les 30s
exten => _0XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},60,L(300000:60000:30000))
```

---

### 🧪 Variables automatiques après Dial

Après l'exécution de Dial, Asterisk remplit automatiquement des variables utiles :

|Variable|Valeur possible|Signification|
|---|---|---|
|`${DIALSTATUS}`|`ANSWER`|L'appel a été **décroché**|
|`${DIALSTATUS}`|`BUSY`|La ligne est **occupée**|
|`${DIALSTATUS}`|`NOANSWER`|**Pas de réponse** (timeout)|
|`${DIALSTATUS}`|`CANCEL`|L'**appelant a raccroché** avant réponse|
|`${DIALSTATUS}`|`CONGESTION`|**Réseau saturé** ou numéro invalide|
|`${DIALSTATUS}`|`CHANUNAVAIL`|Canal **indisponible** (trunk hors ligne)|
|`${DIALEDTIME}`|durée en secondes|Durée totale de **sonnerie + conversation**|
|`${ANSWEREDTIME}`|durée en secondes|Durée de la **conversation uniquement**|

ini

````ini
; Rediriger vers messagerie si pas de réponse
exten => _0XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},30,tT)
exten => _0XXXXXXXXX,2,GotoIf($["${DIALSTATUS}" = "NOANSWER"]?messagerie,s,1)
exten => _0XXXXXXXXX,3,GotoIf($["${DIALSTATUS}" = "BUSY"]?occupe,s,1)
```

---

## 🎧 ChanSpy — Écoute discrète
```
exten => 999,1,ChanSpy(SIP/,q)
````

|Option `ChanSpy`|Description|
|---|---|
|`q`|Mode **silencieux** — écoute sans être détecté|
|`w`|Mode **chuchotement** — parle uniquement à l'agent|
|`b`|Écoute les **deux côtés** de la conversation|
|`v(n)`|Ajuste le **volume** d'écoute (n de -4 à 4)|

## 🔁 Exemple complet — Dialplan unifié

ini

```ini
[sortant]
; ── Format local 0XXXXXXXXX ──
exten => _0XXXXXXXXX,1,Set(CALLERID(num)=0102030405)
exten => _0XXXXXXXXX,2,MixMonitor(/var/spool/asterisk/monitor/${UNIQUEID}.wav)
exten => _0XXXXXXXXX,3,Dial(SIP/trunk_fai/${EXTEN},60,tTwWL(300000:60000:30000))
exten => _0XXXXXXXXX,4,StopMixMonitor()
exten => _0XXXXXXXXX,5,GotoIf($["${DIALSTATUS}" = "NOANSWER"]?messagerie,s,1)
exten => _0XXXXXXXXX,6,GotoIf($["${DIALSTATUS}" = "BUSY"]?occupe,s,1)
exten => _0XXXXXXXXX,7,Hangup()

; ── Format +33XXXXXXXXX ──
exten => _+33XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},60,tT)

; ── Format 0033XXXXXXXXX ──
exten => _0033XXXXXXXXX,1,Dial(SIP/trunk_fai/${EXTEN},60,tT)

; ── Appel simultané (Ring All) ──
exten => 100,1,Dial(SIP/101&SIP/102&SIP/103,30,tT)

; ── Écoute discrète superviseur ──
exten => 999,1,ChanSpy(SIP/,q)
```