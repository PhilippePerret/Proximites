# encoding: UTF-8
class Proximity
class << self

  attr_reader :last_id

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
    prox_id = next_prox_id
    table.merge!(prox_id => iprox)
    @count = nil
    return prox_id
  end
  def next_prox_id
    @last_id ||= 0
    @last_id += 1
  end

  # Pour détruire une proximité
  # Noter que ça ne correspond pas à la "suppression" d'une proximité en mode
  # interactif qui ne fait que marquer la proximité comme 'deleted'. Ici, la
  # proximité est vraiment détruite, ce qui se produit quand on change un mot.
  #
  # Il faut aussi désolidariser les deux mots associés à cette proxmité.
  def destroy prox_id
    prox_id.is_a?(Integer) || prox_id = prox_id.id
    iprox = table[prox_id]
    occur_motA = Occurences[iprox.mot_avant.mot_base]
    occur_motA && occur_motA.retire_proximite(iprox.mot_avant.prox_ids[:apres])
    occur_motB = Occurences[iprox.mot_apres.mot_base]
    occur_motB && occur_motB.retire_proximite(iprox.mot_apres.prox_ids[:avant])
    iprox.mot_avant.prox_ids[:apres] = nil
    iprox.mot_apres.prox_ids[:avant] = nil
    @table.delete(prox_id)
    @count = table.count
    Tests::Log << "Nouveau compte de proximités mis à #{count} après destruction de proximité ##{prox_id}."
  end

  def save
    File.exist?(path_file_table) && File.unlink(path_file_table)
    File.open(path_file_table,'wb'){|f| Marshal.dump({table: table, last_id: last_id},f)}
  end
  def load with_message = true
    File.exist?(path_file_table) || begin
      Texte.current.analyse
      return
    end
    res = File.open(path_file_table,'rb'){|f| Marshal.load(f)}
    @table    = res[:table]
    @last_id  = res[:last_id]
  end

end #/<< self
end #/ Proximity
