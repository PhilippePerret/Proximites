# encoding: UTF-8
class Proximity

  DIVISEUR = '-'*120
  LONGUEUR_SEGMENT = 70

  # Affichage de la ligne définissant la proximité courante, pour affichage
  #
  # On peut faire soit un affichage complet de toutes les occurences, soit,
  # avec l'option -i/-interactif, afficher proximité après proximité, ce qui
  # permet de les "annoter"
  def as_block index = nil, nombre_total
    # "\n\n\t#{DIVISEUR}"
    "\t" + as_line(index = nil, nombre_total = nil) + "\n"
    extraits +
    "#{RET2}\t#{DIVISEUR}"
  end

  def as_line index = nil, nombre_total = nil
    index ||= (1 + id).to_s
    id_str = "#{"##{id}".to_s.ljust(9)}".gris
    dist = "<- #{distance} ->".gris
    mots = "#{mot_avant.mot.jaune} #{dist} #{mot_apres.mot.jaune}".ljust(70)
    mindist = "(min: #{distance_min})".ljust(14).gris
    nomb = "#{index}/#{nombre_total || Proximity.count}".ljust(25)
    offs = "#{mot_avant.offset}/#{mot_apres.offset}".ljust(20)
    "#{id_str}#{mots}#{mindist}offsets: #{offs}#{nomb}"
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
