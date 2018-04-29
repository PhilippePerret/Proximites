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


  # Méthode répondant à la commande `prox get infos <path/to>` qui permet de
  # récupérer des informations d'un autre fichier, d'une autre analyse.
  def get_infos_from_file(from_path)
    File.exist?(from_path) || raise("Le fichier #{from_path.inspect} n'existe pas.")
    # Si c'est le dossier qui a été transmis, on cherche le fichier infos.
    if File.directory?(from_path)
      from_path = File.join(from_path, 'infos.msh')
      File.exist?(from_path) || raise("Impossible de trouver le fichier `infos.msh` dans le dossier.")
    else
      # C'est le fichier texte qui a été transmis
      dossier = File.dirname(from_path)
      affixe  = File.basename(from_path, File.extname(from_path))
      from_path = File.join(dossier, "proximites-#{affixe}", 'infos.msh')
      File.exist?(from_path) || raise("Le fichier #{from_path.inspect} n'existe pas.")
    end
    # On peut charger les infos
    new_infos = File.open(from_path,'rb'){|f|Marshal.load(f)}

    # On définit les nouvelles informations en supprimant les clés inutiles
    [:file_path, :last_analyse, :last_command].each { |k| new_infos.delete(k) }

    if new_infos.empty?
      notice "Aucune information récupérée de l'analyse spécifiée."
    else
      infos.merge!(new_infos)
      save_infos
      notice "Informations récupérées avec succès."
      show_infos
    end
  rescue Exception => e
    error "#{e.message} Impossible de charger les informations voulues."
  end

end #/Texte
