# encoding: UTF-8
class Tests
  ERRORS = {
    'reponses-required' => 'Pour tester les programmes CLI, il faut définir les réponses successives en les définissant par `Tests.sequence_touches=[\'réponse 1\', \'réponse 2\', etc.]` (dans l’ordre de leur utilisation).',
    'no-more-reponse'   => 'Il ne reste plus de réponse à prendre. Impossible de poursuivre.'
  }

class << self


  def init
    # Création du dossier contenant les fichier des tests, au besoin
    `mkdir -p "#{folder}"`
    File.exist?(path_reponses_file) && File.unlink(path_reponses_file)
    Log.init
    Messages.init
  end

  # Retourne la prochaine réponse (toujours en String) définie dans la
  # séquence de touches donnée au test.
  def next_touche options = nil
    options ||= Hash.new
    Tests::Log << "-> next_touche (réponses restantes : #{reponses.inspect})"
    reponses.empty? && raise('no-more-reponse')
    rep = reponses.shift

    # Réponse temporisée
    rep.is_a?(Array) && begin
      rep, attente = rep
      Tests::Log << "Réponses temporisée (#{attente} secondes)"
      sleep attente
    end

    # On retourne toujours une réponse en string, même quand c'est un nombre ou
    # un true/false/nil
    rep = rep.to_s

    Tests::Log << "Réponse retournée pour #{options[:from].sans_couleur} : #{rep.inspect} (nouvelles réponses restants : #{reponses.inspect})"
    rep
  rescue Exception => e
    ERRORS.key?(e.message) && Tests::Log.error(ERRORS[e.message])
    Tests::Log.error(e)
  end
  alias :next_key :next_touche

  # Les réponses définies dans les tests
  def sequence_touches
    @sequence_touches ||= begin
      File.exist?(path_reponses_file) || raise('reponses-required')
      File.read(path_reponses_file).force_encoding('utf-8').split("\n")
    end
  end
  alias :sequence_keys :sequence_touches

  # Pour définir les réponses à simuler
  def sequence_touches= value
    value.is_a?(Array) || raise('Tests.sequence_touches= attend une liste de réponses, même s’il y a une seule réponse.')
    File.exist?(path_reponses_file) && File.unlink(path_reponses_file)
    File.open(path_reponses_file,'wb'){|f|f.write(value.join("\n"))}
  end
  alias :sequence_keys= :sequence_touches=

  def path_reponses_file
    @path_reponses_file ||= File.join(folder, 'reponses')
  end

  # Le dossier des tests
  def folder
    @folder ||= './.tests_cli'
  end

  # Le path du texte courant
  def current_texte_path
    config = File.open('./.config.msh','rb'){|f|Marshal.load(f)}
    config[:last_file_path]
  end
  # Le path du dossier de texte courant
  def current_folder_proximites
    ctp = current_texte_path
    File.join(File.dirname(ctp), "proximites-#{File.basename(ctp,File.extname(ctp))}")
  end


end #/<< self
end #/Tests
