# encoding: UTF-8
=begin
  Module gérant les mots du texte

=end
class Texte

  def mots
    @mots === nil && load_mots
    @mots
  end

  # On ajoute le mot du texte à l'instance Texte
  # En même temps, on gère les instances Occurences
  #
  # C'est la grande méthode qui permet ensuite de traiter les proximités.
  #
  # Retourne l'instance Texte::Mot du mot créé
  def add_mot mot_str, index_mot, current_offset, next_char = nil
    imot = Texte::Mot.new(self, mot_str, index_mot, current_offset, next_char || segment[current_offset + mot_str.length])
    #           Le caractère qui suit le mot --------------------------^
    @mots << imot
    Occurences.add(imot)
    return imot
  end

  def nombre_total_mots
    @nombre_total_mots ||= mots.count
  end

  def liste_mots
    @liste_mots ||= begin
      segment.split(/[^[[:alnum:]]]/)
    end
  end


end#/Texte
