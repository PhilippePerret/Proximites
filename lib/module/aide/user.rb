# encoding: UTF-8
class Prox
class << self

  # L'aide affichée
  def tableau_help
    <<-EOT

=== AIDE COMMANDE proximite (alias `prox`) ===

Bienvenue dans le programme proximite dont le but principal est de corriger les
problème de trop grande proximité des mots dans un texte quelconque.

= COMMANDES PRINCIPALES =

  La base des commandes est :

      #{'prox[imite] [commande] [arg-commande] [path] [options]'.jaune}

  Le `[path]` peut être omis si c’est le même que pour la commande précédente.
  Pour le moment, les `[options]` doivent impérativement être mises après.

  Options générales
  -----------------

      #{'--verbose/-vb'.gras}     Mode verbeux, pour afficher tous les messages.

      #{'--ksort=[count|mot]'.gras}

          Permet de déterminer la clé de classement lors de l'affichage d'une
          liste. Par exemple, pour voir les occurences de tous les mots classés
          par ordre alphabétique :

              #{'prox show occurences test/texte_court.txt --ksort=mot'.jaune}

          Par défaut, c'est `count` qui est utilisé, en mettant les plus nom-
          breux en haut (ordre décroissant).

      #{'--all'.gras}

          Pour  tout traiter, suivant les cas. Par exemple, avec les proximités,
          l’option signifie qu’il faut afficher toutes les proximités, même cel-
          les qui ont été marquées supprimées ou traitées :

              #{'prox show proximites test/texte_long.txt --all'.jaune}

      #{'--only=X'.gras}

          Pour limiter l’affichage à un certain nombre d’items. Ne fonctionne
          pas encore pour tout.
          Par exemple, si on veut seulement voir les 100 premiers mots à occu-
          rences fortes, on peut faire :

              #{'prox show occurences --only=100 mon/fichier/texte.txt'.jaune}

      #{'-tr/--treated'.gras}

          Pour ne considérer que les occurences traitées. Par exemple, quand on
          demande :

              #{'prox show occurences --treated'.jaune}

          … alors seules les occurences traitées seront affichées.
          Noter que le path n'est pas indiqué, il s'agit donc du dernier fichier
          traités.

      #{'-t/--texte'.gras}

          Indique que le dernier paramètre n’est pas le path  du  fichier texte,
          mais le texte à étudier. Par exemple :

              #{'prox -t check "Le texte à étudier."'.jaune}

  Aide
  ----

  #{'prox'.gras} #{'prox help'.gras} #{'prox aide'.gras}

      Pour afficher cette aide.

      Ajouter l’option `-prog/--programmation` pour obenir l’aide programmateur.

  Analyse du texte
  ----------------

  #{'prox check [path ou texte] [options]'.gras}

      Méthode principale pour checker le texte qui se trouve au path  +path+. Le
      mieux est de se trouver dans ce dossier pour lancer la commande sur le fi-
      chier visé.
      On peut donner aussi explicitement le texte, entre guillemets, en  paramè-
      tre :
          `prox check "Un petit texte en paramètre."`
      Mais dans ce cas le retour sera beaucoup moins précis  car il n'y aura pas
      de dossier dans lequel mettre le résultat. Tout sera affiché à l'écran.

      Options
      -------

        #{'--from=X'.gras}

            Pour n'analyser le texte qu'à partir du caractère d'offset X.

        #{'--to=X'.gras}

            Pour n'analyser le texte que jusqu'au caractère d'offset X.

        #{'--brut'.gras}

            Pour utiliser la distance fixe (cf. ci-dessous) pour chaque mot,
            sans tenir comme de leur fréquence. Rappel : dans le comportement
            normal du programme, on étudie la distance de proximité en fonction
            de l'occurence du mot. Plus il est rare et plus cette distance est
            élevée.

            Valeur distance fixe : (#{Texte::Mot::DISTANCE_DEFAUT})

  Affichage des résultats
  -----------------------

  #{'prox show [what] [path] [options]'.gras}

      Permet d'afficher les résultats de test de proximité  et  d'occurence.  On
      peut les afficher en console ou  dans un fichier séparés  ne contenant que
      les informations demandées.

      Noter que le `path` doit toujours être  le dernier paramètre,  et  que  la
      chose à afficher doit toujours être en second paramètre après le `show`.

      Sans option, les données sont affichées en console. Pour les  mettre  dans
      un fichier qui sera ouvert :

          #{'prox show [path] --output=[format]/-o=[format] --open'.jaune}

      Par défaut, le format est du simple texte (.txt)


  Affichage des proximités pour corrections
  ------------------------------------------

  C’est cette fonction qui a présidé à la construction de ce petit programme.
  Pouvoir faire une analyse des proximités de mots et pouvoir les corriger, sa-
  chant que le français supporte mal ces répétitions.

  Après avoir lancé le check du texte (`#{'prox check mon/fichier.txt'.jaune}`), on
  peut lancer la commande suivante pour voir s’afficher toutes les proximités :

      #{'prox show proximites'.jaune}

  (noter que le path a été mémorisé, inutile de le remettre)
  Cette méthode affiche toutes les proximités de mots trouvés.

  Mais pour un texte long (quelques centaines de pages), c’est plutôt indigeste,
  et il est beaucoup plus pratique d’afficher les proximités les unes après les
  autres grâce à l’option `interactif` :

      #{'prox -i show proximites'.jaune}

  Les avantages sont les suivants :

    * On peut indiquer les corrections que l’on fait (les proximités ne seront
      plus présentées aux prochaines sessions).
    * On peut supprimer des proximités qu’on ne juge pas pertinentes.
    * La portion de texte montrée est beaucoup plus grande, qui permet de cor-
      riger “à l’écran” avant de reporter la correction.
    * Le programme calcule le temps de correction et estime le temps qui sera
      nécessaire pour corriger tout le texte. Ce temps est bien sûr enregistré
      d’une session à l’autre, ce qui permet d’affiner grandement le calcul.


  Informations sur le texte
  -------------------------

  #{'prox[imite] infos'.gras}

  Affiche des informations générales sur le texte, comme la dernière commande
  utilisée, le nombre de corrections effectuées, la durée moyenne de correction,
  etc. Ce fichier a été initié notamment pour pouvoir prédire le temps de cor-
  rection du texte entier en fonction de la durée moyenne de correction.

  Cette commande n’est pas à confondre avec la commande `prox show stats` qui
  affiche des statistiques sur le nombre de mots, de signes, de proximités,
  etc.

    EOT
  end
  #/tableau_help

end #/<< self
end #/Prox
