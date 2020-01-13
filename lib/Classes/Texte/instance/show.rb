# encoding: UTF-8
class Texte

  MAX_LEN_LINE = 80

  class << self
    def colors
      @colors ||= begin
        if CLI.options[:output]
          [:rouge_html, :fond1_html, :vert_html, :fond2_html, :mauve_html, :fond3_html, :jaune_html, :fond4_html, :bleu_html, :fond5_html, :gris_html]
        else
          [:rouge, :fond1, :vert, :fond2, :mauve, :fond3, :jaune, :fond4, :bleu, :fond5, :gris]
        end
      end
    end
    def nombre_colors
      @nombre_colors ||= colors.count
    end
  end

  attr_accessor :segment_up, :segment_do, :longueur_segment


  def next_color
    @icolor ||= -1
    @icolor += 1
    @icolor < self.class.nombre_colors || @icolor = 0
    self.class.colors[@icolor]
  end


  # Méthode principale répondant à la commande `proximite show texte` pour
  # afficher le texte avec les proximités
  #
  # Les options --from_page, --to_page, --from et/ou -to permettent de
  # définir une portion de texte particulière.
  def show

    init_line_up_and_down

    # Pour boucler lorsque l'option --per_page est choisie et qu'on affiche
    # le texte page après page.
    while true

      # Faut-il réduire le segment à afficher à une certaine longueur ?
      start_offset = options_start_offset
      end_offset = options_end_offset(start_offset)

      puts RET3
      # En mode page en page, on indique la page au-dessus et en dessous
      CLI.options[:per_page] && begin
        mark_page = "PAGE #{(start_offset/Texte::longueur_page) + 1}/#{nombre_pages}"
        puts "\t#{'-'*40} #{mark_page} #{'-'*40}#{RET2}"
      end

      self.mots.each do |imot|

        # D E B U G
        # puts "imot traité : mot:#{imot.mot.inspect}, index:#{imot.index}, offset:#{imot.offset.inspect}, length:#{imot.length.inspect}"

        # Jusqu'à ce que l'on commence ou qu'on termine
        if imot.offset < start_offset
          next
        elsif end_offset && imot.offset > end_offset
          break
        end

        arr_mots    = Array.new
        arr_colors  = Array.new

        # Si le texte est vide, on peut quand même avec un caractère suivant
        # à écrire.
        imot.length > 0 || begin
          segment_up << imot.next_char
          segment_do << ' '
          self.longueur_segment += 1
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
        has_proximities = imot.prox_ids!= nil && (imot.prox_ids[:avant]!=nil||imot.prox_ids[:apres]!=nil)
        # puts "has_proximities = #{has_proximities.inspect}"
        if has_proximities
          id_prox_avant = imot.prox_ids[:avant]
          id_prox_avant && begin
            # puts "proximité avant"
            iprox_avant = Proximity[id_prox_avant]
            treate_prox_avant = !(iprox_avant.treated? || iprox_avant.deleted?)
            dont_treate = !treate_prox_avant
          end
          id_prox_apres = imot.prox_ids[:apres]
          id_prox_apres && begin
            # puts "proximité après"
            iprox_apres = Proximity[id_prox_apres]
            iprox_apres || begin
              raise('Les proximités sont mal définies pour :' +
              "#{RETT}id_prox_apres : #{id_prox_apres}" +
              "#{RETT}imot.index : #{imot.index}" +
              "#{RETT}imot.mot : #{imot.mot}" +
              "#{RETT}imot.prox_ids : #{imot.prox_ids.inspect}"
              )
            end
            treate_prox_apres = !(iprox_apres.treated? || iprox_apres.deleted?)
            dont_treate = dont_treate || !treate_prox_apres
          end
        else
          dont_treate = true
        end


        # On traite véritablement
        if dont_treate
          # Aucune proximité
          arr_mots << imot.real_mot
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

            # Attention, ça peut être un deuxième ajout du mot, s'il est
            # en proximité avant et après.
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

        imot.next_char || begin
          puts "imot: #{imot.real_mot}"
          puts "disp_mot: #{disp_mot}"
          puts "imot.next_char : #{imot.next_char.inspect}"
        end
        segment_up << (disp_mot + imot.next_char)
        segment_do << disp_mark + ' '

        if self.longueur_segment > MAX_LEN_LINE
          ecrire_lignes_up_and_down
        end

      end
      #/Fin boucle sur chaque proximité

      ecrire_lignes_up_and_down

      # En mode page en page, on indique la page au-dessus et en dessous
      if CLI.options[:per_page]
        puts "#{RET2}\t#{'-'*40} #{mark_page} #{'-'*40}#{RET2}"
        case askFor('Page suivante ? (ENTER/o = oui, z/n = non, p = précédente, numéro de page)')
        when NilClass, '', 'o', 'oui'
          CLI.options[:from] += Texte::longueur_page
        when 'p', 'previous'
          CLI.options[:from] -= Texte::longueur_page
          CLI.options[:from] > -1 || begin
            CLI.options[:from] = 0
            "Il n'y a pas de page avant…".rouge_gras
          end
        when /^([0-9]+)$/
          CLI.options[:from] = ($1.to_i - 1) * Texte::longueur_page
        else break
        end
      else
        puts RET3
        break
      end

    end #/boucle si on doit présenter plusieurs pages interactivement

    # Si c'est un export vers un fichier, il faut le finaliser
    if CLI.options[:output]
      finaliseOuputHtml
    end

  end
  # /Texte#show

  # Retourne le décalage du début de texte voulu, si on ne veut pas tout
  # le texte (options --from ou --from_page)
  def options_start_offset
    if CLI.options[:per_page]
      (CLI.options[:from] ||= 1).to_i - 1
    elsif CLI.options[:from_page]
      CLI.options[:from_page].to_i > 0 || CLI.options[:from_page] = 1
      (CLI.options[:from_page].to_i - 1) * Texte::longueur_page
    elsif CLI.options[:from]
      CLI.options[:from].to_i > 0 || CLI.options[:from] = 1
      CLI.options[:from].to_i - 1
    else
      0
    end
  end

  # Retourne le décalage de la fin de portion de texte voulu, si on ne veut
  # pas tout le texte (options --to ou --to_page)
  def options_end_offset start_offset
    if CLI.options[:per_page]
      start_offset + Texte::longueur_page - 1
    elsif CLI.options[:to_page]
      CLI.options[:to_page].to_i * Texte::longueur_page
    elsif CLI.options[:to]
      CLI.options[:to].to_i > start_offset || CLI.options[:to] = (start_offset + 100)
      CLI.options[:to].to_i - 1
    else
      nil
    end
  end


  # Méthode pour écrire dans le fichier ou en console les lignes de
  # suivi de proximité.
  # On indique en début de ligne la longueur de la ligne.
  # On initialise les lignes ensuite.
  def ecrire_lignes_up_and_down
    if CLI.options[:output]
      refHtmlFile.puts(segment_up.gsub(/\n/,'¶'))
      refHtmlFile.puts(segment_do.gsub(/\n/,'¶'))
    else
      puts "\t#{segment_up.gsub(/\n/,'¶')}"
      puts "\t#{segment_do.gsub(/\n/,'¶')}"
      puts "\n"
    end
    init_line_up_and_down
  end

  # Référence au fichier HTML qui reçoit les lignes colorisées, pour
  # export des proximités
  def refHtmlFile
    @refHtmlFile ||= File.open(outputHtmlPath,'a')
  end
  # Path du fichier provisoire qui reçoit le code HTML des lignes qui
  # montre les proximités colorisées
  def outputHtmlPath
    @outputHtmlPath ||= './output.html'
  end
  # Path au fichier HTML final qui contient la liste des proximités colorisées
  def finalOutputHtmlPath
    @finalOutputHtmlPath ||= File.join(Prox.folder_texte,"#{Prox.affixe}-proximites.html")
  end
  # Finalisation du fichier HTML contenant les proximités
  def finaliseOuputHtml
    refHtmlFile.close
    code = File.read(outputHtmlPath).force_encoding('utf-8')
    code = <<-HTML
<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>PROXIMITÉS</title>
  </head>
  <body>
    <pre><code>
#{code}
    </code></pre>
  </body>
</html>
    HTML

    File.open(finalOutputHtmlPath, 'wb'){|f| f.write(code)}
    File.unlink(outputHtmlPath) if File.exists?(finalOutputHtmlPath)
    puts "Le fichier HTML montrant toutes les proximités a été produit.\nIl se trouve dans le fichier '#{File.basename(finalOutputHtmlPath)}',\ndans le dossier contenant le texte (*).\n(*) #{Prox.folder_texte}".vert
    `open -a Finder "#{Prox.folder_texte}"`
  end


  def init_line_up_and_down
    self.segment_up = String.new
    self.segment_do = String.new
    self.longueur_segment = 0
  end


end #/Texte
