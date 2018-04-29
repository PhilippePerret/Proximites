# encoding: UTF-8
=begin
  Module de méthodes qui permettent de calculer les valeurs utiles pour
  déterminer si un mot est proche ou non, en fonction de sa fréquence dans le
  texte.

  Si l'option --raw/--brut est choisie, on considère que la distance pour
  n'importe quel mot doit être de 2000 signes maximum
=end
class Texte

  def show_statistiques
    puts tableau_statistiques
  end
  def tableau_statistiques
    <<-EOT

=== STATISTIQUES DE L'ANALYSE DE PROXIMITÉS ===

  Fichier                   : #{path}
  Longueur du texte         : #{segment.length.mille} signes
  Nombre de pages           : #{nombre_pages}
  Nombre total de mots      : #{mots.count.mille}
  Nombre de mots différents : #{Occurences.count.mille}
  Nombre de proximités      : #{Proximity.count.mille}
  --------------------------
  Durée correction estimée  : #{Proximity.estimation_duree_corrections(Proximity.count)}

================================================


    EOT
  end

  def nombre_pages
    @nombre_pages ||= begin
      (segment.length / LONGUEUR_PAGE) + 1
    end
  end

end#/Texte
