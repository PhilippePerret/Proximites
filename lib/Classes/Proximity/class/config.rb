# encoding: UTF-8
class Proximity
class << self


  # Distance de proximité normale entre deux occurences du même mot ou mot
  # similaire.
  #
  # On peut définir cette valeur avec --dmax_possible, qui est enregistré
  # dans les données du texte.
  def distance_max_normale ; @distance_max_normale ||= DISTANCE_MAX_NORMALE end
  def distance_max_normale= value ; @distance_max_normale = value end

  # La distance possible entre deux mots dépend de son occurence. Plus un mot
  # est rare et plus sa distance de proximité est grande.
  # On peut définir cette valeur avec --dmax_possible, qui est enregistré
  # dans les données du texte.
  def distance_max_possible ; @distance_max_possible ||= DISTANCE_MAX_POSSIBLE end
  def distance_max_possible= value ; @distance_max_possible = value end

end #/<< self
end #/Proximity
