# encoding: UTF-8
=begin
  Méthodes utiles
=end
class Prox
class << self

  def load_module relp, options = nil
    p = File.join(folder_module,relp)
    case
    when !File.exist?(p) && !File.exists?("#{p}.rb")
      error "Le module `#{p}` est introuvable."
      return false
    when File.directory?(p)
      Dir["#{p}/**/*.rb"].each{|m|require m}
    else
      require p
    end
    return true
  end

end #/<< self
end #/Prox
