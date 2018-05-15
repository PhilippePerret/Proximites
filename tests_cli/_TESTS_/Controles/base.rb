# encoding: UTF-8
=begin
  Tests de la commande proximite control qui permet de checker les informations
  courantes concernant le fichier.
=end
require './tests_cli/lib/required'

Q = ['q']

def creer_le_check_et_lancer_le_controle
  run_check_texte
  run('prox control', Q)
end

def run_check_texte
  run('prox check -t "Un texte pour voir les mots du texte qu’il veut."', Q)
end

def oneline_conf ok, phrase
  (ok ? '  OK  ' : 'FAILED') + ' ' + phrase.ljust(70)
end

Tests.reset

Tests.grand_titre 'Test du contrôle des données'

Tests.titre 'L’absence du dossier principal interrompt le contrôle.'
run_check_texte
FileUtils.rm_rf(Prox.folder)
run('prox control',Q)
Tests.tableau(0).should_contain(oneline_conf(false,'Le dossier principal “proximites-texte” existe'),
'L’alerte de l’absence du dossier principal est donnée et le contrôle s’arrête là.')

Tests.titre 'L’absence d’un fichier principal est détecté'
run_check_texte
File.unlink(File.join(Prox.folder,'infos.msh'))
run('prox control', Q)
tableau1 = Tests.tableau(0)
tableau1.should_contain(oneline_conf(false, 'Le fichier de données “infos.msh” existe'), 'L’alerte de l’absence du fichier infos est données')
tableau1.should_contain(oneline_conf(true,  'Le fichier de données “mots.msh” existe'), 'L’existence du fichier mots est confirmée')
tableau1.should_contain(oneline_conf(true,  'Le fichier de données “proximites.msh” existe'), 'L’existence du fichier proximites est confirmée')
tableau1.should_contain(oneline_conf(true,  'Le fichier de données “occurences.msh” existe'), 'L’existence du fichier occurrences est confirmée')


Tests.titre 'Les mots sont contrôlés'
run_check_texte
run('prox control', Q)

# On regarde le résultat (rappel : il est affiché par less)
Tests.show_tableaux

fin_tests
