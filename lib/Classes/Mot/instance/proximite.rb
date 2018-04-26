# encoding: UTF-8
class Texte
  class Mot

    # Le mot proche avant et après (instances Texte::Mot)
    attr_accessor :mot_prox_avant, :mot_prox_apres

    # ID qui permet de connaitre les mots qui sont en proximité. Le mot d'avant
    # porte cet identifiant, ainsi que le mot d'après.
    attr_accessor :id_proximite

    # Retourne TRUE si le mot courant est strictement identique à +comp+
    # @param comp {Texte::Mot}
    # @return true/false
    def mot_identique?(comp)
      self.mot_base == comp.mot_base
    end

    # Retourne TRUE si le mot courant est similaire à +comp+
    # Deux mots sont considérés comme similaires lorsque 2/3 de leur longueur
    # correspond depuis le début. Par exemple, le mot :
    #   devoir et devot => check sur 4 caractères (sur 6) donc comparaison de
    #   devo avec devo
    #
    # Noter que pour cette méthode, on utilise le mot réel, entendu que les
    # similarité n'ont de sens que sur les mots réels.
    #
    # Pour être similaire, la première condition est que les deux premiers
    # caractères soient identiques.
    #
    def mot_similaire?(comp)
      self.two_first_letters == comp.two_first_letters || (return false)
      mot_long  = self.mot.length > comp.mot.length ? self : comp
      mot_court = self.mot.length > comp.mot.length ? comp : self
      check_len = (2.0 * mot_long.length / 3).ceil - 1
      are_similaires = res = self.mot[0..check_len] == comp.mot[0..check_len]
      are_similaires || (return false)
      # S'ils sont similaires, on fait un dernier check sur les similarités
      # impossible
      if SIMILARITES_IMPOSSIBLES.key?(mot_court.mot)
        SIMILARITES_IMPOSSIBLES[mot_court.mot][mot_long.mot] && begin
          # puts "X? Mais ils sont jugés différents par similarité impossible.".jaune
          return false
        end
      end
      suivi "=?= #{self.mot} | #{comp.mot} sont jugés similaires sur #{check_len + 1} caractères #{res ? '' : ' (non)'}"
      return true
    end



  end #/Mot
end #/Texte
