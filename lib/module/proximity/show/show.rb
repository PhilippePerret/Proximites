# encoding: UTF-8
class Proximity
class << self

  # Méthode principale appelée quand on fait `prox show proximites [path]`
  #
  # C'est la méthode qui permet dans tous les cas de corriger les proximités
  # soit en les regardant dans une liste affichée à l'écran, soit proximité
  # par proximité, avec une aide interactive.
  #
  # On procède en deux temps :
  #   * on relève la liste des proximités à afficher (sauf si --all)
  #   * on affiche les proximités (de façon interactive si nécessaire)
  #
  # Si +mot+ est défini, on affiche seulement les proximités de ce mot.
  # Ça peut être aussi l'identifiant de la proximité.
  #
  def _show mot = nil
    Tests::Log << "-> Proximity::_show(mot = #{mot.inspect})"

    mode_interactif = CLI.options[:interactif]
    quick_mode      = CLI.options[:quick_mode]
    show_all        = !!CLI.options[:all]

    if mot.nil?
      liste_proximites = table.values
      # Tests::Log << "liste_proximites = #{liste_proximites.inspect}"
    elsif mot.is_a?(Integer)
      Proximity[mot] || raise('La proximité d’identifiant #%i n’existe pas.' % [mot])
      liste_proximites = [Proximity[mot]]
      mot = liste_proximites.first.mot_avant.mot
    else
      if Occurences[mot] && !Occurences[mot].proximites.empty?
        # C'est bien un mot qui a pas des proximité
        liste_proximites = Occurences[mot].proximites.collect { |prox_id| Proximity[prox_id] }
      elsif Occurences[mot]
        notice "Le mot #{mot.inspect} existe bien, mais il ne possède aucune proximité."
        return
      else
        error "Le mot #{mot.inspect} n’existe pas dans ce texte."
        return
      end
    end

    mark_nombres_header = Array.new
    mark_nombres_footer = Array.new
    len_libelle_footer  = 26

    # Le nombre total
    nbtotal = liste_proximites.count
    Tests::Log << "Nombre de proximités : #{nbtotal}"
    mark_nombres_header << "total : #{nbtotal}"
    mark_nombres_footer << "#{'Nombre total de proximités'.ljust(len_libelle_footer)} : #{nbtotal}"

    # Ne prendre que les proximités qui n'ont pas été marquées traitées ou
    # supprimées (sauf si options --all, traitée dans displayable? et sauf si
    # on est en mode rapide et qu'on présente les non displayable et les
    # traitées dans ce mode.
    if quick_mode
      # <= mode rapide
      # => on ne prend pas les proximités déjà traitées
      liste_proximites  = liste_proximites.select{ |prox| prox.displayable? && !prox.treated_in_quick_mode? }
    else
      # <= mode normal
      liste_proximites  = liste_proximites.select{ |prox| prox.displayable? }
    end

    # Nombre proximités à traiter
    nombre_proximites = liste_proximites.count

    CLI.options[:all] || begin
      mark_nombres_header << "non traitées : #{nombre_proximites}"
    end

    CLI.options[:only] && begin
      jusque = CLI.options[:only].to_i - 1
      liste_proximites = liste_proximites[0..jusque]
      nombre_affichees = liste_proximites.count
      mark_nombres_header << "affichées : #{nombre_affichees}"
      mark_nombres_footer << "#{'Proximités affichées'.ljust(len_libelle_footer)} : #{nombre_affichees}"
    end

    # Estimation de la durée pour faire les corrections
    duree_corrections = estimation_duree_corrections(nombre_proximites)

    mark_nombres_header = mark_nombres_header.join(' / ')

    mode_interactif || mark_nombres_footer << "\n\t(ajouter l’option `-i` pour passer en mode interactif)"


    ajoutmot = mot.nil? ? '' : " DU MOT #{mot.upcase.inspect}"
    entete = "=== AFFICHAGE DES PROXIMITÉS#{ajoutmot} (#{mark_nombres_header}) ==="
    estimation = "  = DURÉE CORRECTION ESTIMÉE : #{duree_corrections} (#{texte.info(:duree_moy_correction_prox)} secs par correction)"
    puts "#{RET3}#{entete}#{RET2}#{estimation}#{RET3}"

    # Façon de traiter la proximité :
    #   * soit on l'affiche simplement (à la suite les 1 des autres)
    #   * soit de façon interactive, l'1 après l'autre
    #
    proced =
      if mode_interactif
        if quick_mode
          # <= Mode rapide
          # => Régler les touches de façon adéquate
          Proc.new do |prox, numero|
            puts Tests.delimiteur_tableau
            puts RET2 + prox.as_block(numero, nombre_proximites) + RET2
            touche = traite_proximite_mode_interactif_quick_mode(prox)
            case touche
            when :save_and_quit
              texte_courant.save_all
              nil
            when :quit      then

              nil
            when :previous  then numero - 2  # => index_prox -= 1
            when :next      then numero      # => index_prox += 1
            else nil # pour sortir
            end
          end #/Proc.new
        else
          # <= Mode normal
          # => Régler les touches
          Proc.new do |prox, numero|
            prox.nil? && begin
              puts "La proximité numéro #{numero} n'a pas pu être traitée, elle est nulle."
              next
            end
            prox.displayable? || next
            puts Tests.delimiteur_tableau
            puts RET2 + prox.as_block(numero, nombre_proximites) + RET2
            traite_proximite_mode_interactif(prox) && break
          end
        end
      else
        Proc.new do |prox, numero|
          prox.nil? && next
          prox.displayable? || next
          puts prox.as_block(numero, nombre_proximites)
        end
      end

    # En mode interactif, on affiche les proximités dans l'ordre d'apparition
    # dans le texte plutôt que par groupe d'occurences. Il faut donc classer
    # la liste finale.
    if mode_interactif
      liste_proximites = liste_proximites.sort_by{|prox| prox.mot_avant.offset}
    end

    # =========================================================
    # On boucle sur chaque proximité à afficher

    # Pour comptabiliser les proximités traitées, afin d'indiquer un
    # nombre juste en footer
    nombre_proximites_treated = 0

    if quick_mode
      index_prox = 0
      while iprox = liste_proximites[index_prox]
        nombre_proximites_treated += 1
        # puts "*** Traitement de iprox #{iprox.id}"
        index_prox = proced.call(iprox, 1 + index_prox)
        # puts "#{RET}index_prox = #{index_prox.inspect}".jaune
        index_prox || begin
          # puts "index_prox est nil, j'arrête"
          break
        end
      end
    else
      # <= Mode normal
      liste_proximites.each_with_index do |prox, index_prox|
        nombre_proximites_treated += 1
        proced.call(iprox, 1 + index_prox)
      end
    end
    puts Tests.delimiteur_tableau

    # =========================================================

    # FIN DU TRAVAIL
    # ==============

    # FOOTER
    # ======
    CLI.options[:all] || begin
      mark_nombres_footer << "#{'Proximités non traitées'.ljust(len_libelle_footer)} : #{nombre_proximites - nombre_proximites_treated} (#{nombre_proximites} - #{nombre_proximites_treated})"
    end
    duree_corrections = estimation_duree_corrections(nombre_proximites)
    mark_nombres_footer << "#{'Durée corrections estimée'.ljust(len_libelle_footer)} : #{duree_corrections}"
    mark_nombres_footer << "#{'Durée d’une correction'.ljust(len_libelle_footer)} : #{texte.info(:duree_moy_correction_prox).round(2)} secs"
    puts RET2
    puts "\t" + mark_nombres_footer.join("\n\t")
    puts RET3

    # Si des modifications ont été opérées, on doit enregistrer toutes les
    # informations.
    if !quick_mode && mode_interactif && changements_operes
      yesOrNo('Faut-il enregistrer les changements opérés ?') || begin
        yesOrNo(RET+'Êtes-vous sûr de ne pas vouloir enregistrer les changements ? Ils seront perdus'.rouge) && begin
          puts RET+'Les modifications ne sont pas enregistrées.'
          return
        end
      end
      puts ''
      texte_courant.save_all
    end
    Tests::Log << '<- Proximity::_show'
  end
  # /_show


  # Enregistre la nouvelle durée de correction en calculant la
  # moyenne.
  def enregistre_duree_correction_proximite(debut_op, fin_op)
    duree_op  = fin_op - debut_op

    nbcorprox = texte.info(:nombre_corrections_prox) || 0
    duree_moy = texte.info(:duree_moy_correction_prox)

    duree_moy =
      if nbcorprox > 0
        ((duree_moy.to_f * nbcorprox) + duree_op).to_f / (nbcorprox + 1).round(2)
      else
        duree_op.round(2)
      end

    texte.set_info({
      nombre_corrections_prox:    nbcorprox + 1,
      duree_moy_correction_prox:  duree_moy
      })
  end

end #/<< self
end #/Proximity
