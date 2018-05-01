# encoding: UTF-8

# Jouer une commande et retourner le résultat produit à l'écran
# On peut le tester ensuite avec `retour_contient` `retour_ne_contient_pas`
def run cmd
  Tests::Messages.add_suivi("Commande jouée : `#{cmd}`")
  cmd = cmd.sub(/^prox(imite)?/,'proximite --test ')
  res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}"`
  # quiet || puts(res)
  self.test_retour = res
  return res
end

def fin_tests
  Tests::Messages.fin
end
