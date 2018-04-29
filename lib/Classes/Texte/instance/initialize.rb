# encoding: UTF-8
class Texte

  def initialize path
    @path = path
    set_info(file_path: path, file_name: File.basename(path))
  end

end#/Texte
