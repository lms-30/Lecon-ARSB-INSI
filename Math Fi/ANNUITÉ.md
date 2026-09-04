## 1 - Définition

Une **annuité** est une suite de flux monétaires perçus ou réglés à intervalles de temps égaux. 

> *Note : Le terme « annuité » est habituellement réservé à une périodicité annuelle.*

L'étude des annuités consiste à déterminer la **valeur actuelle** ou la **valeur future** (acquise) à une date donnée d'une suite de flux. Elle prend en considération :
* La date du premier flux
* La périodicité des flux
* Le nombre de flux
* Le montant de chaque flux

### Types d'annuités

* **Annuité constante :** Lorsque les annuités sont égales entre elles.
* **Annuité variable :** Si le montant des flux change d'une période à une autre.

---

### Annuité constante

La valeur future ou la valeur actuelle d'une suite d'annuités constantes dépend de la date de versement, c'est-à-dire en **début de période** ou en **fin de période**.

Pour les formules ci-dessous, nous utiliserons les notations suivantes :
* $A$ : Montant de l'annuité constante
* $i$ : Taux d'intérêt par période
* $n$ : Nombre total de versements (flux)

#### 1. Cas des annuités de Fin de Période

On appelle **valeur acquise** ($V_n$) d'une suite d'annuités constantes de *fin de période*, la somme des annuités exprimée immédiatement après le versement de la dernière annuité.

* **Valeur acquise (future) :**
  $$V_n = A \times \frac{(1 + i)^n - 1}{i}$$

* **Valeur actuelle ($V_0$, une période avant le premier versement) :**
  $$V_0 = A \times \frac{1 - (1 + i)^{-n}}{i}$$

#### 2. Cas des annuités de Début de Période

Dans ce cas, les flux sont versés au premier jour de chaque période. Les formules intègrent une période de capitalisation supplémentaire $(1+i)$.

* **Valeur acquise (future, à la fin de la dernière période) :**
  $$V_n = A \times \frac{(1 + i)^n - 1}{i} \times (1 + i)$$

* **Valeur actuelle ($V_0$, au moment du tout premier versement) :**
  
$$V_0 = A \times \frac{1 - (1 + i)^{-n}}{i} \times (1 + i)$$

