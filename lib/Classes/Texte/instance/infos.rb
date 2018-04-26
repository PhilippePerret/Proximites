# encoding: UTF-8
class Texte


  # Retourne l'information de clé +key+
  def info key
    return infos[key]
  end

  # Définit et enregistre l'information de clé +key+ avec la valeur +value+
  def set_info key, value = nil
    case key
    when Hash
      key.each { |k,v| infos.merge!(k => v) }
    else
      infos[key] = value
    end
    save_infos
  end

  # Les infos du texte courant
  def infos
    @infos ||= load_infos
  end

  # Permet d'afficher les infos avec la commande :
  # prox infos
  def show_infos
    puts RET2 + "=== INFOS SUR LE TEXTE ===" + RET2
    infos.each do |key, value|
      puts "#{key.to_s.ljust(28)} : #{value.inspect}"
    end
    puts RET3
  end

  def save_infos
    File.exist?(path_file_infos) && File.unlink(path_file_infos)
    File.open(path_file_infos,'wb'){|f|Marshal.dump(infos,f)}
  end

  def load_infos
    if File.exists?(path_file_infos)
      File.open(path_file_infos,'rb'){|f|Marshal.load(f)}
    else
      Hash.new()
    end
  end

end #/Texte
