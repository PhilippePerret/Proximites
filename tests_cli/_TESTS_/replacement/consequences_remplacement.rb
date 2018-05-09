# encoding: UTF-8
require_relative '../../lib/required'
=begin

  Ce texte s'assure que les mots remplacés sont bien remplacés dans le texte
  lorsqu'on le réaffiche. Par exemple, si on a :

      Un texte avec un mot qui est un mot répété et encore un texte.

  Si on remplace "texte" par un autre mot, lorsqu'on étudie la proximité "mot",
  on doit afficher au début "Un bonjour avec un mot etc."

  TODO Faire aussi le test en remplaçant 'texte' par mot et s'assurer que la
  proximité de ce nouveau mot avec celui à l'index 5 soit étudié tout de suite.

=end

Tests.grand_titre 'Prise en compte immédiate du changement de mot'
Tests.description <<-EOT
Quand on remplace un mot par un autre, ce remplacement doit être pris à deux niveaux :
D'abord, il doit affecter l'affichage des extraits de proximités.
Ensuite, il doit prendre en compte les nouvelles proximités qui peuvent avoir été engendrées.
EOT

Tests.titre 'Remplacement du mot dans l’extrait suivant affiché'
texte = "Un texte avec un mot qui est un mot répété et encore un texte."
run('proximite check -t "%s"' % [texte], ['q'])

res = run('proximite correct', [
  'rp bonjour', # On remplace le premier 'texte'
  'o',          # On confirme ce remplacement
  'oo',         # On confirme cette modification
  'z',          # On arrête là
  'q'           # On termine le programme
  ])
tableaux = res.split(Tests.delimiteur_tableau)
tableaux[5].should_contain('Un bonjour avec un mot qui est un mot répété',
'Le changement a été pris en compte dans l’affichage de la prochaine proximité.')


Tests.titre 'Prise en compte comme nouvelle proximité (if anyu)'
texte = "Un texte avec un mot qui est un mot répété et encore un texte."
run('proximite check -t "%s"' % [texte], ['q'])

res = run('proximite correct', [
  'rp mot',     # On remplace le premier 'texte'
  'o',          # On confirme ce remplacement
  'oo',         # On confirme cette modification
  # Normalement, c'est ici que "Un +mot+ avec un +mot+ qui est un " devrait être
  # ajouté.
  'z',          # On arrête là
  'q'           # On termine le programme
  ])
tbl = tableaux[5].inspect
tbl.should_not_contain('index: 4<->8/14',
'la proximité courante devrait concerner le remplacement, pas la prochaine normale')
tbl.should_contain('index: 1<->4/14',
'La proximité étudiée après le changement est bien la nouvelle proximité engendrée par le changement.')
