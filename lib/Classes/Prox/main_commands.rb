# encoding: UTF-8
=begin

  Module qui doit définir TOUTES (sans exception) les commandes principales
  qui peuvent suivre la commande `proximite` (alias `prox`)

  Dans ce fichier ne doivent être définies QUE les commandes, et rien d'autre,
  pour la clarté.
=end
class Prox
class << self

  # Affichage de l'aide
  # Avec l'option -prog, c'est l'aide de la programmation qui est affiché
  def help
    if CLI.options[:programmation]
      display_help_programmation
    else
      display_help
    end
  end
  alias :aide :help


  # Check d'un fichier dont le path doit être défini en argument.
  #
  def check
    Texte.current = CLI.params[1].strip_nil
    texte_courant.analyse
  end
  alias :analyse :check

  # Montre les informations d'occurence et de proximité du fichier donné
  # en argument
  def show
    show_informations
  end

end #/<< self
end #/Prox
