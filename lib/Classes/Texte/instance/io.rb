# encoding: UTF-8
=begin
  Module des méthodes qui s'occupe des résultats obtenus sur le texte, aussi
  bien enregistrés que calculés sur place.
=end
class Texte

  def save_mots_et_occurences
    `mkdir -p "#{Prox.folder}"`
    # Enregistrement des mots
    save_mots
    # Enregistrement des occurences
    Occurences.save
  end

  def load_mots_et_occurences
    load_mots
    Occurences.load
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
