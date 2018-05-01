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
  def proximites path_folder = nil
    path_folder ||= './.texte_prov'
    p = File.join(path_folder,'proximites-texte','proximites.msh')
    File.exist?(p) || raise("Le fichier #{p.inspect} des proximités est introuvable… Il faut lancer un check de texte avant.")
    File.open(p,'rb'){|f|Marshal.load(f)}
  end
  def count
    proximites.count
  end
  alias :original_puts :puts
  def puts
    proximites.each do |prox_id, iprox|
      original_puts iprox.inspect
    end
  end
end#<< self
end
