# encoding: UTF-8
class Prox
class << self

  # Main méthode pour montrer les informations concernant un fichier
  # donné en argument, qui doit obligatoirement exister.
  def show_informations
    suivi '-> Prox#show_informations'
    texte_courant.has_file? || begin
      error "Il faut impérativement donner le path d'un texte existant en dernier argument."
      return
    end

    # Ce qu'il faut afficher
    what = CLI.params[1].strip_nil

    what || begin
      error "Il faut indiquer ce qu'il faut montrer, parmi :" +
        "#{RETDT}\t* show occurences#{RETDT}\t* show proximites#{RETDT}\t* show stats"
      return
    end

    # Charger les mots et les occurences
    texte_courant.load_mots_et_occurences

    case what
    when 'proximites', 'proximité', 'proximités'
      texte_courant.show_proximites
    when 'occurences', 'occurence'
      Occurences.show
    when 'stats', 'statistiques'
      'Je ne sais pas encore afficher les statistiques d’un texte.'.rouge_gras
    else
      error "Je ne connais pas #{what.inspect}… Impossible de l'afficher…"
    end

  end


end #/<< self
end #/Prox
