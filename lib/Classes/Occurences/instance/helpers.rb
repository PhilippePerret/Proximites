# encoding: UTF-8
=begin
  Module des méthodes d'aide à l'affichage
=end
class Occurences

  ENTDT =     ' MOT'.ljust(20) +
    'NOMBRE'.ljust(8)       +
    'PRÉSENCE'.ljust(12)    +
    'DISTANCE'.ljust(9)     +
    ' TRAITER ?'.ljust(20)
  LINE_ENDTDT = ('-'*ENTDT.length)
  ENTETE_DISPLAY_TABLE = RET3 + LINE_ENDTDT + RET + ENTDT + RET + LINE_ENDTDT + RET
  LEGENDE_DISPLAY_TABLE = <<-EOT

  * Classement %{sorted}
  * La `DISTANCE` représente le nombre de signes minimum qui doivent séparer deux mots
    pour qu’ils ne soient pas considérés en proximité.

  EOT

  # Affichage de la table courante des occurences du mot de l'occurence
  def display_table
    mot_str       = "*#{mot}*".ljust(20)
    count_str     = " #{count}".ljust(8)
    # offset_str  = "#{offsets_disp.ljust(38)}"
    presence_str  = "#{presence} ‰".ljust(12)
    dist_str      = " #{distance_min}".ljust(9)
    trait_str     = "#{traitable? ? ' oui' : raison_non_traitable}".ljust(20)
    traitable? || trait_str = trait_str.gris
    puts mot_str + count_str + presence_str + dist_str + trait_str

  end
  #/display_table

end #/Occurences
