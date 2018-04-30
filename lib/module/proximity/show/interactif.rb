# encoding: UTF-8
=begin
  Méthodes gérant l'interactivité de la correction des proximités
=end
class Proximity
class << self

  # En mode interactif, on passe ici pour traiter la proximité
  #
  # On peut déterminer si la proximité est corrigée, s'il faut la supprimer,
  # on peut faire une proposition de mot que le programme va vérifier (pour voir
  # s'il ne crée par une nouvelle proximité), etc.
  def traite_proximite_mode_interactif iprox
    while true
      puts <<-EOT
      #{'o/oo'.jaune} = marquer cette proximité comme traitée/corrigée ('oo' pour confirmer directement)
      #{'p'.jaune} = essayer une proposition de mot (#{'pp[ <mot>]'.jaune} pour le premier mot, #{'ps[ <mot>]'.jaune} pour le second)
      #{'rp <mot>'.jaune} remplacer le premier mot (#{'rs <mot>'.jaune} pour le second) par <mot>
      #{'s/so'.jaune} = supprimer cette proximité de la liste (on pourra la revoir avec --all)
      #{'n'.jaune} = passer à la proximité suivante
      #{'z'.jaune} = arrêter les corrections.

      EOT

      print "Opération choisie : "
      debut_op = Time.now.to_f # utile pour compter le temps d'une correction
      c = STDIN.gets.strip_nil
      case c
      when NilClass, 'n'      then return
      when 'z'                then return true # POUR INTERROMPRE
      when /^(r[ps])(.*?)$/   then remplacer_mot_par_mot(iprox, $1 == 'rp', $2.strip)
      when 'p', /^p[ps]/      then proposer_et_tester_un_mot(iprox, c)
      when 'o', 'ok', 'oui', 'oo'
        # => marquer cette proximité traitée
        c == 'oo' || yesOrNo('Cette proximité a-t-elle vraiment été traitée ?') || return
        correction_proximite_confirmed(iprox, debut_op)
        return
      when 's', 'delete', 'supprimer', 'so'
        # => supprimer cette proximité après confirmation
        c == 'so' || begin
          yesOrNo('Dois-je vraiment supprimer cette proximité (i.e. ne plus en tenir compte) ?') || return
        end
        iprox.set_deleted
        self.changements_operes = true
        return
      else
        error "Le choix #{c} est invalide."
      end
    end
    return
  end
  # /traite_proximite_mode_interactif

  # Quand on confirme la proximité opérée.
  def correction_proximite_confirmed iprox, debut_op
    enregistre_duree_correction_proximite(debut_op, Time.now.to_f)
    iprox.set_treated
    self.changements_operes = true
  end


  # Permet de remplacer un mot du texte par un autre et tenant à jour toutes
  # les proximités, pour corrections futures
  def remplacer_mot_par_mot iprox, pour_premier, proposition
    load_module 'proximity/replace'
    if Proximity.replace(iprox, pour_premier, proposition)
      self.changements_operes = true
    end
  end

  # Pour pouvoir proposer un mot et checker pour voir s'il ne va pas créer
  # une nouvelle proximité
  #
  # @param {Proximity} iprox  La proximité courante
  #
  def proposer_et_tester_un_mot iprox, choix

    nouveau_mot   = nil
    pour_premier  = (choix == 'p' ? nil : (choix.start_with?('pp') ? true : false))

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
    else
      # Quand pour_premier est false ou true, c'est que 'pp' ou 'ps' ont été
      # fournis. Un mot a pu être ajouté
      choix = choix.split(' ')
      choix.shift # on retire 'pp' ou 'ps'
      choix.empty? || nouveau_mot = choix.join(' ')
    end

    # On demande le nouveau mot, sauf s'il a été fourni
    nouveau_mot || begin
      nouveau_mot = askFor(RET2+"Remplacer le #{pour_premier ? 'premier' : 'second'} mot par le mot")
      nouveau_mot || return
    end

    # On teste la validité du mot proposé, pour savoir s'il ne
    # rentre pas en conflit avec un autre mot du texte.
    puts "*** Test de la validité de la proposition : #{nouveau_mot.inspect}"

    # On peut avoir fourni plusieurs mots, il faudra tester chacun d'un.
    # Une autre solution est de suggérer les mots l'un après l'autre
    mots = nouveau_mot.strip.my_downcase.split(/[^[[:alnum:]]]/)

    # Le mot de référence en fonction du fait qu'on veut remplacer le premier
    # ou le second mot.
    imot_reference = iprox.send(pour_premier ? :mot_avant : :mot_apres)
    puts "  * Mot de référence à remplacer (#{pour_premier ? 'premier' : 'second'}) : #{imot_reference.mot}"
    offset_mot_ref = imot_reference.offset
    # puts "  * Offset : #{offset_mot_ref}"

    # On teste pour chaque mot en en faisant des instances
    mots.each do |mot|

      # puts "\t* Test validité de #{mot.inspect}"

      # On fait juste une instance pour obtenir le mot de base.
      imot_test = Texte::Mot.new(nil, mot, imot_reference.index, offset_mot_ref)

      mot_base = imot_test.mot_base
      # puts "\t* Son mot de base est : #{imot_test.mot_base}"

      ioccurences = Occurences[mot_base]
      if ioccurences
        # puts "\t= Une instance occurences de #{mot_base.inspect} existe."
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
            nombre_occurences = ioccurences.count
            puts "#{RET}\t= Ce mot peut être utilisé sans risque (à titre informatif, il est répété #{nombre_occurences} fois dans ce texte).#{RET2}".bleu
            next
          end
          # Ce mot est trop proche
          puts "#{RET2}\t# Le mot base #{mot_base.inspect} (utilisé #{nombre_occurences} fois dans ce texte) se trouve à "+"#{distance.abs} signes #{sens} le #{pour_premier ? 'premier' : 'second'} mot. Il est inutilisable.".rouge + "#{RET2}"
          return false
        end
      else
        puts "\t= Aucune occurence du mot base #{mot_base.inspect} n'existe dans ce texte, donc le mot est forcément bon.#{RET2}".bleu
        next
      end
    end
    # /loop sur chaque mot proposé

    return true
  end


end #/<< self
end #/Proximity
