# encoding: UTF-8
=begin

Test d'affichage des proximites

=end
require_relative './lib/required'



Tests.grand_titre 'Tests des corrections interactives'
Tests.description 'On analyse un grand texte, puis on se lance dans la correction interactive, donc proximité par proximité, parfois ne supprimant une correction, parfois en la corrigeant.'

# On peut commenter les lignes suivantes après l'analyse du texte
Tests.titre 'Analyse du texte'
run("proximite check test/texte_long.txt", ['q'])

Tests.titre 'Correction du texte'
Tests.description 'Maintenant que le texte a été analysé, je peux le corriger'
Tests.sequence_touches = [
  'oo',
  'oo',
  'so',
  'oo',
  'z', # pour s'arrêter de corriger
  'n', # pour ne pas enregistrer les changements
  'o', # pour confirmer le non enregistrement
  'q', # pour finir
]
res = run('proximite correct')
res = res.split(Tests.delimiteur_tableau)
puts "Nombre de tableaux : #{res.count}"
res.each do |tbl|
  puts tbl
  STDOUT.flush
end

# Le texte devrait avoir affiché la première correction à faire, c'est-à-dire le
# premier mot du texte qui est en proximité avec un autre.

# On cherche le premier mot en proximité
ipremier_mot = nil
TexteTest.mots.each do |imot|
  imot.prox_ids && imot.prox_ids[:apres] && begin
    ipremier_mot = imot
    break
  end
end
puts ipremier_mot.inspect
should_equal(ipremier_mot.class, Texte::Mot, 'Le premier mot a été trouvé')

fin_tests
