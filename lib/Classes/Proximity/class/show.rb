# encoding: UTF-8
class Proximity

  # Retourne TRUE si la proximité doit être affichée
  def displayable?
    CLI.options[:all] || (!treated? && !deleted?)
  end

class << self

  # Mis à true lorsque des changements ont été opérés sur les données des
  # proximités (par exemple pour les marquer traitées ou supprimées) et qu'il
  # faudrait donc les enregistrer.
  attr_accessor :changements_operes

  # Méthode affichant une proximité par son Identifiant
  def show_proximite_by_id prox_id
    show(prox_id.to_i)
  end

  def show mot = nil
    load_module 'proximity/show'
    _show(mot)
  end

end #/<< self
end #/Proximity
