# encoding: UTF-8
class Texte
  class Mot

    # Le mot proche avant et après (instances Texte::Mot)
    attr_accessor :mot_prox_avant, :mot_prox_apres

    # ID qui permet de connaitre les mots qui sont en proximité. Le mot d'avant
    # porte cet identifiant, ainsi que le mot d'après.
    attr_accessor :id_proximite

    # Méthode principale qui check la proximité d'un mot
    def test_proximite

      # On ne fait rien si le mot est inférieur à 3 caractères ou si son
      # occurence est de 1
      self.traite? || begin
        # suivi "Mot #{self.mot.inspect} non traité (#{raison_non_traitement})"
        return
      end

      # Il faut tester à partir de l'index du mot suivant, jusqu'à trouver
      # la distance maximale (sauf si l'option --brut est utilisée)
      # Noter que cette longueur est une valeur vraiment brute, qui ne compte
      # pas les espaces et ponctuations.
      longueur_traitee = 0
      comp = nil


      # puts "Distance min pour le mot #{mot_base.inspect} (#{real_mot}) : #{distance_min}"

      # puts "* Recherche de proximité de #{mot}:#{offset} (distance_min : #{distance_min})"
      while (comp = texte.mots[(comp ? comp.index : self.index) + 1]) && longueur_traitee < distance_min
        # Dès qu'on a trouvé un mot similaire, on interrompt la boucle
        # On compare et si on trouve un mot identique ou similaire, on peut
        # directement s'arrêter là.
        compare_with(comp) && begin
          # puts " = MOT PROX TROUVÉ : #{comp.mot}:#{comp.offset}".jaune
          break
        end
        # Sinon, on ajoute la longeur du mot traité la longueur testée
        # Noter que c'est la longueur du mot réel, pas du mot de base.
        longueur_traitee += comp.length
      end
      # puts "  = On arrête de traiter #{mot}:#{offset} (avec une longueur traitée de #{longueur_traitee})"
      # if self.mot_prox_apres.nil?
      #   if longueur_traitee > distance_min
      #     puts " = La longueur max a été atteinte sans trouver de mot"
      #   else
      #     puts " # Longueur max pas atteinte, mais pas de mot trouvé… Et pourtant sortie…".rouge
      #   end
      # else
      #   puts "  = Mot prox trouvé : #{mot_prox_apres.mot}:#{mot_prox_apres.offset}"
      # end
    end

    def distance_with_mot_apres
      distance_with(mot_prox_apres)
    end
    # Retourne la distance, en signes, entre le mot courant et le mot
    # +autre_mot+
    def distance_with autre_mot
      (autre_mot.offset - self.offset).abs
    end

    # Retourne la distance maximale qui doit séparer deux mots similaires pour
    # être considérés en proximité
    #
    # Si l'option --brut est ajoutée à la commande `check`, alors on prend une
    # valeur par défaut (DISTANCE_DEFAUT)
    def distance_min
      @distance_min ||= begin
        CLI.options[:brut] ? DISTANCE_DEFAUT : data_occurence_base[:distance_min]
      end
    end
    def data_occurence_base
      @data_occurence_base ||= texte.occurences[:mot_bases][mot_base]
    end

    # Comparaison du mot courant avec +comp+
    #
    # Pour le moment, on ne traite que le cas où le mot est unique
    def compare_with comp
      mot_identique?(comp) || mot_similaire?(comp) || (return false)
      # <= Mots strictement identiques ou similaire
      # => C'est la proximité maximum

      # S'il y a un problème de distance, on ne prend pas le mot
      if distance_with(comp) > distance_min
        "# Problème de distance entre #{self.mot}:#{self.offset} et #{comp.mot}:#{comp.offset} : distance = #{distance_with(comp)} (distance min: #{distance_min})"
        return false
      end
      # On cherche un ID-proximité au mot qui permettra de l'identifier dans le
      # texte. Si le mot courant était déjà en proximité avec un mot précédent,
      # cet identifiant existe déjà.
      self.id_proximite ||= self.class.get_new_id_proximite
      comp.id_proximite = self.id_proximite
      # On définit le mot proche après du mot courant
      self.mot_prox_apres = comp
      # On définit le mot proche avant du mot courant
      comp.mot_prox_avant = self
      # On retourne true pour interrompre la boucle
      return true
    end

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
