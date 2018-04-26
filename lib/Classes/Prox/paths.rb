# encoding: UTF-8
=begin
  Méthodes utiles
=end
class Prox
class << self

  def path ; @path ||= CLI.params[-1] end
  def path= value ; @path = value end # utilisé par class Texte

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
