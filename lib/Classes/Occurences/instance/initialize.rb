# encoding: UTF-8
=begin
  Module des méthodes d'instanciation d'une instance Occurences
=end
class Occurences


  def initialize mot
    # Voir le module `data.rb` pour le détail
    mot.is_a?(String) || mot = mot.mot_base
    @mot          = mot
    @proximites   = Array.new # liste d'ID de Proximity
    @offsets      = Array.new # Liste de Integer (offset du mot)
    @indexes      = Array.new # Liste des index des mots
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
    if @offsets.empty? || imot.offset > @offsets[-1]
      # Le cas normal, où on ajoute les occurences les unes au bout des
      # autres. Par exemple lors de l'analyse du texte.
      @offsets << imot.offset
      @indexes << imot.index
    else
      # Le cas d'une insertion d'occurences, qui survient lorsqu'on modifie un
      # mot.
      #
      # Il faut trouver l'index où placer le nouveau mot
      index_new_mot = nil
      @offsets.each_with_index do |offset, index|
        if offset > imot.offset
          index_new_mot = index
          break
        end
      end
      index_new_mot || begin
        raise "Aucun index n'a été trouvé… C'est impossible, en passant par là…"
      end
      # On peut insérer l'offset et l'index à cet endroit.
      @offsets.insert(index_new_mot, imot.offset)
      @indexes.insert(index_new_mot, imot.index)
    end
    # Dans tous les cas, on ajoute les similarités et les dérivés au bout,
    # peu importe.
    similarite.nil?           || @similarites << imot.index
    imot.mot == imot.mot_base || @derives     << imot.index
    # ATTENTION : Si des listes sont ajoutées, il faut aussi les traiter dans la
    # méthode `Occurences#retire_mot`
  end


  # Ajoute
end #/Occurences
