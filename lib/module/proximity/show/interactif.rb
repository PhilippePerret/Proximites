# encoding: UTF-8
=begin
  Méthodes gérant l'interactivité de la correction des proximités
=end
class Proximity

  PANNEAU_AIDE_REPONSES = <<-EOT
  #{'o/oo'.jaune} = marquer cette proximité comme traitée/corrigée ('oo' pour confirmer directement)
  #{'p'.jaune} = essayer une proposition de mot (#{'pp[ <mot>]'.jaune} pour le premier mot, #{'ps[ <mot>]'.jaune} pour le second)
  #{'rp <mot>'.jaune} remplacer le premier mot (#{'rs <mot>'.jaune} pour le second) par <mot>
  #{'po/s/so'.jaune} = supprimer cette proximité de la liste (on pourra la revoir avec --all)
  #{'n'.jaune} = passer à la proximité suivante
  #{'z'.jaune} = arrêter les corrections.

  EOT

  MESSAGES = {
    'aide-reponses'   => PANNEAU_AIDE_REPONSES.freeze,
    'confirm-treated' => 'Cette proximité a-t-elle vraiment été traitée ?'.bleu,
    'confirm-deleted' => 'Dois-je vraiment supprimer cette proximité (i.e. ne plus en tenir compte) ?'.bleu
  }

