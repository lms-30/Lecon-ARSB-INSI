
## Exercice 1 — Emprunt de 200 000 € à 4,5 % sur 5 ans, annuités constantes

**a) Calcul de l'annuité constante**

$$a = C \times \frac{i}{1-(1+i)^{-n}} = 200,000 \times \frac{0,045}{1-(1,045)^{-5}} \approx 45,557,68 \text{ €}$$

**b) Tableau d'amortissement**

| Période | Capitale début de période | Intérêt 4,5 % | Amortissement | Annuité I+C | Capitale restant dû |
| ------- | ------------------------- | ------------- | ------------- | ----------- | ------------------- |
| 1       | 200 000,00                | 9 000,00      | 36 557,68     | 45 557,68   | 163 442,32          |
| 2       | 163 442,32                | 7 354,90      | 38 202,78     | 45 557,68   | 125 239,54          |
| 3       | 125 239,54                | 5 635,78      | 39 921,90     | 45 557,68   | 85 317,64           |
| 4       | 85 317,64                 | 3 839,29      | 41 718,39     | 45 557,68   | 43 599,25           |
| 5       | 43 599,25                 | 1 961,97      | 43 599,25     | 45 561,22   | 0,00                |

---

## Exercice 2 — Emprunt de 12 000 € à 7 % sur 4 ans

### 1) Remboursement en bloc (in fine)

Seuls les intérêts sont versés chaque période ; le capitale reste dû jusqu'à la fin, où il est remboursé en une seule fois.

| Période | Capitale début de période | Intérêt 7 % | Amortissement | Annuité I+C | Capitale restant dû |
| ------- | ------------------------- | ----------- | ------------- | ----------- | ------------------- |
| 1       | 12 000                    | 840         | 0             | 840         | 12 000              |
| 2       | 12 000                    | 840         | 0             | 840         | 12 000              |
| 3       | 12 000                    | 840         | 0             | 840         | 12 000              |
| 4       | 12 000                    | 840         | 12 000        | 12 840      | 0                   |

### 2) Remboursement par annuités constantes

$$a = 12,000 \times \frac{0,07}{1-(1,07)^{-4}} \approx 3,542,16 \text{ €}$$

| Période | Capitale début de période | Intérêt 7 % | Amortissement | Annuité I+C | Capitale restant dû |
| ------- | ------------------------- | ----------- | ------------- | ----------- | ------------------- |
| 1       | 12 000,00                 | 840,00      | 2 702,16      | 3 542,16    | 9 297,84            |
| 2       | 9 297,84                  | 650,85      | 2 891,31      | 3 542,16    | 6 406,53            |
| 3       | 6 406,53                  | 448,46      | 3 093,70      | 3 542,16    | 3 312,83            |
| 4       | 3 312,83                  | 231,90      | 3 312,83      | 3 544,73    | 0,00                |

### 3) Remboursement par amortissement constant

Amortissement constant = 12 000 / 4 = **3 000 € par période**

|Période|Capitale début de période|Intérêt 7 %|Amortissement|Annuité I+C|Capitale restant dû|
|---|---|---|---|---|---|
|1|12 000|840|3 000|3 840|9 000|
|2|9 000|630|3 000|3 630|6 000|
|3|6 000|420|3 000|3 420|3 000|
|4|3 000|210|3 000|3 210|0|

---

## Exercice 3 — Emprunt de 80 000 € à 7 %, annuités constantes de 9 000 €

On cherche le nombre de périodes $n$ tel que :

$$9,000 = 80,000 \times \frac{0,07}{1-(1,07)^{-n}}$$

$$1-(1,07)^{-n} = \frac{5,600}{9,000} = 0,622222$$

$$(1,07)^{n} = \frac{1}{0,377778} = 2,64706$$

$$n = \frac{\ln(2,64706)}{\ln(1,07)} \approx 14,38 \text{ ans}$$


**Interprétation :** l'emprunteur ne peut pas solder exactement sa dette avec un nombre entier d'annuités de 9 000 €. Dans la pratique on retient **14 annuités pleines de 9 000 €**, suivies d'une **15ᵉ annuité réduite** correspondant au solde restant (capital + intérêt de la dernière période), qui clôture l'emprunt.