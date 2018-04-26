# encoding: UTF-8
=begin
  Module contenant toutes les méthodes d'état des occurences, pour savoir,
  par exemple, si la proximité des mots doit être checkée
=end
class Occurences

  attr_accessor :raison_non_traitable

  # Longueur du mot (pour ne pas répéter l'opération tout le temps)
  def mot_length
    @mot_length ||= mot.length
  end

  # Présence du mot, ne fonction de son occurence et du nombre total de
  # mot.
  def presence
    @presence ||= (1000.0 * count / Texte.current.nombre_total_mots).round(2)
  end
  # Distance minimum pour ne pas considérer deux mots en proximité,
  # lorsque l'option --brut n'est pas utilisée
  def distance_min
    @distance_min ||= (Proximity::DISTANCE_MAX_NORMALE / presence).to_i
  end

end #/Occurences
