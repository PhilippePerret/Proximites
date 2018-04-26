# encoding: UTF-8

class Texte
class Mot
POUR_BASE_MOTS = {
  # Base      => [déclinaisons]
  # -----------------------------
  'aller'     => ['allez', 'va', 'vas'],
  'avoir'     => ['a', 'aurait', 'auraient', 'avait', 'avaient', 'avez'],
  'connaitre' => ['connaissait', 'connaissaient'],
  'devoir'    => ['devait', 'devaient', 'doit', 'doivent', 'du'],
  'être'      => ['est', 'était', 'étaient', 'été', 'sont', 'serait', 'seraient'],
  'faire'     => ['fait', 'faisait', 'faisaient', 'fit', 'fut'],
  'pouvoir'   => ['pouvait', 'pouvaient', 'pu'],
  'savoir'    => ['sais', 'sait', 'savait', 'su'],
  'sentir'    => ['sentais', 'sent'],
  'suivre'    => ['suivi'],
  'tourner'   => ['tourna']
}

# On peut construire la table qui va vraiment servir à retrouver le mot de
# base de façon rapide.
# TODO Voir si à la longue ça ne risque pas de devenir lourd de faire ça.
# marque_temps 'Construction de la table BASES_MOTS…'
BASES_MOTS = Hash.new()
POUR_BASE_MOTS.each do |motbase, liste_real_mots|
  liste_real_mots.each do |real_mot|
    BASES_MOTS.merge!(real_mot => motbase)
  end
end


end #/Mot
end #/Texte
