# Proximité

C'est un petit programme destiné à repérer les proximités entre les mots dans un texte.

Synopsis :

PRÉAMBULE

Le programme prend le texte et :

* le transforme en minuscules
* supprime toutes les ponctuations (est-ce vraiment nécessaire ?)


* le programme prend la première vraie lettre (à i)
* il la cherche en avant
* s'il ne la trouve pas à moins de 2000 signes, il passe à la suivante
* s'il la trouve à moins de 2000 signes (à j), il poursuit
* il prend la seconde lettre (à i + 1)
* si i + 1 = j + 1, alors il continue
* sinon, il passe à la lettre i = i + 1 et il recommence


# Recherche des proximités

Il existe deux moyens de trouver les proximités :

* en passant en revue chaque mot l'un après l'autre et en regardant dans les mots suivants,
* en utilisant la classe `Occurences` qui rassemble toutes les occurences des mêmes mots (et mot de base).

La seconde méthode, *a priori*, doit être la plus rapide.
