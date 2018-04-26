# encoding: UTF-8
class Prox
class << self

  # Main méthode pour montrer les informations concernant un fichier
  # donné en argument, qui doit obligatoirement exister.
  def show_informations
    suivi '-> Prox#show_informations'
    Texte.current = CLI.params[1].strip_nil
    texte_courant.has_file? || begin
      error "Il faut impérativement donner le path du texte en premier argument."
      return
    end

    # Charger les mots et les occurences
    texte_courant.load_mots_et_occurences
    # Affichage des proximité
    # texte_courant.show_proximites
    # # Affichage des occurences
    texte_courant.show_occurences
    # # Affichage des distances par occurence
    # texte_courant.show_distances_per_frequences

  end


end #/<< self
end #/Prox
