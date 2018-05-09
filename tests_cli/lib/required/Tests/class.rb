# encoding: UTF-8
require 'fileutils'

class Tests

  ERRORS = {
    'sequence_keys-required' => 'Pour tester les programmes CLI, il faut définir les réponses successives en les définissant par `Tests.sequence_touches=[\'réponse 1\', \'réponse 2\', etc.]` (dans l’ordre de leur utilisation).',
    'no-more-reponse'   => 'Il ne reste plus de réponse à prendre. Impossible de poursuivre.'
  }

class << self

  # Cette méthode est appelée au début des tests
  def init
    # Création du dossier contenant les fichier des tests, au besoin
    `mkdir -p "#{folder}"`
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
      Data[:sequence_keys] || raise('sequence_keys-required')
    end
  end
  alias :sequence_keys :sequence_touches

  # Pour définir les réponses à simuler
  def sequence_touches= value
    value.is_a?(Array) || raise('Tests.sequence_touches= attend une liste de réponses, même s’il y a une seule réponse.')
    Data.save(sequence_keys: value)
  end
  alias :sequence_keys= :sequence_touches=

  # Pour délimiter les retours successifs avec un délimiteur qui permettra de
  # tester plus facilement les résultats
  def delimiteur_tableau
    @delimiteur_tableau ||= Data[:delimiteur_tableau]
  end
  alias :delimiteur_tableaux :delimiteur_tableau

  # ---------------------------------------------------------------------
  #   Pour la gestion des "tableaux"
  #
  #   Rappel/principe : la sortie d'une commande se faisant en une seule
  #   fois dans un texte (grâce aux séquences de touches), on peut diviser
  #   la sortie en "tableaux" à l'aide du `Tests.delimiteur_tableau`.
  #   Grâce à cette méthode, on peut afficher tous les tableaux ou les
  #   récupérer
  # ---------------------------------------------------------------------
  # +res+ (String} est le retour offert par la command `run`.
  # Retourne les tableaux. Pour récupérer un tableau en particulier, on
  # peut donc faire :
  #     tableaux = Tests.tableaux_in(res)
  #     tableau = tableaux[x]
  def tableaux_in res
    res.split(delimiteur_tableaux)
  end
  # Cette méthode sert surtout à trouver le tableau concerné par le test,
  # avant de l'appeler par `Tests.tableaux_in(res)[x]`
  # +res+ {String} est le retour de la commande `run`
  def show_tableaux_in res
    header = ('-'*40) + (' TABLEAU INDEX %i ') + ('-'*40)
    footer = ('-'*40) + ('/Tableau index %i')  + ('-'*40)
    tableaux_in(res).each_with_index do |tbl, index_tableau|
      puts RET3 + (header % [index_tableau]) +
            RET2 + tbl + RET2 + (footer % [index_tableau])
    end
  end
  # ---------------------------------------------------------------------
  #   Paths
  # ---------------------------------------------------------------------

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

  # Le dossier des tests
  def folder
    @folder ||= './.tests_cli'
  end


end #/<< self
end #/Tests
