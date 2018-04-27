# encoding: UTF-8
=begin

  Module des méthodes qui gèrent les mots et, principalement, la méthode qui
  ajoute un mot à la liste des occurences, en cherchant les identificités et les
  similarités.

=end
class Occurences
class << self

  # Pour ajouter une occurence du mot.
  # Le mot peut être semblable (même mot base) ou similaire (mot base non
  # traité par exemple)
  def add imot
    # Si le mot-base du mot existe déjà en temps que l'occurence, c'est
    # simple : il suffit d'ajouter cette occurence
    if table.key?(imot.mot_base)
      add_finaly(imot)
    else
      # Sinon, il faut voir si le mot est similaire à un mot existant
      # Si ça n'est pas le cas, il faut créer l'instance
      similarite_trouvee = false
      table.keys.each do |comp|
        Texte::Mot.similaires?(imot.mot, comp) && begin
          Occurences[comp].add(imot, true) # true => similaire
          add_finaly(imot, comp)
          similarite_trouvee = true
          break
        end
      end
      # /fin de boucle sur tous les mots
      similarite_trouvee || begin
        suivi "Création de l’occurence #{imot.mot_base.inspect}"
        table[imot.mot_base] = new(imot)
        add_finaly(imot)
      end
    end
  end

  # Ajoute vraiment l'occurence de {Texte::Mot} mota ou du mot similaire
  # {String} +comp+
  def add_finaly mota, comp = nil
    Occurences[comp||mota.mot_base].add(mota)
  end

end #/<< self
end #/Occurences
