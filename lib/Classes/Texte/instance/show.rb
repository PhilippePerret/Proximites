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
  def show

    init_line_up_and_down

    puts RET3

    self.mots.each do |imot|

      arr_mots    = Array.new
      arr_colors  = Array.new

      disp_mark = ' ' * imot.length
      color_avant = color_apres = nil

      if imot.prox_ids.nil?# || imot.mot != 'texte'
        # Aucune proximité
        arr_mots << imot.mot
      else
        # Des proximités sont définies
        marka = nil
        markb = nil


        if imot.prox_ids[:avant]
          # <= Il y a un mot avant en proximité
          # => On ajoute la marque vers la gauche
          id_prox_avant = imot.prox_ids[:avant]
          marka = "<-".ljust(imot.length,'-')
          color_avant = Proximity[id_prox_avant].color

          arr_mots    << imot.mot
          arr_colors  << color_avant

        end

        if imot.prox_ids[:apres]
          # <= Il y a un mot après en proximité
          # => On ajoute la marque vers la droite
          id_prox_apres = imot.prox_ids[:apres]
          # markb = "_#{id_prox_apres.to_s(36)}->"
          markb = "->".rjust(imot.length,'-')
          color_apres = next_color()
          Proximity[id_prox_apres].color = color_apres

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
