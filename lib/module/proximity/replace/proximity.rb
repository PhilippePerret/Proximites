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
  #
  # Note : pour un texte court, ne serait-il pas intéressant de refaire
  #        simplement le check ?…
  #
  # @return TRUE si tout s'est bien passé (obligatoire)
  def replace iprox, pour_premier, nouveau_mot

    # Le mot à modifier
    imot = iprox.send(pour_premier ? :mot_avant : :mot_apres)

    # Il faut retirer la proximité des prox_ids du mot.
    # Noter que :
    #   1. Il faut le mémoriser pour pouvoir le retirer des proximites de
    #      l'occurence du mot.
    #   2. Cette valeur sera peut-être remise par +set_mot+ si une nouvelle
    #      proximité est trouvée.
    last_prox_id = imot.prox_ids[pour_premier ? :apres : :avant]
    imot.prox_ids[pour_premier ? :apres : :avant] = nil

    # On retire la proximité de la liste des proximités de l'occurence
    Occurences[imot.mot_base].retire_proximite(last_prox_id)

    # On modifie le mot
    imot.set_mot(nouveau_mot)

    # Il faut détruire la proximité (et réinitialiser les valeurs)
    destroy(iprox)

    # Verrouiller le texte pour ne pas relancer une analyse sur les
    # anciens mots mais sur les nouveaux.
    texte.set_info(locked: true)

    # ATTENTION : Ici, les changements ne sont pas enregistrés
    return true # pour enregistrer les changements

  rescue Exception => e
    error e.message
    puts e.backtrace.join("\n").rouge
    return false
  end

end #/<< self
end #Proximity
