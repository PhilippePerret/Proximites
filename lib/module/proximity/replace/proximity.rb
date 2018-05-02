# encoding: UTF-8
class Proximity
class << self

  # Permet de remplacer un mot par un autre dans une proximité
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
  #
  # Note : pour un texte court, ne serait-il pas intéressant de refaire
  #        simplement le check ?…
  #
  # @return TRUE si tout s'est bien passé (obligatoire)
  def replace iprox, pour_premier, nouveau_mot
    Tests::Log << "-> Proximity::replace(iprox ##{iprox.id}, pour_premier:#{pour_premier.inspect}, nouveau_mot:#{nouveau_mot.inspect})"

    # Pour être sûr d'avoir la bonne instance
    iprox = Proximity[iprox.id]

    # Le mot à modifier (soit le mot avant de la proximité, soit le mot après)
    imot = iprox.send(pour_premier ? :mot_avant : :mot_apres)
    index_imot = 0 + imot.index
    Tests::Log << "   Index du mot à remplacer : #{index_imot}"

    # L'autre mot
    autre_imot = iprox.send(pour_premier ? :mot_apres : :mot_avant)
    index_autre_imot = 0 + autre_imot.index
    Tests::Log << "   Index du mot à NE PAS remplacer : #{index_autre_imot}"

    # puts "Avant destruction iprox : imot.prox_ids = #{imot.prox_ids.inspect}"

    # Il faut détruire la proximité (et réinitialiser les valeurs)
    # Cela :
    #   * Détruit la proximité (instance) dans la table Proximity
    #   * Reset les prox_ids des instances de mots
    #   * Retire les ID de ces proximités dans la propriété @proximites des
    #     occurences des deux mots.
    destroy(iprox)
    Tests::Log << "Après destruction de la proximité : #{RETT}"+
      "imot.prox_ids = #{imot.prox_ids.inspect}"+RETT+
      "autre_imot.prox_ids = #{autre_imot.prox_ids.inspect}"

    # puts "Après destruction iprox : imot.prox_ids = #{imot.prox_ids.inspect}"

    # On modifie le mot
    Tests::Log << 'Identifiant de l’objet à modifier'+RETTT+
      "imot.object_id = #{imot.object_id.inspect} / Texte.current.mots[#{index_imot}].object_id = #{Texte.current.mots[index_imot].object_id.inspect}"
    imot.set_mot(nouveau_mot)
    Tests::Log << 'Identifiant de l’objet modifié'+RETTT+
      "imot.object_id = #{imot.object_id.inspect} / Texte.current.mots[#{index_imot}].object_id = #{Texte.current.mots[index_imot].object_id.inspect}"
    Tests::Log << 'Après remplacement du terme dans l’instance Texte::Mot :'+RETTT+
      "imot.mot      = #{imot.mot.inspect} / dans texte_courant : #{Texte.current.mots[index_imot].mot.inspect}"+RETTT+
      "imot.real_mot = #{imot.real_mot.inspect} / dans texte_courant : #{Texte.current.mots[index_imot].real_mot.inspect}"+RETTT+
      "imot.mot_base = #{imot.mot_base.inspect} / dans texte_courant : #{Texte.current.mots[index_imot].mot_base.inspect}"

    # On regarde si le nouveau mot est en proximité avec un autre
    # Attention : le `imot.mot_base`, ici, n'est pas le même que celui juste au-
    # dessus, donc l'occurence aussi n'est pas la même.
    # On regarde si l'autre mot que le mot modifié entre en proximité avec
    # un autre
    Occurences[imot.mot_base].check_proximite_vers(imot, vers_avant = pour_premier)
    Occurences[autre_imot.mot_base].check_proximite_vers(autre_imot, vers_avant = !pour_premier)
    Tests::Log << 'Après recherche des nouvelles proximités pour les deux mots'+RETT+
      "imot.prox_ids = #{imot.prox_ids.inspect}"+RETT+
      "autre_imot.prox_ids = #{autre_imot.prox_ids.inspect}"

    # puts "Après check des proximités à la fin fin : imot.prox_ids = #{imot.prox_ids.inspect}"

    # Verrouiller le texte pour ne pas relancer une analyse sur les
    # anciens mots mais sur les nouveaux.
    texte.set_info(locked: true)

    # ATTENTION : Ici, les changements ne sont pas enregistrés
    return true # pour enregistrer les changements

  rescue Exception => e
    Tests::Log.error e
    error e.message
    puts e.backtrace.join("\n").rouge
    return false
  end

end #/<< self
end #Proximity
