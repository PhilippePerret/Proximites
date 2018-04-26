# encoding: UTF-8
class Proximity
class << self

  def path_file_table
    @path_file_table ||= File.join(Prox.folder, "#{Prox.today_mark}-proximites.msh")
  end

end #/<< self
end #/ Proximity
