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

    nombre_mots = table.count
    len_nombre_mots = nombre_mots.to_s.length

    texte_courant.texte_long? && begin
      print "\033[6;1H"
      print("*** Recherche des proximités. Merci de patienter… ")
      print "\033[7;0H"
      print "    Traitement de l'occurence #{'0'.rjust(len_nombre_mots)} sur #{nombre_mots}."
    end

    index_mot = 0
    table.each do |mot, occurence|
      Prox.log_check? && Prox.log_check("\t* Traitement de l’occurence du mot #{mot.inspect.jaune}")
      texte_courant.texte_long? && begin
        index_mot += 1
        print "\033[7;30H"
        print "#{index_mot.to_s.rjust(len_nombre_mots)}"
      end
      occurence.traitable? || next
      occurence.check_proximites
    end

    texte_courant.texte_long? && begin
      print "\033[8;0H"
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
