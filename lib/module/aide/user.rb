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

Trouvez ci-dessous les commandes les plus usitées.

  #{'prox[imite] check mon/fichier.txt'.jaune}

      Incontournable, elle lance le check du texte contenu dans le fichier
      `mon/fichier.txt`

  #{'prox[imite] show proximites [-i]'.jaune}

      Si c'est un texte court, on peut afficher la liste des proximités de cette
      façon, sans l'option `-i`. Si c'est un texte long, l'option `-i` (pour in-
      teractif) permettra d'afficher les proximités l'une après l'autre.

  #{'prox[imite] show texte'.jaune}

      Permet d'afficher le texte avec l'indication des proximités. Si le texte
      est long, on peut demander l'affichage de pages en pages avec :

  #{'prox[imite] show texte -pp'.jaune}
  #{'prox[imite] show texte --per_page'.jaune}

      Affiche le texte avec l'indication des proximités de page en page.


= BASE DES COMMANDES =

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
              #{'prox proximites --ksort=count'.jaune}

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

  Configuration
  -------------

  On peut définir certaines propriétés à l'aide des options.


  Aide
  ----

  #{'prox'.gras} #{'prox help'.gras} #{'prox aide'.gras}

      Pour afficher cette aide.

      Ajouter l’option `-prog/--programmation` pour obenir l’aide programmateur.

  Analyse du texte
  ----------------

  #{'prox c[heck] <path> [options]'.gras}
  #{'prox -t c[heck] <texte> [options]'.gras}


      Méthode principale pour checker le texte qui se trouve au path  +path+ ou
      le texte fourni. Le mieux est de se trouver dans ce dossier pour lancer la
      commande sur le fichier visé.

      Options
      -------

        #{'--from=X'.gras}

            Pour n'analyser le texte qu'à partir du caractère d'offset X.

        #{'--to=X'.gras}

            Pour n'analyser le texte que jusqu'au caractère d'offset X.

        #{'--dmax_possible=<nombre signes|pages>'.gras}

            Définit la distance de proximité maximale.
            Rappel : la distance maximale de proximité entre deux occurences du
            même mot (ou de deux mots similaires) dépend de sa densité dans le
            texte, i.e. son nombre d'occurences. Plus un mot est rare, plus sa
            distance de proximité est grande (car on le remarquera plus).
            Mais avec des mots qui n'apparaitrait que 2 ou 3 fois sur 400 pages,
            la distance de proximité pourrait être de 200 pages, ce qui est trop
            grand et ne veut plus rien dire.
            On utilise donc cette #{'distance maximale possible'.gras} pour limiter la
            distance à quelque chose de raisonnable : 3 pages par défaut.
            Rappel : une page fait 1500 signes.
            Exemple pour limiter la distance max à 2 pages, donc 3000 signes.

              #{'prox check mon/texte.txt --dmax_possible=3000'}

            ou (le programme détecte si ce sont des pages ou des signes à partir
            du moment où le nombre est inférieur ou supérieur à 50)

              #{'prox check mon/texte.txt --dmax_possible=2'}


        #{'--dmax_normale=<nombre signes|pages>'.gras}

            Par défaut, la distance normale de proximité — c'est-à-dire la distan-
            ce sous laquelle on considère qu'un mot quelconque est en proximité –
            est une page, soit 1500 signes.
            On peut modifier cette valeur avec cette option. Elle sera enregistrée
            dans les données du texte (fichier .config.rb)
            Par exemple :

              #{'prox check -t "Mon texte est un texte." --dmax_normale=10'.jaune}

            … définira que la distance normale est de 10 signes. Si deux occuren-
            ces du même mot sont à moins de 10 signes, ils sont considérés comme
            proches.

        #{'--brut'.gras}

            Pour utiliser la distance fixe (cf. ci-dessous) pour chaque mot,
            sans tenir comme de leur fréquence. Rappel : dans le comportement
            normal du programme, on étudie la distance de proximité en fonction
            de l'occurence du mot. Plus il est rare et plus cette distance est
            élevée.

            Valeur distance fixe : (#{Proximity::DISTANCE_MAX_NORMALE})

        #{'--log'.gras}

            Pour enregistrer dans un fichier tous les choix qui ont permis de
            faire les choix de proximité. Ce fichier doit permettre de s'assurer
            que le check du texte est valide de façon manuelle mais aussi pour
            les tests.

            Pour lire le log, utiliser la commande :

                #{'prox[imite] show log'.jaune}

  Affichage des résultats
  =======================

    Résumé des commandes
    --------------------

          #{'prox[imite] show proximites [-i][--all]'.jaune}
          #{'prox[imite] show proximite <mot> [-i]'.jaune}
          #{'prox[imite] show proximite <ID> [-i]'.jaune}
          #{'prox[imite] proximites [--all]'.jaune}

          #{'prox[imite] show occurences'.jaune}
          #{'prox[imite] show occurence <mot>'.jaune}
          #{'prox[imite] occurences'.jaune}

          #{'prox[imite] show text[e] [-fp/--from_page=X] [-tp/--to_page=Z]'.jaune}

          #{'prox[imite] infos'.jaune}
          #{'prox[imite] stats'.jaune}


  #{'prox s[how] <what> [path] [options]'.gras}

      Permet d'afficher les résultats de test de proximité  et  d'occurence.  On
      peut les afficher en console ou  dans un fichier séparés  ne contenant que
      les informations demandées.

      Noter que le `path` doit toujours être  le dernier paramètre,  et  que  la
      chose à afficher doit toujours être en second paramètre après le `show`.

      Sans option, les données sont affichées en console. Pour les  mettre  dans
      un fichier qui sera ouvert :

          #{'prox s[how] [path] --output=[format]/-o=[format] --open'.jaune}

      Par défaut, le format est du simple texte (.txt)

  #{'prox[imite] proximites [--ksort=count]'.jaune}

      Permet d’afficher seulement les mots qu'on trouve en proximités, sans
      répétition, mais sans détail de ces proximités.

  #{'prox[imite] show text[e]'.jaune}

      Affiche le texte en indiquant les proximités qui ont été relevées, de fa-
      çon très visuel.

      Avec les options --from_page (-fp) et/ou --to_page, on peut limiter l'af-
      ficchage à une portion de texte (une page fait 1500 signes par défaut).
      Exemple :

          #{'prox show texte --from_page=1O0 -tp=120'.jaune}
          # Affiche le texte, des pages 100 à 120

      On peut aussi le faire avec --from et --to en indiquand le décalage. Par
      exemple :

          #{'prox show text --from=12566 --to=12800'.jaune}
          # Affiche le texte, du signe 12566 au signe 12800

  #{'prox s[how] stats [path]'.jaune}

      Pour afficher les statistiques concernant le texte, c’est-à-dire le nombre de
      mots, de proxmités, la longueur du texte, etc.


  Affichage des proximités pour corrections
  =========================================

      Résumé de toutes les commandes
      ------------------------------

          #{'prox s[how] proximites [path] [options]'.jaune}
            # Affiche toutes les proximités les unes au-dessus des autres.
          #{'prox -i s[how] proximites [path] [options]'.jaune}
            # Passe en revue toutes les proximités en mode interactif
          #{'prox s[how] proximite <mot> [path] [options]'.jaune}
            # Noter le singulier.
            # Proximités du mot <mot>. Avec l’option `-i`, en mode interactif.
          #{'prox s[how] proximite <ID> [path] [options]'.jaune}
            # Noter le singulier.
            # Proximité d'identifiant <ID> en mode interactif avec l’option -i.
          #{'prox[imite] proximites [--ksort=count]'.jaune}
            # Affiche la liste simple des mots en proximité, classés soit par
            # order alphabétique (défaut) soit suivant le nombre de proximités
            # trouvées (--ksort=count)

      Détail/explications
      -------------------

  C’est cette fonction qui a présidé à la construction de ce petit programme.
  Pouvoir faire une analyse des proximités de mots et pouvoir les corriger, sa-
  chant que le français supporte mal ces répétitions.

  Après avoir lancé le check du texte (`#{'prox check mon/fichier.txt'.jaune}`), on
  peut lancer la commande suivante pour voir s’afficher toutes les proximités :

      #{'prox s[how] proximites'.jaune}

  (noter que le path a été mémorisé, inutile de le remettre)
  Cette méthode affiche toutes les proximités de mots trouvés.

  Mais pour un texte long (quelques centaines de pages), c’est plutôt indigeste,
  et il est beaucoup plus pratique d’afficher les proximités les unes après les
  autres grâce à l’option `interactif` :

      #{'prox -i s[how] proximites'.jaune}

  Les avantages sont les suivants :

    * On peut indiquer les corrections que l’on fait (les proximités ne seront
      plus présentées aux prochaines sessions).
    * On peut supprimer des proximités qu’on ne juge pas pertinentes.
    * La portion de texte montrée est beaucoup plus grande, qui permet de cor-
      riger “à l’écran” avant de reporter la correction.
    * Le programme calcule le temps de correction et estime le temps qui sera
      nécessaire pour corriger tout le texte. Ce temps est bien sûr enregistré
      d’une session à l’autre, ce qui permet d’affiner grandement le calcul.

  Information sur un mot
  ======================

      #{'prox[imite] s[how] <mot> [--deep]'.jaune}

          Affiche toutes les informations sur le mot <mot>, c’est-à-dire son
          nombre d’occurences, de proximités.

          Si l’option #{'--deep'.gras} est utilisée, on affiche les infos en
          profondeur, c’est-à-dire par exemple qu’on va donner les offsets de
          chacune des occurences, le détail des proximités, etc.

  Informations sur le texte
  =========================

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
