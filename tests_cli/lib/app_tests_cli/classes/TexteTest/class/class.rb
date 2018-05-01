# encoding: UTF-8
class TexteTest
class << self

  def show_mots
    puts RET2
    mots.each do |mot|
      puts "- #{mot.inspect(true)}"
    end
  end

  def mots
    File.open(mots_marshal_file,'rb'){|f|Marshal.load(f)}
  end

  def mots_marshal_file
    File.join(proximites_folder,'mots.msh')
  end

  # Path au texte
  def current_path
    Tests.current_path
  end
  # Dossier contenant tous les éléments proximités du texte
  def proximites_folder
    Tests.current_folder_proximites
  end

end #/<< self
end #/TexteTest
