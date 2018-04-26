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
    CLI.options[:programmation] ? display_help_programmation : display_help
  end
  alias :aide :help


  # Check d'un fichier dont le path doit être défini en argument.
  #
  def check
    texte_courant.set_info(:last_command, ARGV.join(' '))
    texte_courant.analyse
  end
  alias :analyse :check

  # Montre les informations d'occurence et de proximité du fichier donné
  # en argument
  def show
    texte_courant.set_info(:last_command, ARGV.join(' '))
    show_informations
  end

  # Affichage des infos sur le texte (ne pas confondre avec les statistiques)
  def infos
    texte_courant.show_infos
  end

end #/<< self
end #/Prox
