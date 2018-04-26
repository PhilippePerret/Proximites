# encoding: UTF-8
=begin
  Module de méthodes qui permettent de calculer les valeurs utiles pour
  déterminer si un mot est proche ou non, en fonction de sa fréquence dans le
  texte.

  Si l'option --raw/--brut est choisie, on considère que la distance pour
  n'importe quel mot doit être de 2000 signes maximum
=end
class Texte

  # # Cette table des proximités retourne un Hash qui contient toutes les
  # # proximités définies par centaines
  # def build_table_proximites options = nil
  #
  #   options ||= Hash.new()
  #
  #   # On simule la demande de ne prendre que les mots
  #   options[:prox_max] = 100
  #
  #   table_proximites.each do |centaine, hcentaine|
  #     if options.key?(:prox_max)
  #       (centaine * 100) < options[:prox_max] || next
  #     end
  #     hcentaine[:indexes].each do |index_mot|
  #       mot = mots[index_mot]
  #       mot_apres = mot.mot_prox_apres
  #       distance_str  = mot.distance_with_mot_apres.to_s.ljust(8)
  #       mot_str       = mot.mot
  #       if mot_apres.mot != mot_str
  #         mot_str += " (#{mot_apres.mot})"
  #       end
  #       amorce  = "#{mot_str} - Distance : #{distance_str}"
  #       tab = ' ' * 20
  #       puts "\n---\n\n#{amorce}\n\n#{tab}#{mot.extrait}\n#{tab}#{mot_apres.extrait}"
  #     end
  #   end
  #
  # end

end#/Texte
