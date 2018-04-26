# encoding: UTF-8
class Texte
  class Mot

    ENTETE_INSPECT_MOT = " #{'MOT'.ljust(20)}#{'INDEX'.ljust(8)}#{'OFFSET'.ljust(8)}#{'LONG'.ljust(6)}"

    def inspect
      @inspect ||= "#{mot.ljust(20)}#{index.to_s.ljust(8)}#{offset.to_s.ljust(8)}#{length.to_s.ljust(6)}"
    end

    # Retourne l'extrait du mot dans le texte avec un nombre +autour+ de
    # caractères avant et après.
    #
    # TODO Plus tard, les +options+ permettront de définir le type de sortie,
    # pour faire des documents en HTML.
    def extrait autour = 50, options = nil
      @extrait ||= begin
        seg = texte.segment
        seg[offset-autour..offset-1].gsub(/\n/,'¶').strip +
          ' [['+mot+']] ' +
          seg[(offset+mot.length)..offset+autour+mot.length].gsub(/\n/,'¶').strip
      end
    end

  end#/Mot
end#/Texte
