# encoding: UTF-8
class Fixnum

  # Reçoit un nombre de secondes et retourne un string de la forme "h:mm:ss"
  def as_horloge
    hrs = self / 3600
    rest = self % 3600
    mns = (rest / 60).to_s.rjust(2,'0')
    scs = (rest % 60).to_s.rjust(2,'0')
    "#{hrs}:#{mns}:#{scs}"
  end

  # Formate le nombre en bons milliers
  def mille
    self > 9999 || (return self)
    case
    when self < 10000
      return self.to_s
    when self < 999999
      s = self.to_s.rjust(6,'0')
      return "#{s[0..2].to_i} #{s[3..5]}"
    when self < 999999999
      s = self.to_s.rjust(9,'0')
      return "#{s[0..2].to_i} #{s[3..5]} #{s[6..8]}"
    else
      return self.to_s
    end
  end

  # Retourne la durée en jours et en heure de travail en comptant +hours_per_day+
  # heures de travail par jour.
  def as_workdays hours_a_day = 10
    rest = self
    jrs  = rest / (hours_a_day * 3600)
    rest = rest - (jrs * hours_a_day * 3600)
    hrs  = rest / 3600
    "#{jrs} jr#{jrs > 1 ? 's' : ''} #{hrs} hr#{hrs > 1 ? 's' : ''} à raison de #{hours_a_day} hrs/jour"
  end

  # Retourne la durée d'après le nombre de secondes
  def as_duree
    secs = self % 60
    rest = self - secs
    str = "#{secs}”"
    rest > 0 || (return str)
    mins = (rest % 3600) / 60
    rest = rest - (mins * 60)
    str = "#{mins} m#{mins > 1 ? 's' : ''} #{str}"
    rest > 0 || (return str)
    hrs  = (rest % (24 * 3600)) / 3600
    rest = rest - (hrs * 3600)
    str = "#{hrs} h#{hrs > 1 ? 's' : ''} #{str}"
    rest > 0 || (return str)
    jrs = rest / (24 * 3600)
    return "#{jrs} j#{jrs > 1 ? 's' : ''} #{str}"
  end

  # Retourne le floatant sous forme de pourcentage ou de pourmillage
  # Note : la méthode existe aussi pour les flottants (plus précise)
  # Rappel : pour obtenir le pourcentage, on fait <nombre>/<nombre total>
  def pourcentage pour_mille = false
    "#{self * 100} #{pour_mille ? '‰' : '%'}"
  end

end #/Fixnum
