# encoding: UTF-8
class Prox
class << self

  # Pour obtenir une valeur de configuration.
  # Usage :
  #   Prox.config(<key dans configuration>)
  # Équivalen à :
  #   Prox.configuration[<key configuration>]
  #
  def config key
    configuration[key]
  end


  def configuration
    @configuration ||= begin
      if File.exist?(path_file_config)
        File.open(path_file_config,'rb'){|f| Marshal.load(f)}
      else
        {
          last_use:       nil, # dernière utilisation ({Time})
          last_file_path: nil, # le dernier path du fichier analysé
          last_command:   nil   # Dernière commande utilisé
        }
      end
    end
  end

  # On sauve la configuration en prenant les valeurs courantes
  # Cette méthode est appelée en fin de programme.
  def save_config
    configuration.merge!({
      last_use:       Time.now,
      last_command:   ARGV.join(' '),
      last_file_path: path
    })
    File.open(path_file_config,'wb'){|f| Marshal.dump(configuration,f)}
  end

  # Path au fichier contenant la configuration (fichier Marshal)
  def path_file_config
    @path_file_config ||= begin
      defined?(THISFOLDER) || raise('THISFOLDER devrait être défini…')
      File.join(THISFOLDER,'.config.msh')
    end
  end


end #/<< self
end #/Prox
