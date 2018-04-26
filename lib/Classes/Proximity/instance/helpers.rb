# encoding: UTF-8
class Proximity

  DIVISEUR = '-'*120

  # Affichage de la ligne définissant la proximité courante, pour affichage
  #
  # On peut faire soit un affichage complet de toutes les occurences, soit,
  # avec l'option -i/-interactif, afficher proximité après proximité, ce qui
  # permet de les "annoter"
  def as_line index = nil, nombre_total
    index ||= (1 + id).to_s
    mots = "#{"##{id}".to_s.gris} #{mot_avant.mot.jaune} - #{mot_apres.mot.jaune}".ljust(60)
    dist = "à #{distance} signes (min: #{distance_min})".ljust(40).gris
    nomb = "#{index} / #{nombre_total || Proximity.count}".ljust(30)
    offs = "#{mot_avant.offset} / #{mot_apres.offset}".ljust(24)
    "\n\n\t#{DIVISEUR}"
    "\t#{mots}#{dist}offset : #{offs}#{nomb}\n" +
    "#{RETT}\t1. #{mot_avant.extrait}"+
    "#{RETT}\t2. #{mot_apres.extrait}"+
    "#{RET2}\t#{DIVISEUR}"
  end

end #/Proximity
