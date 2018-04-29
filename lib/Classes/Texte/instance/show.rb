# encoding: UTF-8
class Texte

  MAX_LEN_LINE = 80

  attr_accessor :segment_up, :segment_do, :longueur_segment

  COLORS    = [:rouge, :fond1, :vert, :fond2, :mauve, :fond3, :jaune, :fond4, :bleu, :fond5, :gris]
  NOMBRE_COLORS = COLORS.count
  def next_color
    @icolor ||= -1
    @icolor += 1
    @icolor < NOMBRE_COLORS || @icolor = 0
    COLORS[@icolor]
  end

  # Méthode principale répondant à la commande `proximite show texte` pour
  # afficher le texte avec les proximités
  #
  # Les options --from_page, --to_page, --from et/ou -to permettent de
  # définir une portion de texte particulière.
  def show

    init_line_up_and_down

    # Faut-il réduire le segment à afficher à une certaine longueur ?
    start_offset =
      if CLI.options[:from_page]
        CLI.options[:from_page].to_i * LONGUEUR_PAGE
      elsif CLI.options[:from]
        CLI.options[:from].to_i
      else
        0
      end

    end_offset =
      if CLI.options[:to_page]
        CLI.options[:to_page].to_i * LONGUEUR_PAGE
      elsif CLI.options[:to]
        CLI.options[:to].to_i
      else
        nil
      end

    puts RET3

    self.mots.each do |imot|

      if imot.offset < start_offset
        next
      elsif end_offset && imot.offset > end_offset
        break
      end

      arr_mots    = Array.new
      arr_colors  = Array.new

      imot.length > 0 || begin
        next
      end

      # puts "Mot traité : #{imot.mot}:#{imot.offset}"

      disp_mark = ' ' * imot.length
      color_avant = color_apres = nil

      # Pour savoir s'il faut traiter ce mot.
      # Le mot doit être traité si :
      #   * Il est en proximité avec un autre mot
      #   * Cette proximité n'a été ni supprimée ni corrigée.
      dont_treate = false
      has_proximities = imot.prox_ids != nil
      if has_proximities
        id_prox_avant = imot.prox_ids[:avant]
        id_prox_avant && begin
          iprox_avant = Proximity[id_prox_avant]
          treate_prox_avant = !(iprox_avant.treated? || iprox_avant.deleted?)
          dont_treate = !treate_prox_avant
        end
        id_prox_apres = imot.prox_ids[:apres]
        id_prox_apres && begin
          iprox_apres = Proximity[id_prox_apres]
          treate_prox_apres = !(iprox_apres.treated? || iprox_apres.deleted?)
          dont_treate = dont_treate || !treate_prox_apres
        end
      else
        dont_treate = true
      end


      # On traite véritablement
      if dont_treate
        # Aucune proximité
        arr_mots << imot.mot
      else
        # Des proximités sont définies
        marka = nil
        markb = nil

        if id_prox_avant && treate_prox_avant
          # <= Il y a un mot avant en proximité
          # => On ajoute la marque vers la gauche
          marka = "<-".ljust(imot.length,'-')
          color_avant = iprox_avant.color

          arr_mots    << imot.mot
          arr_colors  << color_avant

        end

        if id_prox_apres && treate_prox_apres
          # <= Il y a un mot après en proximité
          # => On ajoute la marque vers la droite
          # markb = "_#{id_prox_apres.to_s(36)}->"
          markb = "->".rjust(imot.length,'-')
          color_apres = next_color()
          iprox_apres.color = color_apres

          arr_mots    << imot.mot
          arr_colors  << color_apres

        end

        mot_len   = arr_mots.join('|').length
        marks     = [marka, markb].compact.join('|')
        mark_len  = "#{marks}".length

        color_avant && marka && marka = marka.send(color_avant)
        color_apres && markb && markb = markb.send(color_apres)
        disp_mark = "#{[marka, markb].compact.join('|')}"
      end

      self.longueur_segment += arr_mots.join('|').length

      # On ajoute la couleur aux mots qui en ont besoin
      arr_colors.each_with_index do |meth_color, index|
        # Il peut arriver, lorsque l'on ne prend qu'une portion du texte,
        # qu'un couleur ne soit pas définie. Il faut donc traiter la couleur
        # seulement lorsqu'elle est vraiment définie.
        meth_color || next
        arr_mots[index] = arr_mots[index].send(meth_color)
      end

      disp_mot = arr_mots.join('|')

      segment_up << disp_mot  + ' '
      segment_do << disp_mark + ' '

      if self.longueur_segment > MAX_LEN_LINE
        ecrire_lignes_up_and_down
      end

    end
    #/Fin boucle sur chaque proximité

    ecrire_lignes_up_and_down
    puts RET3
  end
  # /Texte#show

  # Méthode pour écrire dans le fichier ou en console les lignes de
  # suivi de proximité.
  # On indique en début de ligne la longueur de la ligne.
  # On initialise les lignes ensuite.
  def ecrire_lignes_up_and_down
    puts "\t#{segment_up}"
    puts "\t#{segment_do}"
    puts "\n"
    init_line_up_and_down
  end


  def init_line_up_and_down
    self.segment_up = String.new
    self.segment_do = String.new
    self.longueur_segment = 0
  end


end #/Texte
