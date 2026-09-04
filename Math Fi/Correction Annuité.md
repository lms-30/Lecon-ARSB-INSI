## 📝 Résolution des Exercices d'Annuités

### 📊 Exercice 1 : Calcul d'un placement mensuel futur

> [!info] **Énoncé**
> Vous voulez disposer d'une somme de 25 000 € dans 5 ans. La banque vous propose des placements mensuels au taux nominal annuel de 6 %. Combien faut-il placer mensuellement ?

#### 🔎 Analyse des données
* **Objectif (Valeur acquise) ($V_n$) :** 25 000 €
* **Durée ($n$) :** $5\ \text{ans} \times 12\ \text{mois} = 60\ \text{mois}$
* **Taux d'intérêt mensuel ($i$) :** $\frac{6\%}{12} = 0,5\% = 0,005$

#### 📐 Formule appliquée (Fin de période)
$$V_n = a \times \frac{(1 + i)^n - 1}{i}$$

En inversant la formule pour trouver la mensualité $a$ :
$$a = \frac{V_n}{\frac{(1 + i)^n - 1}{i}}$$

#### 🧮 Calculs
$$25\ 000 = a \times \frac{(1 + 0,005)^{60} - 1}{0,005}$$
$$25\ 000 = a \times \frac{1,34885 - 1}{0,005}$$
$$25\ 000 = a \times 69,77003$$
$$a = \frac{25\ 000}{69,77003} \approx 358,32\ €$$

>[!success] **Résultat Exercice 1**
> Il faut placer **358,32 €** chaque mois pendant 5 ans pour obtenir 25 000 €.

---

### 📊 Exercice 2 : Valeur actuelle de flux annuels

> [!info] **Énoncé**
> Soit un placement au taux de 3 %, qui consiste à verser chaque année 5 000 € pendant 4 ans. Calculer la valeur actuelle selon le moment du versement.

#### 🔎 Analyse des données
* **Annuité ($a$) :** $5\ 000\ €$
* **Nombre de versements ($n$) :** $4\ \text{ans}$
* **Taux annuel ($i$) :** $3\% = 0,03$

#### 🅰️ Cas a) Le versement commence aujourd'hui (Début de période)

* **Formule :**
$$V_0 = a \times \frac{1 - (1 + i)^{-n}}{i} \times (1 + i)$$

* **Calcul :**
$$V_0 = 5\ 000 \times \frac{1 - (1 + 0,03)^{-4}}{0,03} \times (1 + 0,03)$$
$$V_0 = 5\ 000 \times 3,7171 \times 1,03$$
$$V_0 \approx 19\ 143,05\ €$$

#### 🅱️ Cas b) Le premier versement commence à la fin de chaque année (Fin de période)

* **Formule standard :**
$$V_0 = a \times \frac{1 - (1 + i)^{-n}}{i}$$

* **Calcul :**
$$V_0 = 5\ 000 \times \frac{1 - (1 + 0,03)^{-4}}{0,03}$$
$$V_0 = 5\ 000 \times 3,717098$$
$$V_0 \approx 18\ 585,49\ €$$*
