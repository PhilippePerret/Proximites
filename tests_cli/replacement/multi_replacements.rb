# encoding: UTF-8
=begin

  Test de multireplacement avec nouvelles proximités générées avec les
  anciens mots (pas de nouvelles avec le nouveau mot)

=end
require_relative '../lib/required'

Tests.reset # notamment pour supprimer le texte provisoire existant

Tests.grand_titre 'Remplacement créant une nouvelle proximité de l’ancien mot'
# Exemple :
#   Un texte avec un texte et un autre texte.
#   Si le 2e "texte" est supprimé, le premier texte sera en proximité avec le
#   troisième.
#   L'affichage :
#       Un texte avec un texte|texte et un autre texte après.
#          ---->         <---- ---->             <----
#   … doit devenir :
#       Un texte avec un bonjour et un autre texte.
#          ---->                             <----
#

Tests.titre 'Analyse du texte contenant 3 fois "texte"'

Tests.sequence_keys = ['q']
run('prox check -t "Un texte avec un texte et un autre texte après."')
ProximityTest.count.should_equal(2, 'Deux proximités ont été trouvées.')
Tests.sequence_keys = ['q']
res = run('prox texte')
res.should_equal(
"\t"+'Un texte avec un texte|texte et un autre texte après.'+RET+
"\t"+'   ---->         <----|---->             <----       ',
'Le texte est affiché comme attendu'
)




Tests.titre 'Remplacement du "texte" central par un autre mot'
run('prox check -t "Un texte avec un texte et un autre texte après." --force', ['q'])
Tests.sequence_keys = [
  'n',          # pour passer à la seconde correction
  'rp marion',  # pour remplacer le 2e "texte" par "marion"
  true,        # Pour confirmer le remplacement
  'oo',         # Pour confirmer le changement de proximté
  true,         # pour enregistrer les changements
  'q'           # pour terminer le programme
]
run 'prox correct'
ProximityTest.count.should_equal(1, 'Il ne reste plus qu’une seule proximité.')
res = run('prox texte', ['q'])
res.should_equal(
"\t"+'Un texte avec un marion et un autre texte après.'+RET+
"\t"+'   ---->                            <----       ',
'Le texte affiché tient compte de la modification.'
)


fin_tests(display_log: false)
