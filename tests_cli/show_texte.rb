# encoding: UTF-8
=begin

  Test d'affichage du texte

=end
DETAILED = true
require_relative './lib/required'


Tests.titre 'Un texte sans répétition est analysé et affiché correctement'
Tests.sequence_touches = ['q'] # pour finir
res = run("prox check -t \"Petit texte, sans répétition, et une exclamation !\"")

ProximityTest.count.should_equal(0, 'Aucune proximité n’a été trouvée.')


Tests.sequence_touches = ['q'] # pour finir après l'opération
res = run('prox texte')
res.should_equal("\t"+'Petit texte, sans répétition, et une exclamation !'+RET+
                 "\t"+'                                                  ',
                 'Le retour est conforme au texte.')


Tests.titre 'Un texte avec une répétition est analysé et affichée correctement'
Tests.sequence_touches = ['q'] # pour s'arrêter tout de suite
res = run("prox check -t \"Petit texte, avec une répétition de texte, sans exclamation !\"")
ProximityTest.count.should_equal(1, 'Une seule proximité a été trouvée.')
Tests.sequence_touches= ['q'] # pour finir après l'opération
res = run('prox texte')
res.should_equal("\t"+'Petit texte, avec une répétition de texte, sans exclamation !'+RET+
                 "\t"+'      ---->                         <----                    ',
                 'L’affichage du texte est conforme.')

fin_tests
