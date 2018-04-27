# encoding: UTF-8

class Texte
class Mot
POUR_BASE_MOTS = {
  # Base      => [déclinaisons]
  # -----------------------------
  'agir'      => ['agissait'],
  'aller'     => ['allait', 'allez', 'va', 'vais', 'vas'],
  'apercevoir'  => ['aperçut'],
  'appuyer'   => ['appuyé'],
  'arrêter'   => ['arrêta'],
  'arriver'   => ['arriva', 'arrivait', 'arrive', 'arrivé'],
  'attendre'  => ['attendez', 'attendit'],
  'avoir'     => ['a', 'aurait', 'auraient', 'avait', 'avaient', 'avez', 'eut', 'ont'],
  'chercher'  => ['chercha', 'cherchant'],
  'choisir'   => ['choisi'],
  'commencer' => ['commençait'],
  'comprendre'  => ['comprend', 'comprenait', 'compris'],
  'connaitre' => ['connais', 'connait', 'connaissait', 'connaissaient', 'connu'],
  'croire'    => ['crois', 'croit'],
  'décider'   => ['décida'],
  'devoir'    => ['devait', 'devaient', 'doit', 'doivent', 'du'],
  'dire'      => ['disait', 'dit'],
  'donner'    => ['donna', 'donné'],
  'entendre'  => ['entendit'],
  'essayer'   => ['essaie', 'essaya'],
  'être'      => ['est', 'était', 'étaient', 'été', 'êtes', 'sont', 'serait', 'seraient', 'suis'],
  'expliquer' => ['expliqué'],
  'falloir'   => ['fallait', 'faudrait', 'faut'],
  'faire'     => ['fais', 'fait', 'faisait', 'faisaient', 'fit', 'fut'],
  'glisser'   => ['glissa', 'glisse'],
  'laisser'   => ['laissa', 'laissai', 'laissait', 'laisse', 'laissez'],
  'lancer'    => ['lança', 'lançait'],
  'oublier'   => ['oublié'],
  'parler'    => ['parlé'],
  'partir'    => ['parti'],
  'passer'    => ['passa', 'passant'],
  'penser'    => ['pensa', 'pensai' 'pensé', 'pensez'],
  'pouvoir'   => ['peux', 'peut', 'pourra', 'pourrai', 'pourrait', 'pourraient', 'pouvait', 'pouvaient', 'pouvez', 'pouvons', 'pu'],
  'prendre'   => ['prenant', 'prend', 'prit'],
  'réaliser'  => ['réalisa'],
  'reconnaitre' => ['reconnut'],
  'regarder'  => ['regarda', 'regardai', 'regardait', 'regardant', 'regarde', 'regardent'],
  'rentrer'   => ['rentré', 'rentra'],
  'répondre'  => ['répondait', 'répondit', 'répondu'],
  'rester'    => ['resta', 'restais', 'restait', 'resté'],
  'retourner' => ['retournant', 'retourne', 'retournent'],
  'retrouver' => ['retrouva', 'retrouve'],
  'savoir'    => ['sais', 'sait', 'savait', 'savez', 'su'],
  'sembler'   => ['semblait'],
  'sentir'    => ['sentais', 'sent', 'sentait', 'sentit'],
  'serrer'    => ['serra'],
  'sortir'    => ['sortez', 'sortit'],
  'souvenir'  => ['souvenait'],
  'suivre'    => ['suivait', 'suivi'],
  'tendre'    => ['tend', 'tendais', 'tendait', 'tendit', 'tends'],
  'tenter'    => ['tenta', 'tentai', 'tentait'],
  'tirer'     => ['tirais', 'tirait'],
  'tourner'   => ['tourna'],
  'trouver'   => ['trouvait'],
  'venir'     => ['venait'],
  'vivre'     => ['vivait'],
  'vouloir'   => ['veut', 'veux', 'voulais', 'voulait', 'voulaient', 'voulez', 'voulu', 'voulut'],
  'voir'      => ['veux', 'voyait']
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
