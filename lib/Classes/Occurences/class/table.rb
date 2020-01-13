# encoding: UTF-8
=begin
  Module des méthodes qui gère la class Occurences en tant que liste des
  occurences du texte.
  (contrairement aux instances qui s'occupent d'une seule occurence de mot)
=end
class Occurences
class << self


  def table ; @table ||= Hash.new  end

  # Retourne l'instance {Occurences} du mot +mot+.
  # Ou retourne NIL.
  # AVANT : elle créait dans tous les cas l'instance, mais ça posait des
  # problèmes dès qu'on voulait checker l'existence d'un mot par
  # Occurences[mot]. C'était toujours vrai puisque ça créait l'instance.
  #
  # @param {String|Texte::Mot} Le mot de base ou le mot string.
  # @return {Occurences} Instance occurence du mot.
  #
  def [] mot
    mot.is_a?(String) || mot = mot.mot_base
    table[mot]
  end

  # Le nombre de mots unique aka d'occurences (pour l'affichage surtout)
  def count ; @count ||= table.count end

  # Méthode qui sauve la table des occurences
  #
  # Noter que ça sauve tout d'un coup
  def save
    File.exist?(path_occurences) && File.unlink(path_occurences)
    File.open(path_occurences,'wb'){|f| Marshal.dump(table, f)}
  end

  # Méthode qui charge la table des occurences
  def load
    File.exist?(path_occurences) || begin
      Texte.current.analyse
      return
    end
    @table = File.open(path_occurences,'rb'){|f| Marshal.load(f)}
  end

  # Affiche toutes les occurences
  def show
    if CLI.options[:output]
      # <= Sortie dans un fichier
      p = File.expand_path('./occurences')
      error "La sortie en fichier est à implémenter"
    else
      # Sortie en console
      display_table_occurences
    end
  end

  def path_occurences
    @path_occurences ||= File.join(Prox.folder,'occurences.msh')
  end
end #/<< self
end #/ Occurences
