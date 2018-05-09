# encoding: UTF-8
class OccurencesTest
class << self

  def [] mot
    occurences[mot]
  end

  # Récupère la table des occurences (Occurences.table)
  # Note : à chaque appel le fichier est relu
  #
  # On peut indiquer le dossier par +path_folder+, il s'agit du dossier contenant
  # l'analyse.
  def occurences path_folder = nil
    # path_folder ||= './.texte_prov'
    p = File.join(get_current_path,'occurences.msh')
    File.exist?(p) || raise("Le fichier #{p.inspect} des occurences est introuvable… Il faut lancer un check de texte avant ou définir le path du dossier en argument.")
    @table = File.open(p,'rb'){|f|Marshal.load(f)}
  end

  def count
    occurences.count
  end

  # Retourne le path du fichier courant, c'est-à-dire traité par une autre
  # commande précédente. Par défaut, ce sera './.texte_prov', comme quand c'est
  # un texte qui est fourni à la commande check.
  def get_current_path
    Tests.current_folder_proximites
  end

end #/<< self
end #/OccurencesTest
