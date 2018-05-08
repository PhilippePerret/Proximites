# encoding: UTF-8
=begin
  Module calculant les proximités dans l'occurence voulue

  Principe :
    On passe en revue tous les mots retenus, on prend leur distance
    par rapport à l'occurence suivante. Si cette occurence est trop
    rapprochée (distance_min ou la distance par défaut) alors on génènre une
    proximité (instance Proximité).

=end
class Occurences


  # Recherche les proximités qui peuvent exister dans un texte.
  def check_proximites
    # distance = distance_min

    # Boucle sur tous les indexs de mots
    last_imot = nil # Le mot précédent
    indexes.each do |index_mot|
      imot = texte.mots[index_mot]
      Prox.log_check? && Prox.log_check("\t\t\tOccurence d’index #{index_mot} (offset: #{imot.offset})")
      # ===============================
      check_proximite(last_imot, imot)
      # ===============================
      last_imot = imot
    end
  end
  # /check_proximites

end #/Occurences
class Texte
class Mot
end#/Mot
end #/Texte
