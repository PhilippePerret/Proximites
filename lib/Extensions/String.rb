# encoding: UTF-8
class String

  # Le texte en bleu gras pour le terminal
  def bleu_gras
    "\033[1;96m#{self}\033[0m"
  end
  # Le texte en bleu gras pour le terminal
  def bleu
    "\033[0;96m#{self}\033[0m"
    # 96=bleu clair, 93 = jaune, 94/95=mauve, 92=vert
  end

  def jaune
    "\033[0;93m#{self}\033[0m"
  end

  # Le texte en rouge gras pour le terminal
  def rouge_gras
    "\033[1;31m#{self}\033[0m"
  end

  # Le texte en rouge gras pour le terminal
  def rouge
    "\033[0;91m#{self}\033[0m"
  end

  def gris
    "\033[0;90m#{self}\033[0m"
  end

  # Le texte en gras pour le terminal
  def gras
    "\033[1m#{self}\033[0m"
  end

  # Méthode qui strip la chaine courante mais renvoie NIL si elle est vide.
  def strip_nil
    s = self.strip
    s == '' ? nil : s
  end

  # Self est de la forme JJ/MM/YYYY et la méthode renvoie le
  # nombre de secondes correspondantes
  def as_seconds
    jrs, mois, ans = self.split('/').collect{|e| e.strip.to_i}
    return Time.new(ans, mois, jrs, 0,0,0).to_i
  end
  alias :to_seconds :as_seconds

  # truncate le texte
  def segmente longueur, heading = ''
    li  = Array.new
    seg = self
    while seg.length > longueur
      ri = seg.rindex(' ', longueur)
      li << seg[0..ri]
      seg = seg[ri+1..-1]
    end
    seg.length > 0 && li << seg
    return heading + li.join("\n#{heading}")
  end

  # Transformer les caractères diacritiques et autres en ASCII
  # simples
  unless defined? DATA_NORMALIZE
    DATA_NORMALIZE = {
      :from => "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
      :to   => "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
    }
  end
  # ou def normalized
  def normalize
    self.force_encoding('utf-8').tr(DATA_NORMALIZE[:from], DATA_NORMALIZE[:to])
  end

end
