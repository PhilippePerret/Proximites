# encoding: UTF-8
class Proximity

  attr_reader :id
  attr_reader :mot_avant, :mot_apres
  attr_reader :distance_min

  # Méthode couleur pour afficher la proximité dans le texte
  # Par exemple :vert, ou :rouge, ou :gris
  attr_accessor :color

  def initialize mot_avant, mot_apres, distance_min
    @id           = self.class.add(self)
    @mot_avant    = mot_avant
    @mot_apres    = mot_apres
    @distance_min = distance_min
    # puts "Ajout d'une proximité #{mot_avant.mot}:#{mot_avant.offset} <-> #{mot_apres.mot}:#{mot_apres.offset}"
    STDOUT.flush
  end

  # Distance entre les deux mots, en nombre de signes
  def distance
    @distance ||= mot_apres.offset - mot_avant.offset
  end

  # La centaine de cette proximité (en fonction de la distance)
  # 0 de 1 à 99, 1 de 100 à 199, etc.
  def centaine
    @centaine ||= (distance / 100)
  end

end #/ Proximity
