# encoding: UTF-8
=begin
  Module des méthodes qui s'occupe des résultats obtenus sur le texte, aussi
  bien enregistrés que calculés sur place.
=end
class Texte

  def save_all
    Tests::Log << '-> Texte#save_all'
    Prox.log_check? && Prox.log_check("*** Sauvegarde de tous les éléments…", is_op = true)
    `mkdir -p "#{Prox.folder}"`
    Prox.log_check? && Prox.log_check("  * Sauvegarde des mots…")
    save_mots
    Prox.log_check? && Prox.log_check("  * Sauvegarde des occurences…")
    Occurences.save
    Prox.log_check? && Prox.log_check("  * Sauvegarde des proximités…")
    Proximity.save
    Prox.log_check? && Prox.log_check("=== Fin de la sauvegarde", is_op = true)
    Tests::Log << '<- Texte#save_all'
  end

  def load_all
    Tests::Log << '-> Texte#load_all'
    load_mots
    Occurences.load
    Proximity.load
    # On va faire un contrôle ici pour savoir si les instances ont les mêmes
    # ID absolus
    Proximity.table.each do |prox_id, iprox|
      motA      = iprox.mot_avant
      ind_motA  = motA.index
      motA.object_id == Texte.current.mots[ind_motA].object_id || begin
        raise "Proximity ##{iprox.id} : l’instance du mot avant ne correspond pas (object_id)."
      end
      motB      = iprox.mot_apres
      ind_motB  = motB.index
      motB.object_id == Texte.current.mots[ind_motB].object_id || begin
        raise "Proximity ##{iprox.id} : l’instance du mot après ne correspond pas (object_id)."
      end
    end
    Tests::Log << 'Au chargement, les object_id des intances Texte::Mot des proximités correspondent.'
  end

  # Pour sauver les informations de proximité des mots
  def save_mots
    Tests::Log.print '-> Texte#save_mots… '
    File.exist?(path_file_mots) && File.unlink(path_file_mots)
    # Contrôle des mots enregistrés
    # Tests::Log << "Détail des données de mots enregistrés :"
    # mots.each do |imot|
    #   Tests::Log << imot.inspect
    # end
    File.open(path_file_mots,'wb'){|f| Marshal.dump(self.mots, f)}
    Tests::Log << 'OK'
  end

  def load_mots sans_message = nil
    Tests::Log.print '-> Texte#load_mots... '
    File.exist?(path_file_mots) || begin
      analyse
      return
    end
    @mots = File.open(path_file_mots,'rb'){|f| Marshal.load(f)}
    Tests::Log << 'OK'
    return @mots
  end


end#/Texte
