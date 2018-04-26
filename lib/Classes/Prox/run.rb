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
    marque_temps 'Démarrage du programme…'
    self.respond_to?(main_command.to_sym) || begin
      error "La commande `#{main_command.inspect}` est indéfinie."
    end
    # Sinon, on joue la commande
    send(main_command.to_sym)
  rescue Exception => e
    error e.message
    error e.backtrace.join("\n")
  ensure
    # Ce qu'il faut faire dans tous les cas, en cas d'erreur ou non
    # ---------------------------------------------------------------------
    # Fermer le fichier log
    Log.reflog.close
  end

  def main_command
    @main_command ||= (CLI.command || 'help')
  end

end #/<< self
end #/Prox