class << self

  # En mode interactif, on passe ici pour traiter la proximité
  #
  # On peut déterminer si la proximité est corrigée, s'il faut la supprimer,
  # on peut faire une proposition de mot que le programme va vérifier (pour voir
  # s'il ne crée par une nouvelle proximité), etc.
  def traite_proximite_mode_interactif iprox
    Tests::Log << "-> Proximity::traite_proximite_mode_interactif(iprox.id=#{iprox.id}/iprox.object_id:#{iprox.object_id})"

    iprox_id = iprox.id
    Tests::Log << 'Contrôle d’instance (proximity) dans traite_proximite_mode_interactif'+RETT+
    "Contrôle de la proximité ##{iprox_id}"+RETT+
    "Proximité en argument    : #{iprox.object_id}"+RETT+
    "Proximité dans Proximity : #{Proximity[iprox_id].object_id}"+RETTT+
      "Mot avant dans prox argument : #{iprox.mot_avant.object_id}"+RETTT+
      "          dans Texte.mots    : #{Texte.current.mots[iprox.mot_avant.index].object_id}"+RETTT

    iprox.mot_avant.object_id == Texte.current.mots[iprox.mot_avant.index].object_id || begin
      raise 'Problème d’instance (mot_avant de la proximité envoyée à traite_proximite_mode_interactif) et mot_avant dans Proximity'+RET+
      '(noter que l’instance Proximity, elle, est correcte)'
    end

    while true

      puts Tests.delimiteur_tableau # Pour les tests
      puts MESSAGES['aide-reponses']

      # Début de l'opération (pour savoir combien de temps l'opération prendra)
      debut_op = Time.now.to_f # utile pour compter le temps d'une correction
      c = askFor('Opération choisie'.bleu)
      case c
      when NilClass, 'n'      then return
      when 'z'                then return true # POUR INTERROMPRE
      when /^(r[ps])(.*?)$/   then remplacer_mot_par_mot(iprox, $1 == 'rp', $2.strip)
      when 'p', /^p[ps]/      then proposer_et_tester_un_mot(iprox, c)
      when 'o', 'ok', 'oui', 'oo'
        # => marquer cette proximité traitée
        c == 'oo' || yesOrNo(MESSAGES['confirm-treated']) || return
        correction_proximite_confirmed(iprox, debut_op)
        return
      when 's', 'delete', 'supprimer', 'so', 'po'
        # => supprimer cette proximité après confirmation
        c == 'so' || c == 'po' || yesOrNo(MESSAGES['confirm-deleted']) || return
        suppression_proximite_confirmed iprox, debut_op
        return
      else
        error "Le choix #{c} est invalide."
      end
    end
    return
  end
  # /traite_proximite_mode_interactif

  # Quand on supprime une proximité
  # Noter que pour le moment, ce temps est enregistré au même titre qu'une
  # correction.
  def suppression_proximite_confirmed iprox, debut_op
    enregistre_duree_correction_proximite(debut_op, Time.now.to_f)
    iprox.set_deleted
    self.changements_operes = true
  end

  # Quand on confirme la proximité opérée.
  def correction_proximite_confirmed iprox, debut_op
    enregistre_duree_correction_proximite(debut_op, Time.now.to_f)
    iprox.set_treated
    self.changements_operes = true
  end


  # Permet de remplacer un mot du texte par un autre et tenant à jour toutes
  # les proximités, pour corrections futures
  def remplacer_mot_par_mot iprox, pour_premier, new_mot
    Tests::Log << '-> remplacer_mot_par_mot'
    puts Tests.delimiteur_tableau # Pour les tests
    imot = iprox.send(pour_premier ? :mot_avant : :mot_apres)

    # Le remplacement est identique au mot existant => idiot
    imot.mot.my_downcase != new_mot.my_downcase || begin
      puts "Les deux mots sont identiques. Remplacement inutile."
      return
    end

    # Une proximité existe avec le nouveau mot => demande de confirmation
    infosprox = infos_proximity_for(imot, new_mot.my_downcase)
    Tests::Log << "infosprox: #{infosprox.inspect}"
    if infosprox[:proche]
      puts ('Attention, le mot “%s” se trouve à %i caractères %s le mot à remplacer.' % [new_mot, infosprox[:distance], (infosprox[:avant] ? 'avant' : 'après')]).rouge
      yesOrNo('Confirmez-vous quand même le remplacement ?') || return
    else
      # Le remplacement peut se faire. Demande de confirmation.
      yesOrNo('Remplacer le mot “%s” par “%s” (note : la proximité a été checkée avec succès)' % [imot.mot.jaune, new_mot.jaune]) || return
    end

    # On procède vraiment au remplacement
    load_module 'proximity/replace'
    old_mot = ('%s' % [imot.mot]).freeze
    if imot.remplace_par(new_mot)
      # Verrouiller le texte pour ne pas relancer une analyse sur les
      # anciens mots mais sur les nouveaux.
      Texte.current.set_info(locked: true)
      # Demander de confirmer le changement
      # notice("#{RETT}Le mot #{imot.mot} a été remplacé par #{new_mot.inspect}.#{RETT}Il faut encore confirmer la correction.#{RET2}")
      notice(RETT+('Le mot “%s” a été remplacé par “%s”.' % [old_mot, new_mot])+RETT+'Il faut encore confirmer la correction.'+RET2)
      self.changements_operes = true
    end
    return true
  end

  # Renvoie les informations de proximité du mot {Texte::Mot} +imot+ avec le
  # mot +new_mot+. Noter qu'+imot+, ici, ne sert qu'à connaitre l'offset du
  # mot.
  def infos_proximity_for imot, new_mot
    occur = Occurences[new_mot.my_downcase]
    # Si le mot de base n'a pas d'occurence
    if occur.nil?
      {proche: false, raison: 'Seule occurence', }
    else # <= Il y a des occurences du mot de base
      infosprox = index_of_nearest_offset(occur.offsets, imot.offset, occur.distance_min)
      if infosprox
        return infosprox.merge({
          proche: true,
          nombre_occurences: occur.count,
          raison: 'Occurence proche trouvée.'
          })
      else
        return {
          proche: false,
          nombre_occurences: occur.count,
          raison: 'Aucune occurence assez proche.'
        }
      end
    end
  end
  def index_of_nearest_offset liste, expected_offset, max_distance
    # Offset après lequel on pourra s'arrêter
    max_offset = expected_offset + max_distance
    liste.each_with_index do |offset, index_offset|
      dist = (offset - expected_offset).abs
      if dist <= max_distance
        return {index: index_offset, avant: offset < expected_offset, distance: dist}
      elsif offset > max_offset
        return nil
      end
    end
  end

  # Quand on tape 'r' seul, c'est qu'on veut remplacer un des mots de la
  # proximité. 'rp <mot>' ou 'rs <mot>' a pu être donné, qui précise si c'est le
  # premier (p) ou le seconde (s) mot qu'il faut changer, ainsi que le nouveau
  # mot (<mot>) à affecter. Dans le cas contraire, il faut demander toutes ces
  # informations
  def ask_si_avant_ou_apres_et_new_mot args
    args = args.split(' ')
    pour_premier  = args.shift
    nouveau_mot   = args.empty? ? nil : args.join(' ')
    pour_premier =
      case pour_premier[1]
      when 'p' then true
      when 's' then false
      else
        yesOrNo('Remplacer le premier mot ?') || return
      end
    nouveau_mot || begin
      nouveau_mot = askFor(RET2 + "Remplacer le #{pour_premier ? 'premier' : 'second'} mot par")
      nouveau_mot || return
    end
    return [pour_premier, nouveau_mot]
  end

  # Pour pouvoir proposer un mot et checker pour voir s'il ne va pas créer
  # une nouvelle proximité
  #
  # @param {Proximity} iprox  La proximité courante
  #
  def proposer_et_tester_un_mot iprox, choix

    pour_premier, new_mot = ask_si_avant_ou_apres_et_new_mot choix

    # On peut avoir fourni plusieurs mots, il faudra tester chacun d'un.
    # Une autre solution est de suggérer les mots l'un après l'autre
    mots = new_mot.strip.my_downcase.split(/[^[[:alnum:]]]/)
    # Le mot de référence en fonction du fait qu'on veut remplacer le premier
    # ou le second mot.
    imot_ref = iprox.send(pour_premier ? :mot_avant : :mot_apres)

    puts RET2 +
          '*** Test de la validité de la proposition : ' + nouveau_mot.inspect
    puts  '  * Mot de référence à remplacer (%s) : %s' % [(pour_premier ? 'premier' : 'second '), imot_ref.mot.inspect]

    # On teste pour chaque mot en en faisant des instances
    mots.each do |mot|

      infosprox = infos_proximity_for(imot_ref)
      nboccur = infosprox[:nombre_occurences]
      if infosprox[:proche]
        # <= Un mot proche a été trouvé
        puts '  = Proximité trouvée à %i caractères' % [infosprox[:distance]]
        distance_acceptable = infosprox[:distance] > (Proximity::DISTANCE_MAX_NORMALE * 2 / 3)
        color =  ? :mauve : :rouge
        msg = distance_acceptable ? 'acceptable' : 'fortement déconseillé'
        puts ('# Ce mot est %s' % [msg]).send(distance_acceptable ? :mauve : :rouge)
      else
        # <= Aucun mot proche n'a été trouvé
        msg = nboccur > 0 ? (' sur %i occurences' % [nboccur]) : 'car ce mot n’existe pas'
        puts '  = Pas de proximité trouvée %s.' % [msg]
        puts '  => Ce mot est utilisable sans problème.'.blue
      end
      getc('Tapez une touche quelconque pour passer à la suite…')
    end
    # /loop sur chaque mot proposé

    return true
  end
  # /proposer_et_tester_un_mot

end #/<< self
end #/Proximity
