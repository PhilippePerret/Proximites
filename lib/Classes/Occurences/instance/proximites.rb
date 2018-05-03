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
  # l'occurence du mot, celle-ci ne checke que le motA et le motB et crée
  # l'instance de proximité si une proximité est décellée
  def check_proximite motA, motB
    motA && motA.trop_proche_de?(motB, distance_min) || return
    # <= Une proximité a été détectée
    # => C'est peut-être un mauvaise proximité, mais il faut déjà vérifier
    Prox.log_check? && Prox.log_check("\t\t\t\tProximité détectée avec le mot précédent (à tester)")
    #    pour voir s'il ne s'agit pas d'une locution répétitive. Pour ce
    #    faire, on doit prendre le mot avant, le mot juste après le mot
    #    avant et le mot après.
    Texte::Mot.locution_repetitive?(motA, motB) && return
    # Pour voir s'il ne s'agit pas de mot à distance minimum fixe qui sont
    # trop éloignés
    Texte::Mot.distance_minimum_fixe_too_big?(motA, motB) && return

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
  # /check_proximite

end #/Occurences
class Texte
class Mot
  def trop_proche_de? imot, distance
    (imot.offset - self.offset) < distance
  end

  # La méthode retourne false si ce sont deux mots à distance minimum fixe
  # qui sont trop éloignés.
  # les deux mots ne sont donc pas en proximité
  def self.distance_minimum_fixe_too_big? motA, motB
    Tests::Log.w('Texte::Mot::distance_minimum_fixe_too_big?(%{mota}, %{motb})', {mota: motA.mot.inspect, motb: motB.mot.inspect})
    MOTS_A_DISTANCE_MIN_FIXE.key?(motA.mot_base) || return # pour continuer
    Tests::Log.w('MOTS_A_DISTANCE_MIN_FIXE[%{mot}] est définie à %{dist}', {mot:motA.mot.inspect, dist:MOTS_A_DISTANCE_MIN_FIXE[motA.mot_base]})
    # On retourne true (donc pour empêcher la proximité) quand la distance
    # entre les deux mots est supérieur à la distance minimale possible entre
    # ces deux mots
    Tests::Log.w('Distance entre les deux mots = motB.offset - motA.offset = %{dist}', {dist: motB.offset - motA.offset})
    return MOTS_A_DISTANCE_MIN_FIXE[motA.mot_base] < (motB.offset - motA.offset)
  end
end#/Mot
end #/Texte
