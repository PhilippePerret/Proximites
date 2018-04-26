# encoding: UTF-8
class Fixnum

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

end #/Fixnum
