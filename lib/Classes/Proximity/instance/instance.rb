# encoding: UTF-8
class Proximity

  attr_reader :mot_avant, :mot_apres

  def initialize mot_avant, mot_apres
    @mot_avant = mot_avant
    @mot_apres = mot_apres
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
