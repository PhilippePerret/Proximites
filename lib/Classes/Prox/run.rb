# encoding: UTF-8
=begin
  Module principal appelé par la commande `proximite` depuis proximite.rb

  ATTENTION : cette classe n'est pas à confondre avec la classe Promixity qui
  gère les proximités elles-mêmes.

=end
class Prox
class << self

  # = main =
  #
  # Méthode principale
  #
  # Le premier argument doit toujours être une commande qui est définie
  # dans le module class/Prox/commands
  #
  def run
    # marque_temps 'Démarrage du programme…'
    while true
      runable? || return
      # Exécution de la commande demandée
      send(main_command.to_sym)
      # Si l'option --test a été placée, on ne boucle pas
      CLI.options[:test] && break
      # On attend la prochaine commande
      wait_for_next_command || break
    end
  rescue Exception => e
    error e.message
    error e.backtrace.join("\n")
  ensure
    # Ce qu'il faut faire dans tous les cas, en cas d'erreur ou non
    # ---------------------------------------------------------------------
    # Enregistrer les configurations
    save_config
    # Fermer le fichier log
    Log.reflog.close
  end

  def wait_for_next_command
    print 'Commande suivante (q pour terminer, rien pour la même) : proximite '
    next_command = STDIN.gets.strip
    require './lib/required'
    next_command != 'q' || return
    @main_command = nil
    next_command != ''  || next_command = CLI.last_command
    CLI.analyse_command_line(next_command.split(' '))
    return true
  end

  # @retourne TRUE si le programme peut être lancé
  def runable?
    self.path || main_command == 'help' || begin
      raise "Le path du fichier ou le texte doivent impérativement être définis, sauf pour la commande `help`."
    end
    self.respond_to?(main_command.to_sym) || begin
      raise "La commande `#{main_command.inspect}` est indéfinie."
    end
    return true
  rescue Exception => e
    error e.message
    puts RET + e.backtrace.join("\n").rouge
    return false
  end

  def main_command
    @main_command ||= begin
      mc = (CLI.command || 'help')
      mc == 'aide' && mc == 'help'
      mc
    end
  end

end #/<< self
end #/Prox
