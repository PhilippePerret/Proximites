# encoding: UTF-8
require_relative '../../lib/required'

Tests.grand_titre 'Test des remplacements de mots'

# Tests.titre 'Analyse du texte moyen'
# run('prox check test/texte_moyen.txt --force', ['q'])

Tests.titre 'Analyse d’un texte court'
texte = 'Un texte de vent avec un autre texte.'
run('prox check -t "%s"' % [texte], ['q'])

Tests.titre 'Le programme demande confirmation lorsqu’il trouve une proximité'
res = run('prox correct', [
  'rp vent',  # un mot qui existe avant => alerte
  'n',        # annulation du remplacement
  'n',        # Pour passer à la correction suivante
  'po',       # Pour supprimer la correction suivante
  'z',        # Pour arrêter les corrections
  true,       # Pour enregistrer les changements
  'z',        # Pour terminer le programme
  'z', 'z', 'z' # On ne sait jamais
  ])
Tests.show_tableaux_in(res) # <--- POUR VOIR LES TABLEAUX
# tableaux = Tests.tableaux_in(res)
# tableaux[3].should_contain('Attention, le mot “vent” se trouve à %i caractères' % [9],
# 'Une alerte indiquant la proximité est affichée.')
# tableaux[3].should_contain('Confirmez-vous quand même le remplacement',
# 'Le programme demande de confirmer le remplacement.')




# res = run('prox correct', [
#   'n',  # passer la première
#   'n',  # passer la seconde
#   'n',  # passer la troisième
#   'rs gueule',  # pour replacer la seconde occurrence de "dans" par "gueule"
#   'o',  # On confirme le remplacement
#   'oo', # On confirme la modification
#   'z',  # On arrête les modifications
#   'o',  # On les enregistre
#   'q'   # Pour terminer
#   ])
# Tests.show_tableaux_in(res)
# tableaux = Tests.tableaux_in(res)
# tableaux[9].should_contain('Le mot "dans" a été remplacé par "gueule"',
# 'le mot "dans" a bien été remplacé par le "gueule" et un message le confirme.')


# fin_tests(display_log: true)
fin_tests
