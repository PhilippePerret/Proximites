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

  # Mots écartables, c'est-à-dire les mots qui, même rares, doivent se trouver à
  # une distance normale (page) pour être signalés proche.
  MOTS_A_DISTANCE_MIN_FIXE = {
    'cet'     =>  300,
    'du'      =>  50,
    'dehors'  =>  '1p', # = 1 page
    'eux'     =>  '1p'
  }
  def evalue_valeurs_mots_a_distance_min_fixe
    MOTS_A_DISTANCE_MIN_FIXE.each do |cle, value|
      # Remplacer la valeur
    end
  end

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
