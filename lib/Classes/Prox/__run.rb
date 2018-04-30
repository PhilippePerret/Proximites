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
    while true
      runable? || return
      # Exécution de la commande demandée
      send(main_command.to_sym)
      # On referme le log de check si nécessaire
      Prox.log_check?     && Prox::LogCheck.close
      # Si l'option --test a été placée, on ne boucle pas
      CLI.options[:test]  && break
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
    # Fermer le log check s'il est actif
    Prox.log_check? && Prox::LogCheck.close
  end

  def wait_for_next_command
    next_command = nil
    command_in_histo = nil
    while true
      print "Commande suivante (#{'q'.jaune}, #{'z'.jaune} = terminer, #{'h'.jaune} = historique, #{'rien'.jaune} pour la même) : proximite[ #{command_in_histo}]"
      next_command = STDIN.gets.strip
      case next_command
      when 'q', 'z' then return
      when 'h'
        next_command = CLI.choose_from_historique
        next_command && break
      when ''
        next_command = command_in_histo ? command_in_histo : CLI.last_command
        break
      else break
      end
    end
    require './lib/required'
    @main_command = nil
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
    CLI.delete_last_in_historique
    error e.message
    # Quand on travaille le programme, pour voir le détail :
    # puts RET + e.backtrace.join("\n").rouge
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
