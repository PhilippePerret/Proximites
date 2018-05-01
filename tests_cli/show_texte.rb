# encoding: UTF-8
=begin

  Test d'affichage du texte

=end
DETAILED = true
require_relative './lib/required'

Tests.titre 'Un texte est analysé correctement'
Tests.reponses = ['q'] # pour finir
run "prox check -t \"Petit texte, sans répétition, et une exclamation.\" --force"

ProximityTest.count.should_equal(0, 'Aucune proximité n’a été trouvée.')

Tests.reponses = ['q'] # pour finir après l'opération
res = run 'prox texte'
res.should_equal('Petit texte, sans répétition, et une exclamation.'+RET+
                 '                                                  ',
                 'Le retour est conforme au texte.')


fin_tests
