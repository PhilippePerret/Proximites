# encoding: UTF-8
=begin
  Module contenant toutes les méthodes d'état des occurences, pour savoir,
  par exemple, si la proximité des mots doit être checkée
=end
class Occurences

  # {String} Le mot dont c'est l'occurence
  # ATTENTION : Il s'agit bien d'une class String. Dans la classe Occurences,
  # les instances Texte::Mot portent le nom `imot`.
  attr_reader :mot

  # {Array of Fixnum} Tous les décalages de mots de cette occurence
  attr_reader :indexes

  # {Array of ID de proximités} Toutes les proximités relevées
  attr_reader :proximites

  # {Array d'indexs} Mots dérivés (mot != mot_base)
  attr_reader :derives

  # {Array des index des mots en similarités}
  attr_reader :similarites

  # Raison du non traitement de l'occurence courante (peut être parce que le
  # mot est trop court, peut-être parce que mot est unique, etc.)
  attr_accessor :raison_non_traitable

  # Raccourci
  def texte ; @texte ||= Texte.current end

  # Nombre d'occurences du mot
  def count ; @count ||= indexes.count end

  # Longueur du mot (pour ne pas répéter l'opération tout le temps)
  def mot_length ; @mot_length ||= mot.length end

  # Présence du mot, ne fonction de son occurence et du nombre total de
  # mot. En nombre pour mille.
  def presence
    @presence ||= (1000.0 * count / Texte.current.nombre_total_mots).round(2)
  end
  # Distance minimum pour ne pas considérer deux mots en proximité,
  # lorsque l'option --brut n'est pas utilisée
  def distance_min
    @distance_min ||= begin
      d = (Proximity::DISTANCE_MAX_NORMALE / presence).to_i
      d > Proximity::DISTANCE_MIN_POSSIBLE || d = Proximity::DISTANCE_MIN_POSSIBLE
      d < Proximity::DISTANCE_MAX_POSSIBLE || d = Proximity::DISTANCE_MAX_POSSIBLE
      d
    end
  end

end #/Occurences
