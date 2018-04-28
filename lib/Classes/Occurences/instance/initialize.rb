# encoding: UTF-8
=begin
  Module des méthodes d'instanciation d'une instance Occurences
=end
class Occurences


  def initialize mot
    # Voir le module `data.rb` pour le détail
    mot.is_a?(String) || mot = mot.mot_base
    @mot          = mot
    @offsets      = Array.new
    @indexes      = Array.new
    @proximites   = Array.new
    @derives      = Array.new # les mots dérivés (mot != mot_base)
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
    @offsets << imot.offset
    @indexes << imot.index
    similarite.nil?           || @similarites << imot.index
    imot.mot == imot.mot_base || @derives << imot.index
  end


  # Ajoute
end #/Occurences
