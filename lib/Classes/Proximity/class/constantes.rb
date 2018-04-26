# encoding: UTF-8
class Proximity

  # {Float} La distance normale avant une répétition possible
  DISTANCE_MAX_NORMALE = 1500.0

  # {Float} Quel que soit la longueur du texte, la distance minimale ne doit
  # pas pouvoir être inférieur à celle-là :
  DISTANCE_MIN_POSSIBLE = 100

  # Un mot qu'on trouverait seulement deux fois dans un texte long aurait une
  # valeur de distance min beaucoup trop élevée. On indique que cette distance
  # ne peut pas être supérieure à 10 pages pour les mots de peu d'occurence
  # DISTANCE_MAX_POSSIBLE = 10 * DISTANCE_MAX_NORMALE
  DISTANCE_MAX_POSSIBLE = 2 * DISTANCE_MAX_NORMALE # 2 pages

end #/ Proximity
