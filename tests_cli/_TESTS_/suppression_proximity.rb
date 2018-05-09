# encoding: UTF-8
=begin

  Test de modification des proximites

  En fait, supprimer une proximité consiste simplement à mettre son deleted
  à true.

=end
require_relative '../lib/required'

Tests.grand_titre 'Test de la suppression interactive de proximités'

# On commence par prendre un texte avec un répétition du mot 'texte' et on
# l'analyse.
Tests.titre 'On peut supprimer une unique proximité'
Tests.sequence_touches = ['q'] # pour finir (toujours le mettre)
run "proximite check -t \"Un texte avec un autre texte.\" --force"
ProximityTest.count.should_equal(1, '1 proximité a été créée.')
ProximityTest.get_by_index(0).deleted?.should_equal(false, 'la proximité n’est pas deleted.')
# On supprime cette proximité
Tests.sequence_touches = [
  'so', # pour supprimer la première proximité
  'o',  # Pour confirmer l'enregistrement des informations
  'q'   # pour terminer le programmme
]
run "proximite correct"
ProximityTest.count.should_equal(1, 'Il y a toujours 1 proximité.')
ProximityTest.get_by_index(0).deleted?.should_equal(true, 'la proximité a été deleted.')


Tests.titre 'On peut supprimer la bonne proximité parmi trois'
Tests.sequence_touches = ['q']
run 'prox check -t "Un texte pour voir un autre avec un texte et un autre voir."'
ProximityTest.count.should_equal(3, 'Il y a bien 3 proximités')
(0..2).each do |index_prox|
  ProximityTest.get_by_index(index_prox).deleted?.should_equal(false, "la proximité #{1+index_prox} n’est pas deleted.")
end
# L'affichage du texte est correct
Tests.sequence_touches = ['q']# Pour terminer le programme
res = run('proximite texte')
res.should_equal(
  "\t"+'Un texte pour voir un autre avec un texte et un autre voir.'+RET+
  "\t"+'   ---->      --->    ---->         <----       <---- <--- ',
  'L’affichage du texte montre bien les 3 proximités'
)

# On supprime interactivement la 2e proximité
Tests.sequence_touches = [
  'n',  # pour passer à la proximité suivante sans rien faire
  's',  # pour supprimer la 2e proximité
  'o',  # pour confirmer cette suppression
  'z',  # pour arrêter la correction
  'o',  # pour enregistrer les changements
  'q'   # pour terminer le programme
]
res = run('proximite correct')
ProximityTest.get_by_index(0).deleted?.should_equal(false, "la 1ère proximité n’est pas deleted.")
ProximityTest.get_by_index(1).deleted?.should_equal(true, "la 2e proximité EST DELETED.")
ProximityTest.get_by_index(2).deleted?.should_equal(false, "la 3e proximité n’est pas deleted.")
# L'affichage du texte est correct
Tests.sequence_touches = ['q']# Pour terminer le programme
res = run('proximite texte')
res.should_equal(
  "\t"+'Un texte pour voir un autre avec un texte et un autre voir.'+RET+
  "\t"+'   ---->              ---->         <----       <----      ',
  'L’affichage du texte ne montre plus que les 2 proximités restants'
)

fin_tests
