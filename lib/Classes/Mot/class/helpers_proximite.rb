# encoding: UTF-8
class Texte
class Mot

  class << self

    attr_accessor :lineup, :linedo

    def show_proximites
      set_outputfile_for(:proximite)
      init_line_up_and_down
      output "\n\n==== CHECK DE PROXIMITÉ =========\n\n"
      MOTS.each do |mot|
        # On doit d'abord construire la marque de proximité pour
        # pouvoir connaitre le mot à écrire dans la ligne supérieure.
        self.linedo << build_marque_proximite(mot) + ' '
        self.lineup << (mot.mot_displayed || mot.mot) + ' '

        if self.lineup.length > 80
          ecrire_lignes_up_and_down
        end
      end
      #/Fin Mots.each

      # On termine
      ecrire_lignes_up_and_down
      output "\n\n"
    ensure
      OPTIONS[:output_file].close
    end
    #/show_proximites

    # Méthode pour écrire dans le fichier ou en console les lignes de
    # suivi de proximité.
    # On indique en début de ligne la longueur de la ligne.
    # On initialise les lignes ensuite.
    def ecrire_lignes_up_and_down
      len = self.lineup.length
      output "#{len}:: #{self.lineup}"
      output "#{' '*len.to_s.length}   #{self.linedo}"
      output ''
      init_line_up_and_down
    end

    # Construction de la marque qui doit être mise sous le mot, dans le
    # rapport de proximité, s'il y a une proximité.
    # Sinon, c'est simplement un string vide de la dimension du mot qui
    # est retourné.
    def build_marque_proximite mot
      marque_prox = String.new
      # Quand le mot courant a un mot proche avant
      # => On doit mettre l'ID unique de proximité, qui est commun à tous
      #    les mots en proximité.
      mot.mot_prox_avant && begin
        marque_prox << "<-#{mot.id_proximite}"
      end
      # Quand le mot courant a un mot proche après,
      # on doit trouver un ID unique de proximité si nécessaire
      mot.mot_prox_apres && begin
        # On calcule la distance entre les deux mots
        distance = mot.mot_prox_apres.offset - mot.offset
        # On finalise la marque de proximité
        # Noter qu'elle a pu être construite avec un mot avant.
        marque_prox != '' || marque_prox << "#{mot.id_proximite}"
        marque_prox << "->#{distance}"
      end

      if marque_prox.empty?
        # Aucune proximité avec aucun mot, on renvoie simplement une marque
        # vide de la longueur du mot.
        return ' ' * mot.length
      else
        marque_prox.ljust(mot.length)
      end

      # Si la marque est plus longue que le mot, il faut modifier
      # le mot affiché en lui ajoutant des espaces.
      if marque_prox.length > mot.length
        mot.mot_displayed= mot.mot.ljust(marque_prox.length)
      else
        marque_prox = marque_prox.ljust(mot.length,'-')
      end

      return marque_prox
    end
    # /build_marque_proximite

    def get_new_id_proximite
      @index_id_proximite ||= -1
      @index_id_proximite += 1
      @index_id_proximite.to_s(36)
    end


    def init_line_up_and_down
      self.lineup = String.new
      self.linedo = String.new
    end


  end #/<< self
end# /Mot
end# /Texte
