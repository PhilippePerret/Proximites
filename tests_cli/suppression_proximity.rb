# encoding: UTF-8
=begin

  Test de modification des proximites

=end
DETAILED = true
require_relative './lib/required'

# On commence par prendre un texte avec un répétition du mot 'texte' et on
# l'analyse.
Tests.titre 'Analyse d’un texte avec deux proximités'
Tests.reponses = ['q'] # pour finir (toujours le mettre)
run "proximite check -t \\\"Analyse d’un petit texte pour voir et voir encore le texte.\\\""
# puts "Proximités après le check".jaune
# ProximityTest.puts
ProximityTest.count.should_equal(2, '2 proximités ont été créées.')
ProximityTest.get_by_index(0).deleted?.should_equal(false, 'la première proximités n’est pas deleted.')

# AFFICHAGE DU TEXTE
Tests.titre 'Affichage du texte'
res = run 'prox texte'
res.should_equal(
  'analyse d’un petit texte pour voir et voir encore le texte.'+RET+
  '                   ---->      --->    <---           <---- ',
  'Le texte affiché est conforme.')
# puts res
fin_tests
exit 0


# TEST DE LA SUPRRESION DE LA PREMIÈRE PROXIMITÉ
Tests.titre 'Suppression de la première proximité'
Tests.reponses = [
  'so', # Pour supprimer la première proximité en confirmant
  'z', # Pour abandonner le travail de modification,
  true, # Enregistrer les changements opérés
  'q', # Pour terminer l'application
]
run "prox correct"
ProximityTest.count.should_equal(2, 'Il y a toujours 2 proximités.')
ProximityTest.get_by_index(0).deleted?.should_equal(true, 'la première proximité est marquée deleted')
ProximityTest.get_by_index(1).deleted?.should_equal(false, 'la seconde proximité n’est pas marquée deleted')

# puts "Proximités après la suppression".jaune
# ProximityTest.puts


fin_tests
