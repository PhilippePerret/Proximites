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

  # Méthode principale appelée quand on fait `prox show proximites [path]`
  #
  # On procède en deux temps :
  #   * on relève la liste des proximités à afficher (sauf si --all)
  #   * on affiche les proximités (de façon interactive si nécessaire)
  #
  # Si +mot+ est défini, on affiche seulement les proximités de ce mot.
  #
  def show mot = nil
    mode_interactif = CLI.options[:interactif]
    show_all        = !!CLI.options[:all]


    if mot.nil?
      liste_proximites = table.values
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

    mark_nombres_header = mark_nombres_header.join(' / ')

    ajoutmot = mot.nil? ? '' : " DU MOT #{mot.upcase.inspect}"
    entete = "=== AFFICHAGE DES PROXIMITÉS#{ajoutmot} (#{mark_nombres_header}) ==="
    puts "#{RET3}#{entete}#{RET3}"

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

  # TODO : implémenter
  def temps_moyen_correction_proximite

  end
  # TODO : implémenter
  def display_temps_correction_prevu

  end


  def traite_proximite_mode_interactif iprox
    while true
      print "Opération (n=suivante, o=marquer traitée, s=supprimer, z=tout arrêter) : "
      debut_op = Time.now.to_f # utile pour compter le temps d'une correction
      c = STDIN.gets.strip_nil
      case c
      when NilClass, 'n' then return false # pour poursuivre
      when 'z'     then return true
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
end #/<< self
end #/Proximity
