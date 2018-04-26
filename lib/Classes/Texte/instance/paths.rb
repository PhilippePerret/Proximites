# encoding: UTF-8
class Texte

  # Le path du fichier, si le texte se trouve dans un fichier
  attr_accessor :path

  # Retourne true si le texte a un fichier (ce qui n'est pas le cas lorsqu'il
  # est donné directement en ligne de commande)
  attr_writer :has_a_file

  def exist?
    path && File.exists?(path)
  end

  def has_file? ; @has_a_file end

  # Fichier Marshal contenant les proximités (ATTENTION : ici, il s'agit plutôt
  # des mots, avec, c'est vrai, l'indication des proximités)
  def path_file_mots
    @path_file_mots ||= File.join(Prox.folder, "#{Prox.today_mark}-mots.msh")
  end

end #/Texte
