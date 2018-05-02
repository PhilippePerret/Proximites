# encoding: UTF-8
require 'fileutils'

class Tests

  ERRORS = {
    'sequence_keys-required' => 'Pour tester les programmes CLI, il faut définir les réponses successives en les définissant par `Tests.sequence_touches=[\'réponse 1\', \'réponse 2\', etc.]` (dans l’ordre de leur utilisation).',
    'no-more-reponse'   => 'Il ne reste plus de réponse à prendre. Impossible de poursuivre.'
  }

class << self

  # Pour ré-initialiser, notamment pour supprimer le dossier `./.texte_prov`
  # s'il existe
  def reset
    File.exist?('./.texte_prov') && FileUtils.rm_rf('./.texte_prov')
  end

  def init
    # Création du dossier contenant les fichier des tests, au besoin
    `mkdir -p "#{folder}"`
    File.exist?(path_sequence_keys_file) && File.unlink(path_sequence_keys_file)
    Log.init
    Messages.init
  end

  # Méthode qui confirme la fin du programme (pour s'assurer, notamment, que
  # la séquence des touches est complète)
  def confirm_program_end
    Log.last_line == 'EOP' && return
    error 'Le programme ne semble pas être arrivé à son terme '+
    '(manque la marque EOP à la fin du fichier log).'+
    ' Assurez-vous que la séquence de touches soit complète et/ou'+
    ' placez le code `Tests::Log << \'EOP\'` à la toute fin du programme.'+
    "#{RETDT}(dernière ligne : #{Log.last_line})"
  end

  # Retourne la prochaine réponse (toujours en String) définie dans la
  # séquence de touches donnée au test.
  def next_touche options = nil
    options ||= Hash.new
    sequence_keys.empty? && raise('no-more-reponse')

    # On prend la touche suivant en la retirant de la liste
    rep = sequence_keys.shift

    # Réponse temporisée
    if rep.is_a?(Array)
      rep, attente = rep
      Tests::Log << "Réponses temporisée (#{attente} secondes)"
      sleep attente.to_f
    else
      # On s'arrête toujours un dixième de seconde pour simuler l'entrée
      # à la console.
      sleep 0.1
    end

    # On retourne toujours une réponse en string, même quand c'est un nombre ou
    # un true/false/nil
    rep = rep.to_s

    Tests::Log << "[Tests::next_touche] #{rep.inspect} en réponse à #{options[:from].sans_couleur} (touches restantes : #{sequence_keys.inspect})"

    # On retourne vraiment la réponse
    rep
  rescue Exception => e
    ERRORS.key?(e.message) && Tests::Log.error(ERRORS[e.message])
    Tests::Log.error(e)
  end
  alias :next_key :next_touche

  # Les réponses définies dans les tests
  def sequence_touches
    @sequence_touches ||= begin
      File.exist?(path_sequence_keys_file) || raise('sequence_keys-required')
      # File.read(path_sequence_keys_file).force_encoding('utf-8').split("\n")
      eval(File.read(path_sequence_keys_file))
    end
  end
  alias :sequence_keys :sequence_touches

  # Pour définir les réponses à simuler
  def sequence_touches= value
    value.is_a?(Array) || raise('Tests.sequence_touches= attend une liste de réponses, même s’il y a une seule réponse.')
    File.exist?(path_sequence_keys_file) && File.unlink(path_sequence_keys_file)
    File.open(path_sequence_keys_file,'wb'){|f|f.write(value.inspect)}
  end
  alias :sequence_keys= :sequence_touches=

  def path_sequence_keys_file
    @path_sequence_keys_file ||= File.join(folder, 'sequence_keys')
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
