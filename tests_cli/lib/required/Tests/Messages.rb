# encoding: UTF-8
class Tests
class << self
  def grand_titre msg
    Messages.add_suivi("*** #{msg.my_upcase} ***\n".jaune.gras)
  end
  def titre msg
    Messages.add_suivi("\n  * #{msg}".jaune)
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
    suivi_temp_reel? && puts(msg)
  end

  # TODO Pouvoir régler sur une autre valeur
  def suivi_temp_reel?
    @is_suivi_temp_reel === nil || (return @is_suivi_temp_reel)
    @is_suivi_temp_reel = true
  end

  def evaluate ok, mess_if_err, mess_if_ok, actual, expected
    if ok
      success(mess_if_ok)
    else
      failure(mess_if_err, expected, actual)
    end
  end

  def success msg
    @success_count += 1
    @success_list << msg
    add_suivi("      #{msg.vert}")
    suivi_temp_reel? || begin
      print '*'.vert
      STDOUT.flush # mais ne fonctionne pas sans retour chariot
    end
  end

  def failure err, expected, actual
    @failure_count += 1
    err = err % {actual: actual, expected: expected}
    @failure_list << err
    add_suivi("      #{err.rouge}")
    suivi_temp_reel? || begin
      print 'F'.rouge
      STDOUT.flush # mais ne fonctionne pas sans retour chariot
    end
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

    # Écriture du suivi
    # Maintenant, je le mets en direct à l'écran
    # if defined?(DETAILED) && DETAILED
    #   unless suivi.empty?
    #     suivi.each do |msg|
    #       puts "#{msg}"
    #     end
    #   end
    # end

    # À la fin des tests, on lit le fichier Tests::Log et si on trouve des
    # messages d'erreur, on les affiche.
    Tests::Log.errors_messages.each do |err_msg|
      puts err_msg.rouge
    end

    puts "\n\n\n"

  end
  # /fin

end #/<< self
end #/Messages
end #/Tests
