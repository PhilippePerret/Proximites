# encoding: UTF-8
=begin
  Module des méthodes qui gère la class Occurences en tant que liste des
  occurences du texte.
  (contrairement aux instances qui s'occupent d'une seule occurence de mot)
=end
class Occurences
class << self

  # Check les proximités de toutes les occurences traitables
  def check_proximites
    Prox.log_check? && Prox.log_check("*** Recherche des proximités…", is_op = true)
    texte_courant.mots || texte_courant.load_all
    table.each do |mot, occurence|
      Prox.log_check? && Prox.log_check("\t* Traitement de l’occurence du mot #{mot.inspect.jaune}")
      occurence.traitable? || next
      occurence.check_proximites
    end
    Prox.log_check? && begin
      Prox.log_check(["=== Fin de la recherche des proximités#{RET}",
        "  = Occurences analysées (#{Occurences.count.mille} mots uniques)#{RET}",
        "  = Proximités trouvées (#{Proximity.count.mille})"], is_op = true
      )
    end
  end

end #/<< self
end #/ Occurences
