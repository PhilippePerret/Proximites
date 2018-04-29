# encoding: UTF-8
=begin
  Module des méthodes qui s'occupe des résultats obtenus sur le texte, aussi
  bien enregistrés que calculés sur place.
=end
class Texte

  def save_all
    Prox.log_check? && Prox.log_check("*** Sauvegarde de tous les éléments…", is_op = true)
    `mkdir -p "#{Prox.folder}"`
    Prox.log_check? && Prox.log_check("  * Sauvegarde des mots…")
    save_mots
    Prox.log_check? && Prox.log_check("  * Sauvegarde des occurences…")
    Occurences.save
    Prox.log_check? && Prox.log_check("  * Sauvegarde des proximités…")
    Proximity.save
    Prox.log_check? && Prox.log_check("=== Fin de la sauvegarde", is_op = true)
  end

  def load_all
    suivi '-> Texte#load_all'
    load_mots
    Occurences.load
    Proximity.load
  end

  # Pour sauver les informations de proximité des mots
  def save_mots
    suivi '-> Texte#save_mots'
    File.exist?(path_file_mots) && File.unlink(path_file_mots)
    File.open(path_file_mots,'wb'){|f| Marshal.dump(self.mots, f)}
  end

  def load_mots sans_message = nil
    suivi '-> Texte#load_mots'
    File.exist?(path_file_mots) || begin
      analyse
      return
    end
    @mots = File.open(path_file_mots,'rb'){|f| Marshal.load(f)}
  end


end#/Texte
