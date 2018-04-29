# encoding: UTF-8
# ---------------------------------------------------------------------
#   Classe log
# ---------------------------------------------------------------------
class Prox
class LogCheck
class << self

  attr_reader :start_time
  attr_reader :current_time
  attr_reader :last_message
  attr_reader :last_time_operation

  # Pour ajouter un message
  def mess mess, is_operation = nil
    last_message && puts_last_message
    @last_message = {message: mess, time: Time.now.to_f, is_operation: !!is_operation}
  end

  def close
    # Écrire le dernier message en comptant les temps
    puts_last_message
    # Fermer le fichier du log-check
    reffile.close
    # Pour pouvoir le ré-ouvrir si nécessaire
    @reffile = nil
  end

  # Le fichier est fermé après chaque commande, pour pouvoir notamment le
  # lire. Il faut donc pouvoir le ré-ouvrir.
  def init
    File.exist?(path_file) && File.unlink(path_file)
    reffile
  end

  def puts_last_message
    last_message || return
    lm_time = last_message[:time]
    laps_time = laps(lm_time)
    if last_message[:is_operation]
      last_time_operation && laps_time = (lm_time - last_time_operation).to_i.as_horloge
      @last_time_operation = lm_time
    end

    # Laps de temps depuis le début, comme une horloge et seulement si c'est
    # une opération.
    depuis_debut = last_message[:is_operation] ? from_start(lm_time).as_horloge : ''

    messages = last_message[:message]
    messages.is_a?(Array) || messages = [messages]
    mess_str = messages.shift
    messages.each do |mess|
      mess_str << ' '*(18) + mess
    end

    reffile.puts "#{depuis_debut.ljust(9)}#{laps_time.to_s.ljust(9)}#{mess_str}"
  end

  def show
    File.exist?(path_file) || begin
      error "Aucun fichier de log de check n'existe.#{RETDT}Pour le créer, lancer le check avec l'option `--log`."
      return
    end
    puts File.read(path_file)
  end

  def from_start(time)
    @start_time ||= Time.now.to_i
    time.to_i - start_time
  end
  def laps(time)
    @current_time ||= Time.now.to_f
    laps = ((time - @current_time) * 100).round(3)
    @current_time = time
    return laps
  end

  def reffile
    @reffile ||= begin
      rf = File.open(path_file,'a')
      rf.puts "#{RET3}LOG CHECK DU #{Time.now}#{RET2}"
      rf
    end
  end

  # Fichier qui contient, si l'option --log est demandée, tous les choix qui
  # sont opérés pour déterminer la proximité ou non.
  def path_file
    @path_file ||= File.join(Prox.folder,'check.log')
  end
end#/<< self
end#/LogCheck
end #/ Prox
