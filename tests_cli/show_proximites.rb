# encoding: UTF-8
=begin

Test d'affichage des proximites

=end
DETAILED = true
require_relative './lib/required'


Tests.reponses = ['q'] # pour finir tout de suite
run "proximite check -t \"Analyse d'un petit texte pour voir et voir encore le texte.\""

Tests.titre 'Affichage de toutes les proximités trouvées (2)'
Tests.reponses = ['q'] # pour finir tout de suite
res = run "proximite show proximites"
res.should_contain('texte <- 34 -> texte', 'L’affichage des proximités contient "texte" avec l’écartement de 34')
res.should_contain('voir <- 8 -> voir', 'L’affichage des proximités contient "voir" avec l’écartement de 8')

Tests.titre 'Affichage de la proximité par son ID'
# On demande seulement la proximité #0
Tests.reponses = ['q'] # pour finir tout de suite
res = run "proximite show proximite 0"
res.should_contain('texte <- 34 -> texte', 'L’affichage des proximités contient "texte" avec l’écartement de 34')
res.should_not_contain('voir <- 8 -> voir', 'L’affichage des proximités NE contient PAS "voir"')
Tests.reponses = ['q'] # pour finir tout de suite
res = run "proximite show proximite 1"
res.should_not_contain('texte <- 34 -> texte', 'L’affichage des proximités NE contient PAS "texte".')
res.should_contain('voir <- 8 -> voir', 'L’affichage des proximités contient "voir" avec l’écartement 8')

Tests.titre 'Un mauvais ID de proximité produit une erreur'
Tests.reponses = ['q']
res = run 'proximites show proximite 2'
res.should_not_contain('texte <- 34 -> texte', 'L’affichage des proximités NE contient PAS "texte".')
res.should_not_contain('voir <- 8 -> voir', 'L’affichage des proximités NE contient PAS "voir"')

fin_tests
