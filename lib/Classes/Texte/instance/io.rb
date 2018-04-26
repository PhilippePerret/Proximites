# encoding: UTF-8
=begin
  Module des méthodes qui s'occupe des résultats obtenus sur le texte, aussi
  bien enregistrés que calculés sur place.
=end
class Texte

  def save_all
    `mkdir -p "#{Prox.folder}"`
    save_mots
    Occurences.save
    Proximity.save
  end

  def load_all
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
