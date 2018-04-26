# encoding: UTF-8
class Rapport
class << self

  # Exporter le contenu +content+ dans un fichier du +format+ voulu qui a pour
  # affixe +affixe+ (nom dans extension)
  # @param options
  #   :open   Si true, on ouvre le fichier (true par défaut)
  #   :formate  Si true, et que le format est HTML, il faut transformer le
  #             contenu en code HTML. Sinon, le code envoyé doit être du pur
  #             code HTML
  #
  # @return Le path du fichier
  #
  def export_in_file affixe, content, format, options = nil
    options ||= Hash.new()
    options.key?(:open) || options.merge!(open: true)
    case (format || 'text').to_s.downcase
    when 'text', 'true'
      path = "#{affixe}.txt"
      File.open(path,'wb'){|f| f.write content}
      `mate "#{path}"` if options[:open]
    when 'html'
      path = "#{affixe}.html"
      if options[:formate]
        error "Je ne sais pas encore exporter en formatant le code en HTML"
        return
      end
      File.open(path,'wb'){|f| f.write content}
    else
      path = affixe
      error "Je ne sais pas encore exporter les résultats en #{CLI.options[:output]}"
    end
    return path
  end
  #/export_in_file

end #/<< self
end #/Rapport
