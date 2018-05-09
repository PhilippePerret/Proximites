# encoding: UTF-8
=begin
  Module qui contient des méthodes de calcul sur les mots, par exemple pour
  savoir s'ils sont une locution répétitive, etc.
=end
class Texte
class Mot
class << self

  # La méthode retourne false si ce sont deux mots à distance minimum fixe
  # qui sont trop éloignés.
  # les deux mots ne sont donc pas en proximité
  def distance_minimum_fixe_too_big? motA, motB
    # Tests::Log.w('Texte::Mot::distance_minimum_fixe_too_big?(%{mota}, %{motb})', {mota: motA.mot.inspect, motb: motB.mot.inspect})
    MOTS_A_DISTANCE_MIN_FIXE.key?(motA.mot_base) || return # pour continuer
    # Tests::Log.w('MOTS_A_DISTANCE_MIN_FIXE[%{mot}] est définie à %{dist}', {mot:motA.mot.inspect, dist:MOTS_A_DISTANCE_MIN_FIXE[motA.mot_base]})
    # On retourne true (donc pour empêcher la proximité) quand la distance
    # entre les deux mots est supérieur à la distance minimale possible entre
    # ces deux mots
    # Tests::Log.w('Distance entre les deux mots = motB.offset - motA.offset = %{dist}', {dist: motB.offset - motA.offset})
    return MOTS_A_DISTANCE_MIN_FIXE[motA.mot_base] < (motB.offset - motA.offset)
  end

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
    Prox.log_check? && Prox.log_check("\t\t#{mota.inspect} | #{motb.inspect} sont jugés similaires sur #{check_len + 1} caractères.")

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

    Prox.log_check? && Prox.log_check("\t\t\t\tLocution répétitive “#{mota.mot} #{motentre.mot} #{motb.mot}” => PROXIMITÉ ANNULÉE")

    return true
  end

end #/ << self
end #/Mot
end #/Texte
