# encoding: UTF-8
class Texte
class Mot

  # La méthode retourne false si ce sont deux mots à distance minimum fixe
  # qui sont trop éloignés.
  # les deux mots ne sont donc pas en proximité
  def self.distance_minimum_fixe_too_big? motA, motB
    # Tests::Log.w('Texte::Mot::distance_minimum_fixe_too_big?(%{mota}, %{motb})', {mota: motA.mot.inspect, motb: motB.mot.inspect})
    MOTS_A_DISTANCE_MIN_FIXE.key?(motA.mot_base) || return # pour continuer
    # Tests::Log.w('MOTS_A_DISTANCE_MIN_FIXE[%{mot}] est définie à %{dist}', {mot:motA.mot.inspect, dist:MOTS_A_DISTANCE_MIN_FIXE[motA.mot_base]})
    # On retourne true (donc pour empêcher la proximité) quand la distance
    # entre les deux mots est supérieur à la distance minimale possible entre
    # ces deux mots
    # Tests::Log.w('Distance entre les deux mots = motB.offset - motA.offset = %{dist}', {dist: motB.offset - motA.offset})
    return MOTS_A_DISTANCE_MIN_FIXE[motA.mot_base] < (motB.offset - motA.offset)
  end

end #/Mot
end #/Texte
