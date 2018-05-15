# encoding: UTF-8
class Tests
class << self
  def grand_titre msg
    Messages.add_suivi("*** #{msg.my_upcase} ***\n".jaune.gras)
  end
  def description msg
    Messages.add_suivi(msg.segmente(70, "\t\t").gris)
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

  # Méthode appelée par 'fin_tests(<option>)' à la fin des tests (ou même
  # ailleurs) pour écrire le résultat final et le log si demandé.
  # @param {NIL|Hash} options
  #         :display_log    Si true, affiche le log complet en fin de retour
  def fin options = nil
    options ||= Hash.new

    failure_list.empty? || begin
      failure_list.each do |err|
        puts err.rouge
      end
    end

    # À la fin des tests, on lit le fichier Tests::Log et si on trouve des
    # messages d'erreur, on les affiche.
    err_messages = Tests::Log.errors_messages
    sys_errors_encountered = !err_messages.empty?
    err_messages.empty? || begin
      puts RET2 + 'Le programme a rencontré les erreurs-système résumées ci-dessous :'.jaune
      Tests::Log.errors_messages.each do |err_msg|
        puts err_msg.rouge
      end
      puts RET2 + "Consulter le fichier #{File.expand_path('./tests_cli/tests.log').inspect} pour le détail.".jaune
    end

    puts RET3

    # Affichage du log si demandé
    options[:display_log] && begin
      puts "================= TEST LOG ================".jaune
      puts Tests::Log.read
      puts "(rechercher '= TEST LOG =' pour aller au début du log de test)"
      puts "================= /TEST LOG ================".jaune
      puts RET2
    end

    # On termine toujours par le nombre de réussites et d'échecs
    puts RET
    methode = failure_list.empty? ? :vert : :rouge
    puts "#{success_list.count} success  -  #{failure_list.count} failures".send(methode)
    sys_errors_encountered && puts('(des erreurs système ont été rencontrées… cf. ci-dessus)')
    puts RET3

  end
  # /fin

end #/<< self
end #/Messages
end #/Tests
