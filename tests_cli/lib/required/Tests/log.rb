# encoding: UTF-8
=begin

  ATTENTION : CE MODULE EST AUSSI CHARGÉ PAR L'APPLICATION EN MODE TEST

=end
class Tests
class Log
class << self

  attr_reader :reflog

  # Pour écrire un message dans le fichier log, que ce soit dans les tests ou
  # dans l'application.
  # @usage : Tests::Log << "messages"
  #
  def << mess
    open() ; reflog.puts(mess) ; close()
  end
  alias :write :<<

  # Pour écrire une erreur
  def error err
    err.is_a?(String) || begin
      err = err.message + "\n\n" + err.backtrace.join("\n")
    end
    write('###ERROR: ' + "#{err}".rouge)
  end

  # Méthode appelée à la fin des tests, qui lit le fichier log pour voir
  # s'il y a des messages d'erreur et les affiche le cas échéant
  def display_errors_messages
    erreur_trouvee = false
    errors_str = lines.collect do |line|
      line.start_with?('###ERROR:') || next
      erreur_trouvee = true
      line
    end.compact
    if erreur_trouvee
      puts "\n\nDes erreurs ont été rencontrées :\n\n"
      puts errors_str
      puts "\n\nPour voir le détail des erreurs (backtraces), consulter le fichier #{pathlog.inspect}.\n\n"
    end
  end

  # Retourne la dernière ligne enregistrées
  def last_line
    lines.last
  end
  # Toutes les lignes du fichier log qui peut être alimenté soit par
  # l'application soit par les commandes de test.
  def lines
    read.split("\n")
  end

  def read
    File.open(pathlog,'rb'){|f| f.read.force_encoding('utf-8')}
  end

  def open
    @reflog = File.open(pathlog,'a')
  end
  def close
    reflog.close
  end

  def init
    File.exist?(pathlog) && File.unlink(pathlog)
  end

  def pathlog
    @pathlog ||= File.join(Tests.folder, 'tests.log')
  end
end#<<self
end#/Log
end#/Tests
