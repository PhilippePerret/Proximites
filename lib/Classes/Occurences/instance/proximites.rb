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
    distance = distance_min
    # Le mot précédent
    last_imot = nil

    # Boucle sur tous les indexs de mots
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

  # La méthode avec un "s" (check_proimites) checke toutes les proximités de
  # l'occurence du mot, celle-ci ne checke que le motA et le motB
  def check_proximite motA, motB
    motA && motA.trop_proche_de?(motB, distance_min) && begin
      # <= Une proximité a été détectée
      # => C'est peut-être un mauvaise proximité, mais il faut déjà vérifier
      Prox.log_check? && Prox.log_check("\t\t\t\tProximité détectée avec le mot précédent (à tester)")
      #    pour voir s'il ne s'agit pas d'une locution répétitive. Pour ce
      #    faire, on doit prendre le mot avant, le mot juste après le mot
      #    avant et le mot après.
      Texte::Mot.locution_repetitive?(motA, motB) || begin
        # => Il faut créer une proximité
        Prox.log_check? && Prox.log_check("\t\t\t\tPROXIMITÉ CONFIRMÉE")
        # puts "Le mot #{motB.mot_base.inspect} à #{motA.offset} est trop proche de celui à #{motB.offset} (distance = #{distance})"
        # puts "motA = #{motA.mot}:#{motA.offset} / motB = #{motB.mot}:#{motB.offset}"
        # STDOUT.flush
        prox = Proximity.new(motA, motB, distance_min)
        # On ajoute l'ID de la nouvelle proximité à la liste des proximités
        # de l'occurence de mot.
        self.proximites << prox.id
        # On ajoute cet ID également au mot avant et au mot après
        motA.add_proximite(prox, apres = true)
        motB.add_proximite(prox, apres = false)
      end
    end
  end
  # /check_proximite

end #/Occurences
class Texte
class Mot
  def trop_proche_de? imot, distance
    (imot.offset - self.offset) < distance
  end
end#/Mot
end #/Texte
