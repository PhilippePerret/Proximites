class Texte
class Mot

  ARR_MOTS_FIN_S = [
    'accès', 'alors', 'après', 'assis',
    'bras',
    'cas', 'corps', 'cours',
    'dans', 'dehors', 'depuis', 'dès', 'dessous', 'dessus',
    'extremis',
    'fois',
    'jamais',
    'mais', 'moins',
    'nous',
    'pas', 'plus', 'plusieurs', 'propos', 'puis',
    'sans', 'sous',
    'temps', 'toujours', 'tous', 'très', 'trois',
    'vers', 'vous'
  ]
  ARR_MOTS_FIN_X = [
    'box',
    'ceux', 'choix',
    'deux',
    'eux',
    'heureux',
    'mieux',
    'paix',
    'voix',
    'yeux'
  ]

  ARR_MOTS_FEMININS_E = [ # => MOTS_FEMININS
    'clandestin',
    'différent',
    'fin',
    'grand',
    'mauvais',
    'petit',
    'un'
  ]
  ARR_MOTS_FEMININS_NE = [ # => MOTS_FEMININS
    'brun'
  ]

  ARR_MOTS_FEMININS_TE = [ # => MOTS_FEMININS
    'cet'
  ]


  MOTS_FIN_S = Hash.new
  ARR_MOTS_FIN_S.each{|m|MOTS_FIN_S.merge!(m => true)}
  MOTS_FIN_X = Hash.new
  ARR_MOTS_FIN_X.each{|m|MOTS_FIN_X.merge!(m => true)}
  MOTS_FEMININS = Hash.new
  ARR_MOTS_FEMININS_E.each{|m|MOTS_FEMININS.merge!("#{m}e" => m)}
  ARR_MOTS_FEMININS_NE.each{|m|MOTS_FEMININS.merge!("#{m}ne" => m)}
  ARR_MOTS_FEMININS_TE.each{|m|MOTS_FEMININS.merge!("#{m}te" => m)}

end #/Mot
end #/Texte
