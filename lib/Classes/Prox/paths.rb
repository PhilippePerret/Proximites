# encoding: UTF-8
=begin
  Méthodes utiles
=end
class Prox
class << self

  # @return {String} Le path du fichier provisoire
  #
  def save_texte_in_prov_file
    p = File.join(THISFOLDER,'.texte_prov','texte.txt')
    File.exist?(p) && File.unlink(p)
    `mkdir -p #{File.dirname(p)}`
    File.open(p,'wb'){|f| f.write CLI.params[-1].strip}
    return p
  end

  # Le dernier path utilisé, ou nil.
  # La méthode s'assure que le fichier existe toujours.
  def last_path
    @last_path ||= begin
      p = config(:last_file_path)
      (p && File.exist?(p)) ? p : nil
    end
  end

  # Path du fichier texte étudié.
  # -----------------------------
  # Il est défini même lorsque c'est un texte qui est fourni en argument, car
  # ce texte est alors enregistré dans un fichier provisoire dans le dossier
  # `.texte` de l'application.
  # Sauf si l'option -t est utilisée, définissant
  # c'est un texte qui est transmis en dernier paramètre, il faut impérativement
  # que ce soit un fichier existant. Cette méthode le vérifie
  def path
    @path ||= begin
      if CLI.params[-1].nil?
        # On essaie de prendre le dernier fichier défini
        last_path
      elsif CLI.options[:texte]
        puts "-> texte fourni"
        # Sinon, si c'est un texte qui est fourni, on l'enregistre dans un
        # fichier provisoire.
        save_texte_in_prov_file
      else
        p = File.expand_path(CLI.params[-1])
        File.exist?(p) ? p : last_path
      end
    end
  end

  def today_mark ; @today_mark ||= Time.now.strftime('%Y-%m-%d') end

  def affixe
    @affixe ||= File.basename(path, File.extname(path)).normalize
  end

  def folder
    @folder ||= begin
      if path.nil?
        File.join('.',"proximites-#{affixe}")
      else
        File.join(File.dirname(path),"proximites-#{affixe}")
      end
    end
  end

end #/<< self
end #/Prox
