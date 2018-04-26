# encoding: UTF-8
class Proximity

  DIVISEUR = '-'*120
  LONGUEUR_SEGMENT = 70

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
    extraits +
    "#{RET2}\t#{DIVISEUR}"
  end

  # Extraits à afficher
  # En mode interactif, on affiche le maximum de texte (si possible tout), alors
  # qu'en mode normal, on affiche seulement une portion.
  def extraits
    if CLI.options[:interactif]
      seg = Texte.current.segment.gsub(/\n/,'¶')
      off_avant = mot_avant.offset
      off_apres = mot_apres.offset
      off_fin = off_apres + mot_apres.length
      motX = 'X'*mot_avant.length
      motZ = 'Z'*mot_apres.length
      "\n\n" +
      (seg[(off_avant - 180)..(off_avant - 1)] +
        motX +
        seg[(off_avant + mot_avant.length)..(off_apres-1)] +
        motZ +
        seg[off_fin..(off_fin + 180)])
        .segmente(LONGUEUR_SEGMENT, "\t\t")
        .sub(/#{motX}/, mot_avant.mot.rouge)
        .sub(/#{motZ}/, mot_apres.mot.rouge) +
      "\n\n"

    else
      "#{RETT}\t1. #{mot_avant.extrait}"+
      "#{RETT}\t2. #{mot_apres.extrait}"
    end
  end

end #/Proximity
