class Texte
class Mot

  ARR_MOTS_FIN_S = [
    'après',
    'bras',
    'cas',
    'corps',
    'dans', 'depuis', 'dès',
    'extremis',
    'fois',
    'jamais',
    'mais',
    'nous',
    'pas', 'plus', 'plusieurs', 'puis',
    'sans', 'sous',
    'temps', 'toujours', 'trois',
    'vers', 'vous'
  ]
  ARR_MOTS_FIN_X = [
    'box',
    'deux',
    'eux',
    'mieux',
    'voix',
    'yeux'
  ]

  ARR_MOTS_FEMININS_E = [ # => MOTS_FEMININS
    'grand',
    'petit',
    'un'
  ]
  ARR_MOTS_FEMININS_NE = [ # => MOTS_FEMININS
    'brun'
  ]


  marque_temps 'Construction tables de mots divers (fin "s", "x", etc.)…'
  MOTS_FIN_S = Hash.new
  ARR_MOTS_FIN_S.each{|m|MOTS_FIN_S.merge!(m => true)}
  MOTS_FIN_X = Hash.new
  ARR_MOTS_FIN_X.each{|m|MOTS_FIN_X.merge!(m => true)}
  MOTS_FEMININS = Hash.new
  ARR_MOTS_FEMININS_E.each{|m|MOTS_FEMININS.merge!("#{m}e" => m)}
  ARR_MOTS_FEMININS_NE.each{|m|MOTS_FEMININS.merge!("#{m}ne" => m)}

end #/Mot
end #/Texte
