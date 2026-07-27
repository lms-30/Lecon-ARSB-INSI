192.168.255.0/24 en 5 sous réseau

11000000.10101000.11111111.00000000
+
11111111.11111111.11111111.00000000


2^{32-24} = 2^{8} = 256

pour saoir le masque du sous-réseau, on ajoute 3 bits de du masque réseau principale parce que lorsqu'on ajoute une 1 bit sur le masque, 

alors : 11111111.11111111.11111111.11100000 donc le masque est /27

11000000.10101000.00000101.00111001
+
11111111.11111111.11111111.11100000

11000000.10101000.00000101.00100000

Addresse Réseau :192.168.5.32/27



Nombre d’hôte dans LAN A: 110

2^7 - 2 = 126

192.168.1.0/25

11111111.11111111.11111111.11000000

### Exercice
192.168.10.0/26

4 departement :

| 2⁷  | 2⁶  | 2⁵  | 2⁴  | 2³  | 2²  | 2¹  | 2⁰  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 128 | 64  | 32  | 16  | 8   | 4   | 2   | 1   |
| 0   | 0   | 0   | 0   | 1   | 0   | 1   | 0   |
| 1   | 1   | 0   | 1   | 1   | 0   | 0   | 1   |
| 1   | 0   | 1   | 1   | 0   | 1   | 1   | 0   |
| 1   | 1   | 0   | 1   | 1   | 1   | 1   | 1   |
| 1   | 0   | 1   | 0   | 1   | 0   | 0   | 0   |
| 0   | 0   | 0   | 1   | 1   | 1   | 1   | 1   |

1. Commercial 50
adresse réseau : 192.168.1.0/26
adresse broadcast : 

2. Informatique 25

3. Comptabilité 10

4. Direction 5


Exo 1:

PC1 a une adresse IP 10.217.182.223/11
Trouver:
1. Addresse réseau
10.217.182.223 
00001010.11011001.10110110.11011111
+
11111111.11100000.00000000.00000000

=00001010.11000000.00000000.00000000

adresse réseau : 10.192.0.0/11
adresse de diffusion : 2^21
11111111.11000000.00000000.00000000
00001010.11101111.11111111.11111111

= 10.223.255.255

#### **Exo2**
110 hosts
/25
11000000.10101000.00000001.00000000
+
11111111.11111111.11111111.10000000

= 11000000.10101000.00000001.00000000

adresse réseau : 192.168.1.0/25
adresses de diffusion : 2^7
11000000.10101000.00000001.01111111

192.168.1.127/24

Première adresse utilisable: 192.168.1.1/24
Dernière adresse utilisable: 192.168.1.126/24
Nombre adresse de hôtes utilisables: 2^6 - 2 = 128 - 2 = 126

#### Exo3

192.168.1.0/24

45 hosts
/26
adresse réseau : 192.168.1.128/26
adresses de diffusion :192.168.1.191/24
Première adresse utilisable: 192.168.1.129/26
Dernière adresse utilisable: 192.168.1.190/26
Nombre adresse de hôtes utilisables: 2^6 - 2 = 64 - 2 = 62

#### Exo4
192.168.1.0/24

29 hosts
/27
adresse réseau : 192.168.1.192/27
adresses de diffusion : 192.168.1./24
Première adresse utilisable: 192.168.1.193/26
Dernière adresse utilisable: 192.168.1.222/26
Nombre adresse de hôtes utilisables: 2^5 - 2 = 32 - 2 = 30

#### Exo5
