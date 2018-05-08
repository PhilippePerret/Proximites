# encoding: UTF-8
class Proximity

  attr_reader :id

  # Malheureusement, à l'enregistrement et au rechargement, on n'obtient pas
  # les mêmes instances. Donc il faut le faire autrement, en faisant un vrai
  # lien vers l'instance par son index
  # attr_reader :mot_avant, :mot_apres
  attr_reader :mot_avant_index, :mot_apres_index
  attr_reader :distance_min

  # Méthode couleur pour afficher la proximité dans le texte
  # Par exemple :vert, ou :rouge, ou :gris
  attr_accessor :color

  def initialize mot_avant, mot_apres, distance_min
    @id           = self.class.add(self)
    # Tests::Log << "Instanciation de la proximité ##{@id} entre les mots #{mot_avant.real_mot}:#{mot_avant.index} et #{mot_apres.real_mot}:#{mot_apres.index}"
    # Ici, les instances mot_avant et mot_apres sont bien les instances dans la
    # liste des mots. Pour le vérifier, on peut débloquer les trois lignes
    # suivantes et lancer un test quelconque qui crée des proximités
    # Tests::Log << 'Instanciation de la proximité'+RETT+
    #   "ID objet mot_avant:#{mot_avant.object_id} / dans mots : #{texte_courant.mots[mot_avant.index].object_id}"+RETT+
    #   "ID objet mot_apres:#{mot_apres.object_id} / dans mots : #{texte_courant.mots[mot_apres.index].object_id}"+RETT
    # @mot_avant    = mot_avant
    # @mot_apres    = mot_apres
    @mot_avant_index  = mot_avant.index
    @mot_apres_index  = mot_apres.index
    @distance_min     = distance_min
  end

  def mot_avant
    Texte.current.mots[mot_avant_index]
  end
  def mot_apres
    Texte.current.mots[mot_apres_index]
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
