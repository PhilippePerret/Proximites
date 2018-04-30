# encoding: UTF-8
=begin

  Module contenant les méthodes de calculs sur le texte

=end
class Proximity
class << self

  # Retourne la durée estimée de correction au format humain
  # Note : ne pas mettre ce calcul dans une propriété @, car il faut
  # faire ce calcul souvent.
  def estimation_duree_corrections nombre_corrections
    calc_duree_corrections(nombre_corrections).to_i.as_workdays
  end
  # Retourne la durée estimée de correction en secondes.
  # Note : maintenant, :duree_moy_correction_prox est toujours défini.
  # NE PAS METTRE DANS UNE VARIABLE @
  def calc_duree_corrections nombre_corrections
    (texte.info(:duree_moy_correction_prox) * nombre_corrections)
  end

end #/<< self
end #/Proximity
