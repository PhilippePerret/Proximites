# encoding: UTF-8
=begin
  Module des méthodes qui gère la class Occurences en tant que liste des
  occurences du texte.
  (contrairement aux instances qui s'occupent d'une seule occurence de mot)
=end
class Occurences
class << self

  # La table complète de toutes les listes d'occurences
  attr_reader :table

  # Retourne l'instance {Occurences} du mot +mot+ en la créant si elle n'existe
  # pas.
  def [] mot
    @table      ||= Hash.new
    @table[mot] ||= new(mot)
  end

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
    suivi '-> Occurences::show'
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
    @path_occurences ||= File.join(Prox.folder,"#{Prox.today_mark}-occurences.msh")
  end
end #/<< self
end #/ Occurences
