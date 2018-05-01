# encoding: UTF-8
class Tests
class << self


  def init
    # Création du dossier contenant les fichier des tests, au besoin
    `mkdir -p ./.tests`
    Log.init
  end

  def next_reponse
    self.reponses || raise('Pour tester les programmes CLI, il faut définir les réponses successives en les mettant dans la liste Array `CLI_REPONSES` (dans l’ordre de leur utilisation).')
    reponses.empty? && raise('Il ne reste plus de réponse à prendre. Impossible de continuer.')
    reponses.shift
  end

  # Les réponses définies dans les tests
  def reponses
    @reponses ||= begin
      File.exist?(path_reponses_file) && begin
        File.read(path_reponses_file).force_encoding('utf-8').split("\n")
      end
    end
  end
  # Pour définir les réponses à simuler
  def reponses= value
    value.is_a?(Array) || raise('Tests.reponses= attend une liste de réponses, même s’il y a une seule réponse.')
    File.exist?(path_reponses_file) && File.unlink(path_reponses_file)
    File.open(path_reponses_file,'wb'){|f|f.write(value.join("\n"))}
  end

  def path_reponses_file
    @path_reponses_file ||= './.tests/reponses'
  end
end #/<< self
end #/Tests
