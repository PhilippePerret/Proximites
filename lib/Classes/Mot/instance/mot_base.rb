# encoding: UTF-8
class Texte
  class Mot

    # Retourne le mot de base du mot, par exemple le verbe à l'infinitif lorsque
    # c'est un verbe. Par exemple, pour 'devait' et 'doit', le mot_base est
    # 'devoir'.
    # Note : ces bases sont définies dans le fichier ./data/bases_mots.rb dans
    # la constante BASES_MOTS
    def mot_base
      @mot_base ||= begin
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
    end
    def cherche_mot_base m
      BASES_MOTS[m] || MOTS_FEMININS[m]
    end

  end #/Mot
end #/Texte
