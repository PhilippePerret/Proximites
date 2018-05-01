# encoding: UTF-8
class Tests
class << self
  def titre msg
    Messages.add_suivi("*** #{msg}".gras)
  end
end #/<< self
class Messages
class << self

  attr_reader :suivi
  attr_reader :failure_list, :success_list
  attr_reader :failure_count, :success_count

  def init
    @suivi = Array.new
    @success_count  = 0
    @failure_count  = 0
    @failure_list   = Array.new
    @success_list   = Array.new
  end

  def add_suivi msg
    @suivi << msg
  end

  def evaluate ok, mess_if_err, mess_if_ok, actual, expected
    if ok
      success mess_if_ok
    else
      failure(mess_if_err, expected, actual)
    end
  end

  def success msg
    @success_count += 1
    @success_list << msg
    @suivi << msg.vert
    print '*'.vert
    STDOUT.flush # mais ne fonctionne pas sans retour chariot
  end

  def failure err, expected, actual
    @failure_count += 1
    err = err % {actual: actual, expected: expected}
    @failure_list << err
    @suivi << err.rouge
    print 'F'.rouge
    STDOUT.flush # mais ne fonctionne pas sans retour chariot
  end

  def fin
    puts "\n\n\n"
    methode = failure_list.empty? ? :vert : :rouge
    puts "#{success_list.count} success  -  #{failure_list.count} failures".send(methode)
    puts "\n\n"
    unless failure_list.empty?
      failure_list.each do |err|
        puts err.rouge
      end
    end
    if defined?(DETAILED) && DETAILED
      unless suivi.empty?
        suivi.each do |msg|
          puts "\t#{msg}"
        end
      end
    end

    # À la fin des tests, on lit le fichier Tests::Log et si on trouve des
    # messages d'erreur, on les affiche.
    Tests::Log.display_errors_messages
  end
end #/<< self
end #/Messages
end #/Tests
