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
    case CLI.params[1]
    when 'proximites'
      Occurences.check_proximites
    else
      load_module 'texte/analyse'
      texte_courant.analyse
    end
    texte_courant.set_info(:last_command, ARGV.join(' '))
  end
  alias :analyse :check

  # Montre les informations d'occurence et de proximité du fichier donné
  # en argument
  def show
    show_informations
    texte_courant.set_info(:last_command, ARGV.join(' '))
  end
  # Raccourci pour `show proximites -i`
  def correct
    ARGV.each do |e| ARGV.delete(e) end
    ARGV.insert(0, 'show', 'proximites', '-i')
    CLI.params = [nil, 'proximites']
    CLI.options[:interactif] = true
    show
  end
  # raccourci 'prox[imite] texte'
  def texte
    ARGV[0] = 'show'
    ARGV.insert(1, 'texte')
    CLI.params.insert(1,'texte')
    show
  end

  # Affiches la liste des mots (uniques) en proximité, dans l'ordre alphabétique
  # et autres informations comme l'écart, etc.
  # Cette méthode répond donc à `prox proximites`
  def proximites
    # Charger toutes les données
    Proximity.display_informations
  end

  # Affichage des infos sur le texte (ne pas confondre avec les statistiques)
  def infos
    texte_courant.show_infos
  end

  def get
    case CLI.params[1]
    when 'infos'
      # Récupération des informations d'un autre fichier
      Texte.current.get_infos_from_file(CLI.params.pop)
    else
      error "Impossible de “getter” ça."
      CLI.delete_last_in_historique
    end
  end

  # Pour exécuter n'importe quel code
  def debug
    code = CLI.params[1]
    begin
      eval(code)
    rescue Exception => e
      puts "#{RET2}=== ERREUR EN ÉVALUANT LE CODE ==="
      puts e.message.rouge
      puts e.backtrace.join("\n").rouge
      puts "==========================================#{RET3}"
    end
  end

end #/<< self
end #/Prox
