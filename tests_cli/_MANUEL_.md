# Manuel des tests CLI

Les tests CLI permettent de tester les applications en ligne de commande qui sont à base de ruby.

Le système de base tient au fait que le shell du test (par exemple lancé dans Atom) ne sera pas le même que le shell du script lancé. Grâce à la classe `Tests`, on crée un *pont* de l'un à l'autre. On peut passer des réponses

## Applications testable

Prérequis pour qu'une application CLI soit testable :

* elle doit utiliser la classe commune `CLI`
* elle doit utiliser le module perso `ask` pour gérer l'interactivité
* elle doit utiliser le dossier `tests_cli` et notamment tout le contenu du dossier `tests_cli/lib`
* On doit trouver la ligne suivante à la fin du module `./lib/required` qui charge toute l'application :

        if CLI.options[:test]
          require('./tests_cli/lib/app_required')
        else
          require('./tests_cli/lib/no-tests.rb')
        end
* un dossier `tests_cli` à la racine contenant les éléments
* un dossier `tests_cli/lib`
* un dossier `tests_cli/lib/required` contenant tous les éléments requis pour toutes les applications utilisant ces tests.
* un dossier `tests_cli/lib/app_tests_cli` contenant les éléments propres à l'application utilisés par les tests pour facilité l'interaction. Par exemple des classes qui permettent de récupérer des données.

## Fonctionnement de l'interactivité

La base de l'interactivité fonctionne sur le fait que ce sont les méthodes `ask` qui gèrent les demandes de l'application CLI. Si on utilise directement la méthode `SDTIN.gets`, les tests ne pourront pas se faire.

Au contraire, si on utilise les méthodes `ask`, il suffit de définir avant le test les réponses qui seront données. Par exemple, si on imagine qu'une application attend un nombre pour le multiplier par 5. Cette application se trouve à l'adresse `./mon/app.rb`. On peut la tester de cette manière :

    # Dans le script test qui sera joué par CMD+i dans Atom
    require_relative './lib/required'

    # On définit ce qui sera tapé
    Tests.sequence_touches= ['5'] # ou simplement [5]

    # On lance le test (noter que l'option --test sera automatiquement ajouté)
    run './mon/app.rb'

### Séquence de touche

On a vu ci-dessous qu'on définissait la séquence de touches qui va être jouée avant de lancer le programme. De façon simple, cette suite de touches peut être définies simplement avec les touches, des `String` ou des `Fixnum` (nombre).

La séquence des touches peut également se définir en second argument de la méthode `run` :

    run('prox check -t "Mon texte"', ['q'])

#### Définir un temps de réponse

Mais on peut également définir un temps de réponse en donnant un `Array` dont la deuxième valeur correspond au nombre de secondes à attendre.

Par exemple :

    Tests.sequence_touches= [
      ['q', 10.5]
    ]

Le code ci-dessus fera que le test attendra 10 secondes et demi pour quitter finalement le programme, si la touche `q` permet de le faire.

## Test final des “tableaux”

La grande différence avec un test normal, c'est qu'ici ont teste les choses seulement à la toute fin, une fois que tout a été exécuté, même lorsqu'il y a de l'activté. Le principe est que :

> `run` retourne toujours l'intégralité de l'affichage qui a été effectué.

C'est donc en testant les différents “panneaux” retournés qu'on peut s'assurer que le programme s'est déroulé normalement (et, bien sûr, en testant les bases de données, les fichiers, etc.)

Pour faciliter le travail des panneaux, on peut demander à l'application qu'elle ajoute un délimiteur de tableau. Il sera ajouté partout où l'on indiquera `puts Tests.delimiteur_tableau`. Dans les tests, il suffira alors de découper le retour selon ce delimiteur pour avoir les différents panneaux :

    res = run('mon programme')
    res = res.split(Tests.delimiteur_tableau)
    # => res est un Array qui contient les différents “tableaux”.
