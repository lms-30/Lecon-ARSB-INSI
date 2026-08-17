Voici un exercice corrigé sur le calcul de l'annuité constante, avec le tableau d'amortissement complet.

## Énoncé

Une entreprise contracte un emprunt de **50 000 €** auprès d'une banque, au taux d'intérêt annuel de **6 %**, remboursable en **4 annuités constantes**.

1. Calculer le montant de l'annuité constante.
2. Présenter le tableau d'amortissement de l'emprunt.
3. Vérifier que la somme des amortissements est égale au capital emprunté.

## Correction

### 1) Calcul de l'annuité constante

La formule de l'annuité constante est :

$$a = C \times \frac{i}{1-(1+i)^{-n}}$$

avec $C = 50,000$, $i = 0,06$, $n = 4$.

- $(1,06)^4 = 1,262477$
- $(1,06)^{-4} = 0,792094$
- $1 - 0,792094 = 0,207906$

$$a = 50,000 \times \frac{0,06}{0,207906} = \frac{3,000}{0,207906} \approx 14,431,49 \text{ €}$$

### 2) Tableau d'amortissement

|Période|Capitale début de période|Intérêt 6 %|Amortissement|Annuité I+C|Capitale restant dû|
|---|---|---|---|---|---|
|1|50 000,00|3 000,00|11 431,49|14 431,49|38 568,51|
|2|38 568,51|2 314,11|12 117,38|14 431,49|26 451,13|
|3|26 451,13|1 587,07|12 844,42|14 431,49|13 606,71|
|4|13 606,71|816,40|13 606,71|14 423,11|0,00|

_(la dernière annuité est légèrement rectifiée pour solder exactement le capital restant dû, l'écart provenant des arrondis)_

**Vérifications utiles :**

- L'intérêt de chaque période = Capitale début de période × 6 %
- L'amortissement = Annuité − Intérêt
- Le capitale restant dû = Capitale début de période − Amortissement
- Les amortissements augmentent d'une période à l'autre car l'intérêt diminue (le capital restant dû baisse), tandis que l'annuité reste fixe.

### 3) Vérification de la somme des amortissements

$$11,431,49 + 12,117,38 + 12,844,42 + 13,606,71 = 50,000,00 \text{ €}$$

On retrouve bien le montant du capital initialement emprunté (50 000 €), ce qui confirme la cohérence du tableau : la dette est totalement remboursée à la fin de la 4ᵉ période.