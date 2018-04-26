# encoding: UTF-8
class Prox
class << self

  # Main méthode pour montrer les informations concernant un fichier
  # donné en argument, qui doit obligatoirement exister.
  def show_informations
    suivi '-> Prox#show_informations'

    # Ce qu'il faut afficher
    what = CLI.params[1].strip_nil

    what || begin
      error "Il faut indiquer ce qu'il faut montrer, parmi :" +
        "#{RETDT}\t* show occurences#{RETDT}\t* show proximites#{RETDT}\t* show stats"
      return
    end

    # Charger toutes les données
    texte_courant.load_all

    case what
    when 'proximites', 'proximite', 'proximité', 'proximités'
      Proximity.show
    when 'occurences', 'occurence'
      Occurences.show
    when 'stats', 'statistiques'
      Texte.current.show_statistiques
    else
      error "Je ne connais pas #{what.inspect}… Impossible de l'afficher…"
    end

  end


end #/<< self
end #/Prox
