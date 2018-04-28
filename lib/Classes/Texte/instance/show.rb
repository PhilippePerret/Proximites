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

      disp_mot  = imot.mot
      disp_mark = ' ' * imot.length
      color_avant = color_apres = nil

      if imot.prox_ids.nil?# || imot.mot != 'texte'
        # Aucune proximité
      else
        # Des proximités sont définies
        marka = nil
        markb = nil

        if imot.prox_ids[:apres]
          # <= Il y a un mot après en proximité
          # => On ajoute la marque vers la droite
          id_prox_apres = imot.prox_ids[:apres]
          # markb = "_#{id_prox_apres.to_s(36)}->"
          markb = "->"
          color_apres = next_color()
          # puts "color_apres : #{color_apres.inspect}"
          Proximity[id_prox_apres].color = color_apres
        end
        if imot.prox_ids[:avant]
          # <= Il y a un mot avant en proximité
          # => On ajoute la marque vers la gauche
          id_prox_avant = imot.prox_ids[:avant]
          # marka = "<-#{id_prox_avant.to_s(36)}_"
          marka = "<-"
          color_avant = Proximity[id_prox_avant].color
        end

        mot_len  = imot.length
        mark_len = "#{marka}#{markb}".length

        if mot_len == mark_len
          # rien à faire
        else
          if mot_len > mark_len
            # => Il faut allonger la marque
            if marka.nil?
              markb = markb.rjust(mot_len, '-')
            elsif markb.nil?
              marka = marka.ljust(mot_len, '-')
            else
              len_a = mot_len / 2
              marka = marka.ljust(len_a,'-')
              markb = markb.rjust(mot_len - len_a, '-')
            end
            # On pose les couleurs avant de compacter
          else
            # <= le mot est plus court que les deux marques
            # => Il faut allonger le mot affiché
            disp_mot  = imot.mot.ljust(mark_len)
          end
        end
        color_avant && marka && marka = marka.send(color_avant)
        color_apres && markb && markb = markb.send(color_apres)
        disp_mark = "#{marka}#{markb}"
      end

      self.longueur_segment += disp_mot.length

      if color_avant && color_apres
        disp_mot_len = disp_mot.length
        moitie = imot.length / 2
        av = imot.mot[0..(moitie-1)].send(color_avant)
        ap = imot.mot[moitie..-1].send(color_apres)
        disp_mot = "#{av}#{ap}".ljust(disp_mot_len)
      elsif color_avant
        disp_mot = disp_mot.send(color_avant)
      elsif color_apres
        disp_mot = disp_mot.send(color_apres)
      end

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
