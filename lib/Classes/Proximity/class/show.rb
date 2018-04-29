# encoding: UTF-8
class Proximity

  # Retourne TRUE si la proximité doit être affichée
  def displayable?
    CLI.options[:all] || (!treated? && !deleted?)
  end

class << self

  # Mis à true lorsque des changements ont été opérés sur les données des
  # proximités (par exemple pour les marquer traitées ou supprimées) et qu'il
  # faudrait donc les enregistrer.
  attr_accessor :changements_operes

  # Méthode affichant une proximité par son Identifiant
  def show_proximite_by_id prox_id
    show(prox_id.to_i)
  end

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
  def show mot = nil
    mode_interactif = CLI.options[:interactif]
    show_all        = !!CLI.options[:all]


    if mot.nil?
      liste_proximites = table.values
    elsif mot.is_a?(Fixnum)
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
    mark_nombres_header << "total : #{nbtotal}"
    mark_nombres_footer << "#{'Nombre total de proximités'.ljust(len_libelle_footer)} : #{nbtotal}"

    # Ne prendre que les proximités qui n'ont pas été marquées traitées ou
    # supprimées (sauf si options --all, traitée dans displayable?)
    liste_proximites  = liste_proximites.select{ |prox| prox.displayable? }
    nombre_proximites = liste_proximites.count

    CLI.options[:all] || begin
      mark_nombres_header << "non traitées : #{nombre_proximites}"
      mark_nombres_footer << "#{'Proximités non traitées'.ljust(len_libelle_footer)} : #{nombre_proximites}"
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
    mark_nombres_footer << "#{'Durée corrections estimée'.ljust(len_libelle_footer)} : #{duree_corrections}"
    mark_nombres_header  << "durée : #{duree_corrections}"

    mark_nombres_header = mark_nombres_header.join(' / ')

    mode_interactif || mark_nombres_footer << "\n\t(ajouter l’option `-i` pour passer en mode interactif)"


    ajoutmot = mot.nil? ? '' : " DU MOT #{mot.upcase.inspect}"
    entete = "=== AFFICHAGE DES PROXIMITÉS#{ajoutmot} (#{mark_nombres_header}) ==="
    puts "#{RET3}#{entete}#{RET3}"

    # Façon de traiter la proximité :
    #   * soit on l'affiche simplement (à la suite les 1 des autres)
    #   * soit de façon interactive, l'1 après l'autre
    #
    proced =
      if mode_interactif
        Proc.new do |prox, numero|
          prox.displayable? || next
          puts RET2 + prox.as_block(numero, nombre_proximites) + RET2
          traite_proximite_mode_interactif(prox) && break
        end
      else
        Proc.new do |prox, numero|
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
    liste_proximites.each_with_index do |prox, index_prox|
      proced.call(prox, 1 + index_prox)
    end
    puts RET2
    puts "\t" + mark_nombres_footer.join("\n\t")
    puts RET3
    # =========================================================

    if mode_interactif && changements_operes
      yesOrNo("Faut-il enregistrer les changements opérés ?") && save
    end
  end

  def estimation_duree_corrections nombre_corrections
    duree_moyenne = texte.info(:duree_moy_correction_prox)
    duree_moyenne || (return '- - -')
    (duree_moyenne * nombre_corrections).to_i.as_workdays
  end

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

  # En mode interactif, on passe ici pour traiter la proximité
  #
  # On peut déterminer si la proximité est corrigée, s'il faut la supprimer,
  # on peut faire une proposition de mot que le programme va vérifier (pour voir
  # s'il ne crée par une nouvelle proximité), etc.
  def traite_proximite_mode_interactif iprox
    while true
      puts <<-EOT
      #{'o'.jaune} = marquer cette proximité comme traitée/corrigée"
      #{'p'.jaune} = essayer une proposition de mot (#{'pp'.jaune} pour le premier mot, #{'ps'.jaune} pour le second)
      #{'s'.jaune} = supprimer cette proximité de la liste (on pourra la revoir avec --all)
      #{'n'.jaune} = passer à la proximité suivante
      #{'z'.jaune} = arrêter les corrections.

      EOT

      print "Opération choisie : "
      debut_op = Time.now.to_f # utile pour compter le temps d'une correction
      c = STDIN.gets.strip_nil
      case c
      when NilClass, 'n' then return false # pour poursuivre
      when 'z'              then return true
      when 'p', 'pp', 'ps'  then proposer_et_tester_un_mot(iprox, (c == 'p' ? nil : (c == 'pp' ? true : false)))
      when 'o', 'ok', 'oui'
        # => marquer cette proximité traitée
        yesOrNo('Cette proximité a-t-elle vraiment été traitée ?') && begin
          enregistre_duree_correction_proximite(debut_op, Time.now.to_f)
          iprox.set_treated
          self.changements_operes = true
        end
        return false # pour ne pas interrompre
      when 's', 'delete', 'supprimer'
        # => supprimer cette proximité après confirmation
        yesOrNo('Dois-je vraiment supprimer cette proximité (ne plus en tenir compte) ?') && begin
          iprox.set_deleted
          self.changements_operes = true
        end
        return false # pour ne pas interrompre
      else
        error "Le choix #{c} est invalide."
      end
    end
    return false
  end
  # /traite_proximite_mode_interactif

  # Pour pouvoir proposer un mot et checker pour voir s'il ne va pas créer
  # une nouvelle proximité
  #
  # @param {Proximity} iprox  La proximité courante
  #
  def proposer_et_tester_un_mot iprox, pour_premier
    if pour_premier === nil
      rep = askFor(RET2+'Est-ce une proposition pour le premier mot ? (premier: o, p ou 1, second: n, s, 2)')
      pour_premier =
        case rep
        when 'o', 'p', '1' then true
        when 'n', 's', '2' then false
        else
          error "Je ne comprends pas ce choix."
          return
        end
    end
    nouveau_mot  = askFor(RET2+"Remplacer le #{pour_premier ? 'premier' : 'second'} mot par le mot")
    nouveau_mot || return
    puts "= Test de la validité du mot #{nouveau_mot.inspect} ="
    # On peut avoir fourni plusieurs mots,
    mots = nouveau_mot.strip.my_downcase.split(/[^[[:alnum:]]]/)
    # Le mot de référence en fonction du fait qu'on veut remplacer le premier
    # ou le second mot.
    imot_reference = iprox.send(pour_premier ? :mot_avant : :mot_apres)
    offset_mot_ref = imot_reference.offset
    # On teste pour chaque mot en en faisant des instances
    mots.each do |mot|
      # On fait juste une instance pour obtenir le mot de base.
      imot_test = Texte::Mot.new(nil, mot, imot_reference.index, offset_mot_ref)
      mot_base = imot_test.mot_base
      ioccurences = Occurences[mot_base]
      if ioccurences
        puts "\tUne instance occurences de #{mot_base.inspect} existe."
        nombre_occurences = ioccurences.count
        distance_min = ioccurences.distance_min
        # On passe en revue chaque offset des occurences pour voir s'il y en
        # a une à une distance inférieure de la distance min
        ioccurences.offsets.each do |offset|
          distance = offset - offset_mot_ref
          trop_proche = distance.abs <= distance_min
          # puts "distance : #{distance} (min : #{distance_min})"
          if distance < 0 && trop_proche
            # Trop proche d'un mot avant
            sens = "avant"
          elsif distance > 0 && trop_proche
            # Trop proche d'un mot après
            sens = "après"
          elsif distance > distance_min
            # On est trop loin, on peut s'arrêter là
            puts "#{RET2}\tCe mot peut être utilisé sans risque (à titre informatif, il est répété #{nombre_occurences} fois dans ce texte).#{RET2}".bleu
            return
          end
          # Ce mot est trop proche
          puts "#{RET2}\tCe mot #{mot_base.inspect} (utilisé #{nombre_occurences} fois dans ce texte) se trouve à "+"#{distance.abs} signes #{sens} le #{pour_premier ? 'premier' : 'second'} mot".rouge + ". Il est inutilisable.#{RET2}"
          return false
        end
      else
        puts "\tAucune occurence de #{mot_base.inspect} n'existe dans ce texte, donc le mot est forcément bon.#{RET2}".bleu
        return true
      end
    end
    # /loop sur chaque mot proposé
    return true
  end

end #/<< self
end #/Proximity
