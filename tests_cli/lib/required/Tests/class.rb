# encoding: UTF-8
class Tests
  ERRORS = {
    'reponses-required' => 'Pour tester les programmes CLI, il faut définir les réponses successives en les définissant par `Tests.reponses=[\'réponse 1\', \'réponse 2\', etc.]` (dans l’ordre de leur utilisation).',
    'no-more-reponse'   => 'Il ne reste plus de réponse à prendre. Impossible de poursuivre.'
  }

class << self


  def init
    # Création du dossier contenant les fichier des tests, au besoin
    `mkdir -p "#{folder}"`
    File.exist?(path_reponses_file) && File.unlink(path_reponses_file)
    Log.init
  end

  # Retourne la prochaine réponse (toujours en String)
  def next_reponse
    File.exist?(path_reponses_file) || raise('reponses-required')
    reponses.empty? && raise('no-more-reponse')
    reponses.shift.to_s
  rescue Exception => e
    ERRORS.key?(e.message) && Tests::Log.error(ERRORS[e.message])
    Tests::Log.error(e)
  end

  # Les réponses définies dans les tests
  def reponses
    @reponses ||= begin
      File.exist?(path_reponses_file) && File.read(path_reponses_file).force_encoding('utf-8').split("\n")
    end
  end
  # Pour définir les réponses à simuler
  def reponses= value
    value.is_a?(Array) || raise('Tests.reponses= attend une liste de réponses, même s’il y a une seule réponse.')
    File.exist?(path_reponses_file) && File.unlink(path_reponses_file)
    File.open(path_reponses_file,'wb'){|f|f.write(value.join("\n"))}
  end

  def path_reponses_file
    @path_reponses_file ||= File.join(folder, 'reponses')
  end

  def folder
    @folder ||= './.tests_cli'
  end
end #/<< self
end #/Tests
