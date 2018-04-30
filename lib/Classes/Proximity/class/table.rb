# encoding: UTF-8
class Proximity
class << self

  # La grande table qui va contenir toutes les proximités du texte courant.
  def table
    @table ||= Hash.new()
  end

  # Pour obtenir une proximité avec `Proximity[<id>]`
  def [] idprox
    table[idprox]
  end

  def count ; @count ||= table.count end

  # Ajoute l'instance proximité à la table et retourne le nouvel identifiant
  # donné (on a besoin de l'identifiant car c'est lui qui est conservé dans
  # l'instance occurences, sous l'appellation ``)
  def add iprox
    new_id_prox = table.count
    table.merge!(new_id_prox => iprox)
    return new_id_prox
  end

  # Pour détruire une proximité
  # Noter que ça ne correspond pas à la "suppression" d'une proximité en mode
  # interactif qui ne fait que marquer la proximité comme 'deleted'. Ici, la
  # proximité est vraiment détruite, ce qui se produit quand on change un mot.
  def destroy iprox
    table.delete(iprox.id)
    @count = nil
  end

  def save
    File.exist?(path_file_table) && File.unlink(path_file_table)
    File.open(path_file_table,'wb'){|f| Marshal.dump(table,f)}
  end
  def load with_message = true
    File.exist?(path_file_table) || begin
      Texte.current.analyse
      return
    end
    @table = File.open(path_file_table,'rb'){|f| Marshal.load(f)}
  end

end #/<< self
end #/ Proximity
