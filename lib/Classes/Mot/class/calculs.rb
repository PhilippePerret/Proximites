# encoding: UTF-8
=begin
  Module qui contient des méthodes de calcul sur les mots, par exemple pour
  savoir s'ils sont une locution répétitive, etc.
=end
class Texte
class Mot
class << self

  # Retourne TRUE si le +mota+ est similaire au +motb+
  #
  # Deux mots sont considérés comme similaires lorsque :
  #   * Ils font au moins 5 lettres de long
  #   * 2/3 de la longueur du plus long est égale au second
  #     Par exemple, le mot :
  #       devoir et devot => check sur 4 caractères (sur 6) donc comparaison de
  #       devo avec devo
  #
  # Noter que pour cette méthode, on utilise le mot réel, entendu que les
  # similarité n'ont de sens que sur les mots réels.
  #
  #
  def similaires? mota, motb
    # Il faut que les deux premières lettres correspondent
    mota[0..1] == motb[0..1] || return
    len_mota = mota.length ; len_motb = motb.length
    # Il faut des mots d'au moins 5 lettres
    (len_mota > 4 && len_motb > 4) || return
    mot_long, mot_court = len_mota > len_motb ? [mota, motb] : [motb, mota]
    check_len = (2.0 * mot_long.length / 3).ceil - 1
    are_similaires = res = mota[0..check_len] == motb[0..check_len]
    are_similaires || return
    # S'ils sont similaires, on fait un dernier check sur les similarités
    # impossible
    if SIMILARITES_IMPOSSIBLES.key?(mot_court)
      SIMILARITES_IMPOSSIBLES[mot_court][mot_long] && begin
        # puts "X? Mais ils sont jugés différents par similarité impossible.".jaune
        return false
      end
    end
    suivi "=?= #{mota.inspect} | #{motb.inspect} sont jugés similaires sur #{check_len + 1} caractères #{res ? '' : ' (non)'}"
    return true
  end

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

    suivi "“#{mota.mot} #{motentre.mot} #{motb.mot}” forment une locution répétitive (pas de problème de proximité)."

    return true
  end

end #/ << self
end #/Mot
end #/Texte
