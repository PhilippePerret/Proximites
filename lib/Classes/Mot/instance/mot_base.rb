# encoding: UTF-8
class Texte
  class Mot

    class << self
      def get_mot_base mot
        cherche_mot_base(mot) || begin
          last_lettre = mot[-1]
          case
          when last_lettre == 's' && MOTS_FIN_S[mot].nil?
            cherche_mot_base(mot[0..-2]) || mot[0..-2]
          when last_lettre == 'x' && MOTS_FIN_X[mot].nil?
            cherche_mot_base(mot[0..-2]) || mot[0..-2]
          else
            # Sinon, on prend le mot normal
            mot
          end
        end
      end
      #/get_mot_base
      def cherche_mot_base mot
        BASES_MOTS[mot] || MOTS_FEMININS[mot]
      end
    end #/<< self

    # ---------------------------------------------------------------------
    #   INSTANCE
    # ---------------------------------------------------------------------
    
    # Retourne le mot de base du mot, par exemple le verbe à l'infinitif lorsque
    # c'est un verbe. Par exemple, pour 'devait' et 'doit', le mot_base est
    # 'devoir'.
    # Note : ces bases sont définies dans le fichier ./data/bases_mots.rb dans
    # la constante BASES_MOTS
    def mot_base
      @mot_base ||= self.class.get_mot_base(mot)
    end

  end #/Mot
end #/Texte
