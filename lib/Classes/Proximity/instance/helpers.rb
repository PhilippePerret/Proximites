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
    "\t" + as_line(index = nil, nombre_total = nil) + "\n" +
    extraits +
    "\t" + as_line(index = nil, nombre_total = nil) + "\n" +
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
    mod  = case
    when deleted? then 'DEL'
    when treated? then 'COR'
    else ' '
    end.rjust(4)
    mod = case
    when deleted? then mod.rouge
    when treated? then mod.vert
    else mod
    end
    "#{id_str}#{mots}#{mindist}offsets: #{offs}#{nomb}#{mod}"
  end

  # Extraits à afficher
  # En mode interactif, on affiche le maximum de texte (si possible tout), alors
  # qu'en mode normal, on affiche seulement une portion.
  #
  # Note : avant, on travaillait avec le segment, mais cela ne prenait pas en
  # compte les modifications des proximités. Maintenant, tous les textes se
  # servent des mots (instances Texte::Mot) pour faire les textes.
  #
  # TODO Utiliser les mots du texte pour reconstituer le segment.
  def extraits
    if CLI.options[:interactif]
      # Fonctionnement, maintenant qu'on fonctionne avec les mots
      # On part du mot-avant
      # On construit la partie précédente jusqu'à une certaine longueur
      # qui peut être modifiée par l'utilisateur.
      # On construit ensuite le texte du mot-avant au mot-après,
      # Puis on construit jusqu'à une certaine distance après le mot

      # La longueur attendu avant et après les mots
      longueur_autour_extrait = texte_courant.info(:around_extract_length)

      # La liste qui va recevoir tous les mots
      arr_mots = Array.new

      curindex   = mot_avant.index - 1
      around_len = 0
      while curindex > -1 && around_len < longueur_autour_extrait
        arr_mots.unshift(texte_courant.mots[curindex].complet)
        around_len += texte_courant.mots[curindex].length + 1
        curindex -= 1
      end

      # On ajoute le mot-avant
      # Mais pour pouvoir le mettre en rouge, on doit mettre d'abord une
      # marque (sinon, la longueur pour le découpage serait mauvaise)
      motAvant = 'X' * (mot_avant.length + 1)
      arr_mots << motAvant
      curindex = 0 + mot_avant.index + 1

      # On ajoute tous les mots jusqu'au mot-après
      while curindex < mot_apres.index
        arr_mots << (texte_courant.mots[curindex].complet)
        curindex += 1
      end

      # On ajoute le mot après
      motApres = 'Z' * (mot_apres.length + 1)
      arr_mots << motApres
      curindex == mot_apres.index || raise('L’index du mot après devrait correspondre…')
      curindex += 1

      # On ajoute les mots jusqu'à la longueur voulue
      if curindex < texte_courant.nombre_total_mots
        around_len = 0
        begin
          # puts "curindex = #{curindex.inspect} (< #{texte_courant.nombre_total_mots})"
          arr_mots << texte_courant.mots[curindex].complet
          around_len += texte_courant.mots[curindex].length + 1
          curindex += 1
        end while  curindex < texte_courant.nombre_total_mots && around_len < longueur_autour_extrait
      end

      # Le texte final
      RET2 +
      arr_mots.join('')
        .segmente(LONGUEUR_SEGMENT, "\t\t")
        .sub(/#{motAvant}/, mot_avant.real_mot.rouge + mot_avant.disp_next_char)
        .sub(/#{motApres}/, mot_apres.real_mot.rouge + mot_apres.disp_next_char) +
      RET2

    else
      # Si on n'est pas en mode interactif
      "#{RETT}\t1. #{mot_avant.extrait}"+
      "#{RETT}\t2. #{mot_apres.extrait}"
    end
  end

end #/Proximity
