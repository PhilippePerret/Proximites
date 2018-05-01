# encoding: UTF-8
class Texte
  class Mot

    ENTETE_INSPECT_MOT = " #{'MOT'.ljust(20)}#{'INDEX'.ljust(8)}#{'OFFSET'.ljust(8)}#{'LONG'.ljust(6)}"

    def inspect tabulaire = nil
      if tabulaire
        @inspect_tab ||= "#{mot.ljust(20)}#{index.to_s.ljust(8)}#{offset.to_s.ljust(8)}#{length.to_s.ljust(6)}"
      else
        @inspect ||= "#{mot.jaune} index:#{index} offset:#{offset} len:#{length}"
      end
    end

    # Retourne l'extrait du mot dans le texte avec un nombre +autour+ de
    # caractères avant et après.
    #
    def extrait autour = 50, options = nil
      @extrait ||= begin
        seg = texte.segment
        dep = offset - autour
        dep > 0 || dep = 0
        seg[dep..offset-1].gsub(/\n/,'¶').strip +
          ' ' + mot.rouge + ' ' + # dans un fichier, il faudra que ce soit différent
          seg[(offset+mot.length)..offset+autour+mot.length].gsub(/\n/,'¶').strip
      end
    end

    def show_infos
      # OBSOLETE
      # @note CF. méthode show_infos dans Occurences/instance/helpers.rb
    end

  end#/Mot
end#/Texte
