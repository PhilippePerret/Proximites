# encoding: UTF-8

# Jouer une commande et retourner le résultat produit à l'écran
# On peut passer la séquence de touches en second argument.
def run cmd, sequence_keys = nil
  # Initialisation du résultat
  Tests.resultat_final = nil
  # La séquence de touches doit être définie
  sequence_keys.nil? || Tests.sequence_keys= sequence_keys
  Tests::Messages.add_suivi("    Commande : `#{cmd}`")
  # On ajoute toujours l'option --test pour indiquer à l'application que
  # c'est un test.
  cmd += ' --test'
  cmd = cmd.gsub(/\"/, '\\\"')


  # === Évaluation du code/Lancement de l'application ===
  res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}"`

  # On s'assure d'avoir bien atteint la fin du programme en cherchant la marque
  # `EOP` à la toute fin du fichier log. Si le programme ne le fait pas encore,
  # on lui conseille de le faire.
  Tests.confirm_program_end

  # quiet || puts(res)

  # On supprime toujours les couleurs, pour pouvoir étudier les textes
  # correctement, entendu que les couleurs sont aléatoires, ou presque
  res = res.sans_couleur

  # On retire les retours chariots vides, mais pas les tabulations et
  # autres espaces
  res = res.gsub(/\n\n+/,"\n").gsub(/^\n+/,'').gsub(/\n+$/,'')

  Tests.resultat_final= res

  return res
end

def fin_tests options = nil
  Tests::Messages.fin(options)
end
