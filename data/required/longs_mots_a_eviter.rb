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
    'alors'   =>  300,  'arrière' =>  300,  'avant'   =>  100, 'avec'    =>  100,
    'bien'    =>  400,
    'cet'     =>  300,  'comme'   =>  400,
    'dans'    =>  300,  'dehors'  =>  '1p', 'depuis'  =>  500, 'derrière' => 300, 'du' =>  50,
    'eux'     =>  '1p',
    'jamais'  =>  150,
    'leur'    =>  300,
    'mais'    =>  50,   'même' => 400,
    'peu'     =>  150, 'plus'    =>  200, 'pour'    =>  200,
    'que'     =>  100, 'qui'     =>  200,
    'sans'    =>  300, 'sous'    =>  300, 'sur' => 300,
    'trop'    =>  300,
    'vers'    =>  400
  }
  def self.evalue_valeurs_mots_a_distance_min_fixe
    MOTS_A_DISTANCE_MIN_FIXE.each do |cle, value|
      value =
        case value
        when Fixnum then value
        when /^([0-9]+)p$/
          # => Nombre de pages
          nombre_pages = $1.to_i
        end
      MOTS_A_DISTANCE_MIN_FIXE[cle] = value
    end
  end

  # TODO Je pense que c'est toute l'expression "de MOT en MOT" qu'il faut
  # traiter comme n'étant pas une répétition.
  # TODO Traiter "mètre par mètre", "coudée par coudée", "centimètre par centimètre"
  # TODO Traiter "mot pour mot", "geste pour geste", etc.
  LOCUTIONS_REPETITIVES = {
    'loin'  => ['loin en loin'],
    'moins' => ['moins en moins'],
    'peu'   => ['peu à peu'],
    'temps' => ['temps en temps'],
    'coute' => ['coute que coute'],
    'encore' => ['encore et encore'] # penser au test des deux mots
  }

  LOCUTIONS_TIRETS = {
    'peut' => ['peut-être']
  }
end# Mot
end# Texte
