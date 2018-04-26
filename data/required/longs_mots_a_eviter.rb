# encoding: UTF-8
class Texte
class Mot
  LONGS_MOTS_A_EVITER = [
    'avoir', # peut-être mot qui doivent avoir une "densité" faible qd même
    'elle',
    'être',
    'nous',
    'par',
    'pas',
    'son',
    'une',
    'vous'
  ]


  # TODO Je pense que c'est toute l'expression "de MOT en MOT" qu'il faut
  # traiter comme n'étant pas une répétition.
  # TODO Traiter "mètre par mètre", "coudée par coudée", "centimètre par centimètre"
  # TODO Traiter "mot pour mot", "geste pour geste", etc.
  LOCUTIONS_REPETITIVES = {
    'loin'  => ['loin en loin'],
    'moins' => ['moins en moins'],
    'temps' => ['temps en temps'],
    'coute' => ['coute que coute'],
    'encore' => ['encore et encore'] # penser au test des deux mots
  }

  LOCUTIONS_TIRETS = {
    'peut' => ['peut-être']
  }
end# Mot
end# Texte
