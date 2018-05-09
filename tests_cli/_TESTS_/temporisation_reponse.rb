# encoding: UTF-8
=begin

  En fait, ça, ça correspond à un test de TestsCLI.

=end
require_relative '../lib/required'

Tests.grand_titre 'Test de temporisation de la réponse'
Tests.titre 'On demande d’attendre 4 secondes avant de répondre'
start = Time.now.to_i
Tests.sequence_keys= [['q', 4]]
run 'prox texte'
laps  = Time.now.to_i - start

laps.should_be_greater_than(3, 'la durée de temporisation est d’au moins 3 secondes')
laps.should_be_less_than(6, 'La durée de temporisation de la réponse n’excède pas 6 secondes')

fin_tests
