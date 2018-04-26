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
    marque_temps 'Calcul des proximités…'
    table.each do |mot, occurence|
      occurence.traitable? || next
      occurence.check_proximites
    end
  end

end #/<< self
end #/ Occurences
