# encoding: UTF-8
require_relative '../../lib/required'


Tests.titre 'Analyse du texte moyen'
run('prox check test/texte_moyen.txt --force', ['q'])

onemot = 'climatisationnelle'
res = run('prox correct', [
  ('rp %s' % [onemot]),
  'o',    # Pour confirmer le remplacement
  'oo',   # Pour confirmer la modification
  'z',    # Pour arrêter la correction
  'n',    # Pour ne pas enregistrer les modifications
  # === ICI ===
  'o',    # Pour confirmer qu'on ne veut pas enregistrer les modifications
  # === /ICI ===
  'q'     # Pour quitter le programme
  ])
# Tests.show_tableaux_in(res)

Tests.titre 'Quand on demande de ne pas enregistrer les données corrigées, elles ne doivent pas l’être'
should_not_equal(OccurencesTest['vent'], nil, 'L’occurence de "vent" existe.')
should_equal(OccurencesTest[onemot], nil, 'Le texte “%s” ne contient pas le nouveau mot => les données n’ont pas été enregistrées.' % [onemot])

res = run('prox correct', [
  ('rp %s' % [onemot]),
  'o',    # Pour confirmer le remplacement
  'oo',   # Pour confirmer la modification
  'z',    # Pour arrêter la correction
  'n',    # Pour ne pas enregistrer les modifications
  # === ICI ===
  'n',    # Pour dire qu'on veut finalement enregistrer les modifications
  # === /ICI ===
  'q'     # Pour quitter le programme
  ])
# Tests.show_tableaux_in(res)

Tests.titre 'Demande de non enregistrement des correction puis renoncement => Data sont enregistrées'
Tests.description <<-EOT
Dans un premier temps, on demande de ne pas enregistrer les modifications. Puis, lorsque le programme demande confirmation, on revient sur sa décision et on dit qu'on veut finalement enregistrer ces modifications.
Les modifications doivent alors être prises en compte.
EOT
should_not_equal(OccurencesTest['vent'], nil, 'L’occurence de "vent" existe.')
should_not_equal(OccurencesTest[onemot], nil, 'L’occurence de "%s" existe => les données ont été enregistrées.' % [onemot])


res = run('prox correct', [
  ('rp %s' % [onemot]),
  'o',    # Pour confirmer le remplacement
  'oo',   # Pour confirmer la modification
  'z',    # Pour arrêter la correction
  # === ICI ===
  'o',    # Pour enregistrer directement les modifications
  # === /ICI ===
  'q'     # Pour quitter le programme
  ])
# Tests.show_tableaux_in(res)

Tests.titre 'Demande d’enregistrement des corrections'
should_not_equal(OccurencesTest['vent'], nil, 'L’occurence de "vent" existe.')
should_not_equal(OccurencesTest[onemot], nil, 'L’occurence de "%s" existe => les données ont été enregistrées.' % [onemot])


# fin_tests(display_log: true)
fin_tests
