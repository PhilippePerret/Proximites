# encoding: UTF-8
class Prox
class << self

  def tableau_help_programmation
    <<-EOT

=== AIDE À LA PROGRAMMATION DE LA COMMANDE proximite (alias prox) ===

  PRINCIPES
  ---------

    * Le deuxième argument est toujours une commande.
    * Cette commande doit toujours être une méthode du module
      `class/Prox/main_commands.rb`


  CHARGEMENT DES MODULES
  ----------------------

  Les modules du dossier `./lib/module` peuvent être chargés à l'aide de la
  méthode `load_module` (handy méthode raccourcie de `Prox.load_module`)
  Ça peut être un simple fichier ou un dossier dont on charge tous les éléments.

  DIVERS
  ------

  Pour savoir si c'est le mode verbeux, utiliser `CLI.verbose?`
  
    EOT
  end

end #/<< self
end #/Prox
