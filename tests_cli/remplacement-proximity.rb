# encoding: UTF-8
=begin

  Test du remplacement d'une proxmité par un nouveau mot

=end

require_relative './lib/required'

Tests.grand_titre 'Remplacement d’une proximité'

Tests.titre 'Remplacement de la seule proximité du texte'
Tests.sequence_keys= ['q']
run 'prox check -t "Un texte avec une répétition de texte pour voir !"'
Tests.titre 'Vérifications avant le remplacement'
ProximityTest.count.should_equal(1, 'Une seule proximité a été créée')
iprox = ProximityTest.get_by_index(0)
iprox.id.should_equal(0, 'L’identifiant de la proximité est 0')
iprox.deleted?.should_be_false('deleted? de la proximité')
iprox.treated?.should_be_false('treated? de  la proximité')
iprox.mot_avant.mot.should_equal('texte', 'le mot-avant de la proximité est “texte”')
iprox.mot_avant.index.should_equal(1, 'Le mot avant de la proximité #0 est à l’index 1')
iprox.mot_apres.index.should_equal(6, 'Le mot après de la proximité #0 est à l’index 6')
iprox.mot_avant.mot.should_equal('texte', 'le mot-après de la proximité est “texte”')
motA = iprox.mot_avant
motB = iprox.mot_apres
motA.index.should_equal(1, 'le mot avant de la proximité possède l’index 1')
motB.index.should_equal(6, 'le mot après de la proximité possède l’index 6')
motA.prox_ids.is_a?(Hash).should_be_true('prox_ids du mot-avant est un hash')
motA.prox_ids[:apres].should_equal(0, 'Le prox_ids[:apres] du mot avant est l’ID de la proximité (0)')
motB.prox_ids.is_a?(Hash).should_be_true('prox_ids du mot-après est un hash')
motB.prox_ids[:avant].should_equal(0, 'Le prox_ids[:avant] du mot après est  l’ID de la proximité (0)')

Tests.titre 'Vérification du texte'
Tests.sequence_touches = ['q']
res = run('prox texte')
res.should_equal(
"\t"+'Un texte avec une répétition de texte pour voir !'+RET+
"\t"+'   ---->                        <----            ',
'Le texte est correctement affiché'
)


Tests.titre 'Remplacement de la première proximité'
Tests.sequence_touches = [
  'rp bonjour',   # On remplace le premier par bonjour
  'oo',           # On confirme le modification
  true,           # On confirme l'enregistrement des modifications
  'q'             # pour terminer le programme
]
run 'prox correct'
iprox = ProximityTest.get_by_id(0)
iprox.deleted?.should_be_true('le deleted? de la proxmité #0')
iprox.treated?.should_be_true('le treated? de la proximité #0')
# Elle ne devrait plus avoir de mot avant et après
should_equal(iprox.mot_avant, nil, 'Le mot avant de la proximité n’existe plus')
should_equal(iprox.mot_apres, nil, 'Le mot après de la proximité n’existe plus')
motA = TexteTest.mots[1]
motB = TexteTest.mots[6]
motA.prox_ids[:apres].should_equal(nil, 'le mot avant ne définit plus prox_ids[:apres]')
motB.prox_ids[:avant].should_equal(nil, 'Le mot après ne définit plus prox_ids[:avant]')

Tests.titre 'Vérification du texte'
Tests.sequence_touches = ['q']
res = run('prox texte')
res.should_equal(
"\t"+'Un bonjour avec une répétition de texte pour voir !'+RET+
"\t"+'                                                   ',
'Le texte est correctement affiché, avec la correction'
)

fin_tests
