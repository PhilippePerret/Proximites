# encoding: UTF-8


# Pour charger un dossier ou un fichier du dossier ./lib/module
def load_module foo, options = nil ; Prox.load_module(foo, options) end

# Pour marquer le temps d'une opération, en console et dans le log de messages
def marque_temps operation
  @current_time ||= Time.now.to_f
  @current_op   ||= 0
  @current_op += 1
  just_now = Time.now.to_f
  laps = (just_now - @current_time).round(3)
  msg = "OP#{@current_op} #{operation}"
  msg =
  if @current_op > 1
    "OP#{@current_op - 1}: #{laps}secs".ljust(20)
  else
    ' '*20
  end + msg
  # On l'écrit en console et dans le fichier log
  CLI.verbose? && begin
    puts(msg)
    STDOUT.flush
  end
  log msg
end
