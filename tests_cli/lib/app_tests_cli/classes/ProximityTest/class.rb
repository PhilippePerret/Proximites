# encoding: UTF-8
=begin
  Une classe propre à l'application permettant de récupérer les
=end
class ProximityTest
class << self

  # Retourne une instance Proximity par son index
  def get_by_index index
    proximites.values[index]
  end
  # Retourne une instance Proximity par son ID
  def get_by_id prox_id
    proximites[prox_id]
  end

  # Récupère la table des proximités (Proximity.table)
  # Note : à chaque appel le fichier est relu
  #
  # On peut indiquer le dossier par +path_folder+, il s'agit du dossier contenant
  # l'analyse.
  def proximites
    p = File.join(get_current_path,'proximites.msh')
    File.exist?(p) || raise("Le fichier #{p.inspect} des occurences est introuvable… Il faut lancer un check de texte avant ou définir le path du dossier en argument.")
    res = File.open(p,'rb'){|f|Marshal.load(f)}
    @last_id = res[:last_id]
    res[:table]
  end
  def count
    proximites.count
  end
  def show
    proximites.each do |prox_id, iprox|
      puts iprox.inspect
    end
  end

  # Retourne le path du fichier courant, c'est-à-dire traité par une autre
  # commande précédente. Par défaut, ce sera './.texte_prov', comme quand c'est
  # un texte qui est fourni à la commande check.
  def get_current_path
    Tests.current_folder_proximites
  end
end#<< self
end
