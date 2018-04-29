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
        "#{RETDT}\t* show occurences#{RETDT}\t* show proximites#{RETDT}\t* show stats#{RETDT}\t* show <mot>"
      CLI.delete_last_in_historique
      return
    end

    # Charger toutes les données
    texte_courant.mots || texte_courant.load_all

    case what
    when 'log', 'log_check'
      load_module 'log_check'
      Prox.show_log_check
    when 'infos'
      self.infos # c'est une commande "directe", normalement
    when 'texte', 'text'
      texte_courant.show
    when 'proximites', 'proximités'
      Proximity.show
    when 'proximite', 'proximité'
      if CLI.params[2].match(/^[0-9]+$/)
        Proximity.show_proximite_by_id(CLI.params[2].to_i)
      else
        Proximity.show(CLI.params[2])
      end
    when 'occurences', 'occurence'
      Occurences.show
    when 'stats', 'statistiques'
      Texte.current.show_statistiques
    else
      # Arrivé ici, le what peut être :
      #   * un mot dont on veut voir les informations
      #   * un ID de proximité qu'on veut voir en détail et corriger
      #   * une erreur
      if what.match(/^[0-9]+$/)
        Proximity.show_proximite_by_id(what.to_i)
      else
        # Il faut créer une instance du mot pour pouvoir obtenir son mot de base
        imot = Texte::Mot.new(texte_courant, what)
        if Occurences[imot.mot_base]
          # Texte::Mot.show_info(what)
          Occurences[imot.mot_base].show_infos
        else
          error "Je ne connais pas #{what.inspect}… Impossible de l'afficher…"
          CLI.delete_last_in_historique
        end
      end
    end

  end


end #/<< self
end #/Prox
