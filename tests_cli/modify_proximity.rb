# encoding: UTF-8
=begin

  Test de modification des proximites

=end
DETAILED = true
require_relative './lib/required'

# On commence par prendre un texte avec un répétition du mot 'texte' et on
# l'analyse.
run "proximite check -t \\\"Analyse d'un petit texte pour voir et voir encore le texte.\\\""

Tests.reponses = [
  'z', # Pour annnuler le travail de modification,
  'q', # Pour terminer l'application
]

# On lance la correction
run "prox show proximites -i"


fin_tests
