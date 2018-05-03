# encoding: UTF-8
=begin

  Test de multireplacement avec nouvelles proximités générées avec
  le nouveau mot comme avec les anciens

=end
require_relative '../lib/required'

Tests.reset # notamment pour supprimer le texte provisoire existant

Tests.grand_titre 'Remplacement créant une nouvelle proximité avec l’ancien mot'
# Exemple :
#   Un texte avec un texte et un autre texte.
#   Si le 2e "texte" est supprimé, le premier texte sera en proximité avec le
#   troisième.
#   L'affichage :
#       Un texte avec un texte|texte et un autre marion pour le texte après.
#          ---->         <---- ---->                            <----
#   … doit devenir :
#       Un texte avec un marion et un autre marion pour le texte après.
#          ---->         ----->             <-----               <----
#

Tests.titre 'Analyse du texte contenant 3 fois "texte"'

run('prox check -t "Un texte qui contient marion avec un texte et un autre marion pour le texte après."', ['q'])
ProximityTest.count.should_equal(3, 'Trois proximités ont été trouvées.')
Tests.sequence_keys = ['q']
res = run('prox texte')
res.should_equal(
"\t"+'Un texte qui contient marion avec un texte|texte et un autre marion pour le texte après.'+RET+
"\t"+'   ---->              ----->         <----|---->             <-----         <----       ',
'Le texte est affiché comme attendu'
)




Tests.titre 'Remplacement du "texte" central par le mot "marion"'
run('prox check -t "Un texte qui contient marion avec un texte et un autre marion pour le texte après."', ['q'])
Tests.sequence_keys = [
  'rs marion',  # pour remplacer le 2e "texte" par "marion"
  true,         # Pour confirmer le remplacement
  'oo',         # Pour confirmer le changement de proximité
  'z',          # pour arrêter les corrections
  true,         # pour enregistrer les changements dans les fichiers
  'q'           # pour terminer le programme
]
run 'prox correct'
ProximityTest.count.should_equal(3, 'Il y a maintenant 3 proximités.')
res = run('prox texte', ['q'])
res.should_equal(
"\t"+'Un texte qui contient marion avec un marion|marion et un autre marion pour le texte après.'+RET+
"\t"+'   ---->              ----->         <-----|----->             <-----         <----       ',
'Le texte affiché tient compte de la modification.'
)


fin_tests(display_log: false)
