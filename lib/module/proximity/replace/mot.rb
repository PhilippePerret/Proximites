# encoding: UTF-8
class Texte
class Mot

  # Pour remplacer le mot actuel par un autre mot
  def set_mot new_mot

    # Différence de longueur entre le mot précédent et le nouveau mot.
    diff_len = new_mot.length - length

    new_mot_base = Texte::Mot.get_mot_base(new_mot)

    # Il faut forcément le faire avant de mettre les nouvelles valeurs,
    # car l'occurence se sert de mot_base, par exemple.
    new_mot_base != mot_base && begin
      occurence.retire_mot(self)
    end

    # On peut véritablement modifier le mot.
    @mot        = new_mot
    @mot_base   = new_mot_base
    @length     = new_mot.length
    @offset_correction = diff_len

    # Il faut ajouter le mot à sa nouvelle instance d'occurences
    # On ajoute le mot à cette occurence, comme les autres. La méthode +add+
    # se charge de tout, notamment de créer l'instance s'il le faut.
    Occurences.add(self)

  end


end #/Mot
end #/Texte
