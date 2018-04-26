# encoding: UTF-8
class Texte

  # Le path du fichier, qui existe même si c'est un texte qui a été
  # fourni à la ligne de commande.
  attr_accessor :path

  def exist?
    @file_exists ||= File.exists?(path)
  end

  # Fichier Marshal contenant les proximités (ATTENTION : ici, il s'agit plutôt
  # des mots, avec, c'est vrai, l'indication des proximités)
  def path_file_mots
    @path_file_mots ||= File.join(Prox.folder, "#{Prox.today_mark}-mots.msh")
  end

end #/Texte
