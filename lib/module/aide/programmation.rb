# encoding: UTF-8
class Prox
class << self

  def tableau_help_programmation
    <<-EOT

=== AIDE À LA PROGRAMMATION DE LA COMMANDE proximite (alias prox) ===

  PRINCIPES
  ---------

    * Le deuxième argument est toujours une commande.
    * Cette commande doit toujours être une méthode du module
      `class/Prox/main_commands.rb`


  CHARGEMENT DES MODULES
  ----------------------

  Les modules du dossier `./lib/module` peuvent être chargés à l'aide de la
  méthode `load_module` (handy méthode raccourcie de `Prox.load_module`)
  Ça peut être un simple fichier ou un dossier dont on charge tous les éléments.

  DIVERS
  ------

  Pour savoir si c'est le mode verbeux, utiliser `CLI.verbose?`


  LISTES
  ------

    Texte.current.mots
    ------------------

        Tous les mots du texte, tels qu'ils se présentent, sous forme d'instan-
        ces Texte::Mot.

        Les propriétés principales sont :

          * `mot` (= `real_mot`) Le mot tel qu'il est, sans aucune changement.
          * `mot_base` : le mot de base s'il existe. Par exemple 'devoir' pour
            la conjugaison 'devrait'
          * `index` : l'index du mot dans le texte, pour le retrouver dans la
            liste.
          * `offset` : le décalage exact du mot dans le texte.

    Occurences
    ----------

        La liste/classe `Occurences` (`Occurences.table`) fonctionne avec en clé
        le mot (mot de base) et en valeur une instance {Occurences} dont les
        propriétés principales sont :

          * `mot`         : le mot string
          * `indexes`     : tous les indexs des occurences (index dans
                            `Texte.current.mots`)
          * `proximites`  : liste des identifiants des proximités

    Proximiy
    --------
        La liste/classe `Proximity` (`Proximity.table`) fonctionne avec en clé
        un identifiant de proximité et en valeur une instance `Proximity`.
        L'identifiant est contenu dans la liste `proximites` de l'occurence du
        mot.

        Donc, par exemple, pour obtenir toutes les proximités d'un mot, on fait:

            #{'Occurences[<mot>].proximites # => IDs proximités'.jaune}

    EOT
  end

end #/<< self
end #/Prox
