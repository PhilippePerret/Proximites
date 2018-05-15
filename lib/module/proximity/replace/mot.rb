# encoding: UTF-8
class Texte
class Mot

  # REMPLACEMENT D'UN MOT PAR UN AUTRE
  #
  # ATTENTION : CETTE PROCÉDURE EST PARTICULIÈREMENT COMPLEXE
  # Pour les raisons suivantes :
  #
  #  * Elle va certainement détruire la proximité elle-même, puisque c'est
  #    sa raison d'être
  #  * Le mot remplacé (soit le premier soit le second) va être modifié
  #    * sa longueur va changer => tous les offsets devraient changer !!!
  #    * son mot de base va changer
  #  * Les occurences de mots vont être changés :
  #    * on doit retirer tous les éléments en rapport avec le mot dans
  #      l'occurence
  #    * on doit ajouter dans l'autre occurence (si elle existe) ou en créer
  #      une nouvelle pour le mot.
  #  * Peut-être qu'une autre proximité doit être créée.
  #     => Il faut rechecker les proximités
  #  * Modifier le mot dans le texte (est-ce vraiment utile ? entendu que le
  #    texte, lorsqu'il est utilisé, utilise les instances. Mais quid lorsqu'on
  #    relancera une analyse du même texte ?…)
  #    => Mettre un attribut :locked au texte lorsque des proximités pour ne
  #    pas que ça arrive.
  #  * Noter qu'il est inutile de modifier le mot dans la liste des mots du
  #    texte puisque cette liste contient des instances Texte::Mot, pas vraiment
  #    le mot-string.
  #  * Le mot avant ou après (l'autre que celui remplacé) ne doit plus avoir de
  #    proximité, mais il faut vérifier quand même s'il ne rentre pas en
  #    proximité avec un autre mot.
  #  * Le mot remplacé peut très bien être en proximité
  #
  # Notes :
  # -------
  #       * Si le programme trouve une proximité, elle demande confirmation
  #         avant de procéder au changement.
  #       * pour un texte court, ne serait-il pas intéressant de refaire
  #         simplement le check ?…
  #
  # Le mot remplacé pouvant être en proximité avec deux mots (avant et après),
  # c'est cette méthode qui est appelée pour modifier un mot
  #
  #
  def remplace_par nouveau_mot_str
    Tests::Log << '-> Texte::Mot#replace'

    prox_id_avant = prox_ids && prox_ids[:avant]
    imot_avant = imot_apres = nil

    prox_id_avant && begin
      Tests::Log << "La proximité avant ##{prox_id_avant} est à détruire."
      imot_avant = Proximity[prox_id_avant].mot_avant
      Proximity.destroy(prox_id_avant)
    end

    prox_id_apres = prox_ids && prox_ids[:apres]
    prox_id_apres && begin
      Tests::Log << "La proximité après ##{prox_id_apres} est à détruire."
      imot_apres = Proximity[prox_id_apres].mot_apres
      Proximity.destroy(prox_id_apres)
    end

    # On remplace le mot
    set_mot(nouveau_mot_str)

    # On regarde si le nouveau mot est en proximité avec un autre
    # Attention : le `imot.mot_base`, ici, n'est pas le même que celui juste au-
    # dessus, donc l'occurence aussi n'est pas la même.
    # On regarde si l'autre mot que le mot modifié entre en proximité avec
    # un autre
    # Vérifier les proximités du nouveau mot vers l'avant et vers l'arrière
    if Occurences[mot_base]
      Occurences[mot_base].check_proximite_vers(self, true)
      Occurences[mot_base].check_proximite_vers(self, false)
    elsif mot_base != ''
      puts "Bizarrement, `Occurences[#{mot_base.inspect}]` est nil alors qu'une occurence de ce mot vient logiquement d'être créée…".rouge
      puts 'Toujours est-il que je ne peux pas checker les proximités avant et après du mot.'
    end

    # Vérifier les proximités de l'ancien mot avant s'il existe en avant
    imot_avant && Occurences[imot_avant.mot_base] && begin
      # Tests::Log << "Check de la nouvelle proximité arrière de l'ancien mot avant : #{imot_avant.inspect}"
      Occurences[imot_avant.mot_base].check_proximite_vers(imot_avant, true)
    end

    # Vérifier les proximités de l'ancien mot après s'il existe en arrière
    # Sauf si c'est justement le mot qui a été mis en proximité avec le mot
    # avant.
    imot_apres && Occurences[imot_apres.mot_base] && begin
      # Tests::Log << "Check de la nouvelle proximité vers l'avant de l'ancien mot après : #{imot_apres.inspect}"
      Occurences[imot_apres.mot_base].check_proximite_vers(imot_apres, false)
    end

    # Tests::Log << 'Après recherche des nouvelles proximités'+RETT+
    #   "prox_ids = #{prox_ids.inspect}"+RETT+
    #   (imot_avant ? "imot_avant.prox_ids = #{imot_avant.prox_ids.inspect}" : '- - -')+RETT+
    #   (imot_apres ? "imot_apres.prox_ids = #{imot_apres.prox_ids.inspect}" : '- - -')

    return true # pour continuer
  rescue Exception => e
    Tests::Log.error(e)
    error("#{e.message} (détail dans le fichier ./.tests_cli/test.log)")
    puts e.backtrace.join("\n").rouge
    return false
  end

  # Pour remplacer le mot actuel par un autre mot
  def set_mot new_mot

    # Différence de longueur entre le mot précédent et le nouveau mot.
    diff_len = new_mot.length - length

    old_mot_base = "#{self.mot_base}".freeze
    new_mot_base = Texte::Mot.get_mot_base(new_mot).freeze
    Tests::Log << <<-EOT
old mot base : #{old_mot_base.inspect}
new mot base : #{new_mot_base.inspect}
    EOT

    # Il faut forcément le faire avant de mettre les nouvelles valeurs,
    # car l'occurence se sert de mot_base, par exemple.
    new_mot_base != old_mot_base && begin
      Tests::Log << <<-EOT
Occurences[old_mot_base].mot = Occurences[#{old_mot_base}].mot = #{Occurences[old_mot_base] ? Occurences[old_mot_base].mot : '---'}
      EOT
      Occurences[old_mot_base].retire_mot(self)
    end

    # On peut véritablement modifier le mot.
    init
    @mot = @real_mot    = new_mot
    @mot_base           = new_mot_base
    @offset_correction  = diff_len

    # Il faut ajouter le mot à sa nouvelle instance d'occurences
    # On ajoute le mot à cette occurence, comme les autres. La méthode +add+
    # se charge de tout, notamment de créer l'instance s'il le faut.
    Occurences.add(self)

  end


end #/Mot
end #/Texte
