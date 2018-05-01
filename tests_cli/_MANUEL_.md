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


## Fonctionnement de l'interactivité

La base de l'interactivité fonctionne sur le fait que ce sont les méthodes `ask` qui gèrent les demandes de l'application CLI. Si on utilise directement la méthode `SDTIN.gets`, les tests ne pourront pas se faire.

Au contraire, si on utilise les méthodes `ask`, il suffit de définir avant le test les réponses qui seront données. Par exemple, si on imagine qu'une application attend un nombre pour le multiplier par 5. Cette application se trouve à l'adresse `./mon/app.rb`. On peut la tester de cette manière :

    # Dans le script test qui sera joué par CMD+i dans Atom
    require './lib/required'

    # On définit ce qui sera tapé
    Tests.reponses= ['5'] # ou simplement [5]

    # On lance le test (noter que l'option --test sera automatiquement ajouté)
    run './mon/app.rb'