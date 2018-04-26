# encoding: UTF-8
class Proximity
class << self

  def path_file_table
    @path_file_table ||= File.join(Prox.folder, "#{today_mark}-table_proximites.msh")
  end

end #/<< self
end #/ Proximity
