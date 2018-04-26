# encoding: UTF-8
=begin
  Module des méthodes d'instanciation d'une instance Occurences
=end
class Occurences


  def initialize mot
    # Voir le module `data.rb` pour le détail
    @mot          = mot
    @indexes      = Array.new
    @proximites   = Array.new
    @similarites  = Array.new # les mots similaires
  end

  # Ajoute l'instance {Texte::Mot} de +imot+ dans l'occurence courante
  #
  # C'est la méthode de base qui est utilisée à l'analyse du texte et sa
  # décomposition en mots
  # @param {Texte::Mot} imot
  #
  def add imot, similarite = nil
    suivi "Ajout d’une occurence de #{imot.mot_base.inspect}"
    @indexes << imot.index
    similarite.nil? || @similarites << imot.index
  end


  # Ajoute
end #/Occurences
