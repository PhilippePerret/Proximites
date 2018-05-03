# encoding: UTF-8
=begin

  Ce test vérifie qu'un mot à distance minimale fixe est bien traitée.

  Rappel : ce sont des mots, comme "mais", dont on définit la distance minimale
  de façon fixe, quelle que soit leur fréquence.

=end

require_relative '../lib/required'

Tests.reset

Tests.grand_titre 'Mots à distance min fixe'

Tests.titre 'Deux "mais" plus écartés que la distance min fixe ne sont pas en proximité'
Tests.sequence_keys= ['q']
run "prox check -t \"Un Mais#{' x y '*10} mais pour voir le mot mais.\""
ProximityTest.count.should_equal(1, 'Une seule proximité')
res = run( "prox texte", ['q'] )
res.should_equal(
"\t"+"Un Mais#{' x y '*10} mais pour voir le mot mais."+RET+
"\t"+"       #{'     '*10} --->                  <--- ",
'Le texte est correctement affiché'
)

Tests.titre 'Deux "mais" moins écartés que la distance min fixe sont en proximité'
Tests.sequence_keys= ['q']
run "prox check -t \"Un mais#{' x y '*9} mais pour voir le mot mais.\""


ProximityTest.count.should_equal(2, 'Deux proximités ont été créée')
res = run( "prox texte", ['q'] )
res.should_equal(
"\t"+"Un mais#{' x y '*9} mais|mais pour voir le mot mais."+RET+
"\t"+"   --->#{'     '*9} <---|--->                  <--- ",
'Le texte est correctement affiché'
)


# fin_tests(display_log: true)
fin_tests
