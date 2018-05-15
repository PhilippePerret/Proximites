# encoding: UTF-8
require './tests_cli/lib/required'

Tests.reset


Tests.grand_titre 'Recherche de bugs'

run('prox check test/texte_court.txt --force', ['z'])

# CETTE CORRECTION FONCTIONNE
should_equal(OccurencesTest['bonjour'], nil, 'L’occurence de “bonjour” n’existe pas.')
run('prox correct', [
  'rp bonjour',
  'o',    # confirmation de remplacement
  'oo',   # confirmation de modification
  'z',    # Fin de la correction
  true,   # Enregistrement des informations
  'z'     # Terminer le programme
  ])
# Tests.show_tableaux
res = Tests.resultat_final
res.should_contain('Le mot “petit” a été remplacé par “bonjour”.',
  'Le remplacement est bien confirmé.')
should_not_equal(OccurencesTest['bonjour'], nil, 'L’occurence de “bonjour” existe.')

# ---------------------------------------------------------------------

Tests.titre 'On s’assure que la correction a été enregistrée'
run('prox texte',['q'])
# Tests.show_tableaux
Tests.tableau(0).should_contain('Un bonjour texte ou une petite boite')

# ---------------------------------------------------------------------

# -- AUTRE CORRECTION
run('prox correct', [
  'rs trottoir',
  true,         # Confirmer le remplacement
  'oo',         # Confirmer la correction
  # --- C'est le dernier ---
  true,         # Enregistrer les modifications
  'z'           # Terminer le programme
  ])
Tests.show_tableaux

fin_tests
