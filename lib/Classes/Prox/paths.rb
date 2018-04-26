# encoding: UTF-8
=begin
  Méthodes utiles
=end
class Prox
class << self

  # Défini dans et par Texte.current si c'est un path de fichier qui est
  # fourni. Sinon, c'est le dossier où on se trouve.
  attr_accessor :path

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
