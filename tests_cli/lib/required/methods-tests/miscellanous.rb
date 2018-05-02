# encoding: UTF-8

# Jouer une commande et retourner le résultat produit à l'écran
# On peut le tester ensuite avec `retour_contient` `retour_ne_contient_pas`
# On peut passer la séquence de touches en second argument.
def run cmd, sequence_keys = nil
  sequence_keys.nil? || Tests.sequence_keys= sequence_keys
  Tests::Messages.add_suivi("    Commande : `#{cmd}`")
  cmd = cmd.sub(/^prox(imite)?/,'proximite --test ')
  cmd = cmd.gsub(/\"/, '\\\"')
  res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}"`

  # On s'assure d'avoir bien atteint la fin du programme en cherchant la marque
  # `EOP` à la toute fin du fichier log. Si le programme ne le fait pas encore,
  # on lui conseille de le faire.
  Tests.confirm_program_end

  # quiet || puts(res)

  # On supprime toujours les couleurs, pour pouvoir étudier les textes
  # correctement, entendu que les couleurs sont aléatoires, ou presque
  # TODO Plus tard, pouvoir demander à tester de façon brute, sans suppression
  # des couleurs, pour voir si elles sont bien mises.
  # puts "char avant gsub"
  # res.each_char do |b| puts b end
  # puts "Nombre de caractères avant gsub : #{res.length}"
  res = res.sans_couleur
  # puts "Nombre de caractères APRÈS gsub : #{res.length}"
  # puts "char APRÈS gsub"
  # res.each_char do |b| puts b end

  # On retire les retours chariots vides, mais pas les tabulations et
  # autres espaces
  res = res.gsub(/\n\n+/,"\n").gsub(/^\n+/,'').gsub(/\n+$/,'')

  self.test_retour = res
  return res
end

def fin_tests options = nil
  Tests::Messages.fin(options)
end
