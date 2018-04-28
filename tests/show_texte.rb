# encoding: UTF-8
=begin

  Test d'affichage du texte

=end
DETAILED = false

require_relative 'required'

texte = <<-EOT
Un petit texte pour voir les
proximités avec le texte et voir aussi
ce que ça donne.
EOT

# On procède d'abord à l'analyse du texte
run "proximite check -t \\\"#{texte}\\\""
run "proximite show texte"

retour_contient('Un petit texte pour voir')

fin_tests
