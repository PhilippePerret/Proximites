# encoding: UTF-8

class ProximityTest
class << self
  def get_by_index index
    proximites.values[index]
  end
  def get_by_id prox_id
    proximites[prox_id]
  end
  def proximites
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
