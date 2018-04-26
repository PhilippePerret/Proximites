# encoding: UTF-8
=begin
  Module qui contient des méthodes de calcul sur les mots, par exemple pour
  savoir s'ils sont une locution répétitive, etc.
=end
class Mot
  class << self


    # Retourne TRUE si mota et motb forment une locution répétition du type
    #   temps en temps     (de temps en temps)
    #   encore et encore
    #   coute que coute
    # Une locution répétitive est toujours constituée de trois termes qui se
    # suivent dont les extrémités sont identiques.
    def locution_repetitive? mota, motb

      # Les deux mots doivent être séparés d'un seul mot
      mota.index == motb.index - 2 || return

      # Les deux mots doivent être identiques
      mota.mot == motb.mot || return

      # Les deux mots doivent être séparés de "de", "en" ou "que"
      motentre = Texte.current.mots[mota.index + 1]
      ['de','en','que'].include?(motentre.mot) || return

      puts "“#{mota.mot} #{motentre.mot} #{motb.mot}” forment une locution répétitive (pas de problème de proximité)."

      return true
    end

  end #/ << self
end #/Mot
