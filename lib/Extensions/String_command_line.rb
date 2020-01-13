# encoding: UTF-8
#
# version 1.2.1
#
class String

  def codeColorFor(couleur, format)
    case format
    when 'html'
      self.send("#{couleur}_html".to_sym)
    when 'console'
      self.send(couleur.to_sym)
    end
  end

  # Le texte en bleu gras pour le terminal
  def bleu_gras
    "\033[1;96m#{self}\033[0m"
  end
  def bleu_gras_html
    "<span style=\"color:blue;font-weight:bold;\">#{self}</span>"
  end
  # Le texte en bleu gras pour le terminal
  def bleu
    "\033[0;96m#{self}\033[0m"
    # 96=bleu clair, 93 = jaune, 94/95=mauve, 92=vert
  end
  def bleu_html
    "<span style=\"color:blue;\">#{self}</span>"
  end
  def mauve
    "\033[1;94m#{self}\033[0m"
  end
  def mauve_html
    "<span style=\"color:purple;\">#{self}</span>"
  end

  def fond1
    "\033[38;5;8;48;5;45m#{self}\033[0m"
  end
  def fond1_html
    "<span style=\"background-color:red;color:white;\">#{self}</span>"
  end
  def fond2
    "\033[38;5;8;48;5;40m#{self}\033[0m"
  end
  def fond2_html
    "<span style=\"background-color:green;color:white;\">#{self}</span>"
  end
  def fond3
    "\033[38;5;0;48;5;183m#{self}\033[0m"
  end
  def fond3_html
    "<span style=\"background-color:blue;color:white;\">#{self}</span>"
  end
  def fond4
    "\033[38;5;15;48;5;197m#{self}\033[0m"
  end
  def fond4_html
    "<span style=\"background-color:purple;color:white;\">#{self}</span>"
  end
  def fond5
    "\033[38;5;15;48;5;172m#{self}\033[0m"
  end
  def fond5_html
    "<span style=\"background-color:orange;color:white;\">#{self}</span>"
  end

  def jaune
    "\033[0;93m#{self}\033[0m"
  end
  def jaune_html
    "<span style=\"color:yellow;\">#{self}</span>"
  end

  def vert
    "\033[0;92m#{self}\033[0m"
  end
  def vert_html
    "<span style=\"color:green;\">#{self}</span>"
  end

  # Le texte en rouge gras pour le terminal
  def rouge_gras
    "\033[1;31m#{self}\033[0m"
  end
  def rouge_gras_html
    "<span style=\"color:red;font-weight:bold;\">#{self}</span>"
  end

  # Le texte en rouge gras pour le terminal
  def rouge
    "\033[0;91m#{self}\033[0m"
  end
  def rouge_html
    "<span style=\"color:red;\">#{self}</span>"
  end

  def rouge_clair
    "\033[0;35m#{self}\033[0m"
  end
  def rouge_clair_html
    "<span style=\"color:#FF8888;\">#{self}</span>"
  end

  def gris
    "\033[0;90m#{self}\033[0m"
  end
  def gris_html
    "<span style=\"color:grey;\">#{self}</span>"
  end

  # Le texte en gras pour le terminal
  def gras
    "\033[1m#{self}\033[0m"
  end

  # Le string dont on a retiré les couleurs
  def sans_couleur
    self.gsub(/\e\[(.*?)m/,'').gsub(/\\e\[(.*?)m/,'')
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

  def underlined with = '-', heading = ''
    return "#{self}\n#{heading}#{with * self.length}"
  end

  # truncate le texte
  def segmente longueur, heading = ''
    li  = Array.new
    # Il faut traiter le cas où le texte contient des retours chariots
    self.split(RET).each do |seg|
      while seg.length > longueur
        ri = seg.rindex(' ', longueur)
        ri || break
        li << seg[0..ri]
        seg = seg[ri+1..-1]
      end
      seg.length > 0 && li << seg
    end
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
    self
      .force_encoding('utf-8')
      .gsub(/[œŒæÆ]/,{'œ'=>'oe', 'Œ' => 'Oe', 'æ'=> 'ae', 'Æ' => 'Ae'})
      .tr(DATA_NORMALIZE[:from], DATA_NORMALIZE[:to])
  end
  alias :normalized :normalize

end
