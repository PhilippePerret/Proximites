# encoding: UTF-8
=begin
  Module des méthodes d'aide à l'affichage
=end
class Occurences

  ENTDT =     'MOT'.ljust(20) + 'NOMBRE'.ljust(8) + 'OFFSETS'.ljust(38) +
      ' T'.ljust(4)
  LINE_ENDTDT = ('-'*ENTDT.length)
  ENTETE_DISPLAY_TABLE = LINE_ENDTDT + "\n" + ENTDT + "\n" + LINE_ENDTDT + "\n"
  LEGENDE_DISPLAY_TABLE = <<-EOT

  T = Mot traitable dans les proximités

  EOT

  # Affichage de la table courante des occurences du mot de l'occurence
  def display_table
    offsets_disp = ''
    os = offsets.dup
    while offsets_disp.length < 30 && (o = os.shift)
      offsets_disp << "#{o} "
    end
    os.empty? || offsets_disp << '[…]'
    puts "*#{mot}*".ljust(20) + "#{count}".ljust(8) + "#{offsets_disp.ljust(38)}" +
      "#{traitable? ? 'oui ' : ' -  '}"
  end

end #/Occurences
