# encoding: UTF-8
=begin

Test d'affichage des proximites

=end
DETAILED = false

require_relative 'required'


run "proximite check -t \\\"Analyse d'un petit texte pour voir et voir encore le texte.\\\""
res = run "proximite show proximites"
retour_contient('texte <- 34 -> texte')
retour_contient('voir <- 8 -> voir')

# On essaie de voir une proximité par son ID

# On demande seulement la proximité #0
res = run "proximite show proximite 0"
retour_contient('texte <- 34 -> texte')
retour_ne_contient_pas('voir <- 8 -> voir')

# On demande seulement la proximité #1
res = run 'proximite show proximite 1'
retour_contient('voir <- 8 -> voir')
retour_ne_contient_pas('texte <- 34 -> texte')

fin_tests
