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

  # Configuration (infos) qui peuvent être définies par les configurations
  # Cette méthode fonctionne dans les deux sens : lorsque les options sont
  # définies ou lorsque le fichier information est lu.
  def define_configuration
    saving_required = false

    # Définition des infos si nécessaire
    if CLI.options[:dmax_normale]
      d = CLI.options[:dmax_normale].to_i
      d > 50 || d = d * LONGUEUR_PAGE # valeur donnée en pages
      infos.merge!(dmax_normale: d)
      saving_required = true
    end
    if CLI.options[:dmax_possible]
      d = CLI.options[:dmax_possible].to_i
      d > 50 || d = d * LONGUEUR_PAGE # valeur fournie en pages
      infos.merge!(dmax_possible: d)
      saving_required = true
    end

    # "Chargement" des configurations si nécessaire
    info(:dmax_normale)  && Proximity.distance_max_normale  = info(:dmax_normale)
    info(:dmax_possible) && Proximity.distance_max_possible = info(:dmax_possible)

    saving_required && save_infos
  end

end #/Texte
