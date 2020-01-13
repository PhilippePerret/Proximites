# encoding: UTF-8
#
# version 1.0.0
#
class Time
  class << self
    attr_reader :start_time_for_laps, :stop_time_for_laps
    #
    # @usage:
    #
    #     Time.start
    #     <code à exécuter et chronométrer>
    #     puts Time.laps
    #
    def start
      @start_time_for_laps = Time.now
    end
    def stop
      @stop_time_for_laps = Time.now
    end
    def laps
      Time.now.laps_from(start_time_for_laps)
    end

  end #/<< self

  # Retourne le laps de temps entre maintenant et le temps fourni en
  # argument.
  # @param {Time|Integer} +time+ Soit le temps, soit le nombre de secondes
  # @param {Hash} options Des options
  #
  def laps_from time, options = nil
    time.is_a?(Time) || time = Time.at(time)
    fr_time, to_time =
      if self > time
        # C'est un laps de temps passé
        [self, time]
      else
        # C'est un laps de temps dans le futur
        [time, self]
      end
    laps = to_time - fr_time
    return "#{laps.to_f} msecs"
  end

end #/Time
