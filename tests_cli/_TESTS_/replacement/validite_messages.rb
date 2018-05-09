# encoding: UTF-8
require_relative '../../lib/required'


run('prox check -t "Un texte avec deux fois le mot texte."', ['q'])

res = run('prox correct', [
  'rp bonjour', # pour demander à remplacer le mot
  'o',          # confirmer
  'oo',         # pour confirmer le remplacement du mot
  'q'           # pour finir
  ])

tableaux = res.split(Tests.delimiteur_tableaux)
tableaux[3].should_contain('Le mot "texte" a été remplacé par "bonjour".')
