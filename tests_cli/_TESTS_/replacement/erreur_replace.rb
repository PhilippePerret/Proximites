# encoding: UTF-8
require_relative '../../lib/required'


Tests.titre 'Analyse du texte moyen'
run('prox check test/texte_moyen.txt --force', ['q'])

#
# res = run('prox correct', [
#   'n',  # passer la première
#   'n',  # passer la seconde
#   'n',  # passer la troisième
#   'rs gueule',  # pour replacer la seconde occurrence de "dans" par "gueule"
#   'o',  # On confirme le remplacement
#   'oo', # On confirme la modification
#   'z',  # On arrête les modifications
#   'q'   # Pour terminer
#   ])
# tableaux = res.split(Tests.delimiteur_tableau)
# tableaux.each_with_index do |tbl, index_tbl|
#   puts RET3 + ('*** Tableau %i ***' % [index_tbl + 1]) + RET2 + tbl
# end
# tableaux[9].should_contain('Le mot "dans" a été remplacé par "gueule"',
# 'le mot "dans" a bien été remplacé par le "gueule" et un message le confirme.')


# fin_tests(display_log: true)
fin_tests
