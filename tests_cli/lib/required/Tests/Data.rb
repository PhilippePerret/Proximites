# encoding: UTF-8
=begin
  Pour le passage de données Tests<->Application
=end
class Tests
class Data
class << self

  # Pour obtenir la donnée de clé +key+
  def [] keys
    return data[keys]
  end

  def save hdata = nil
    hdata && @data = data.merge(hdata)
    @data.merge!(updated_at: Time.now.to_i)
    File.exist?(file_path) && File.unlink(file_path)
    File.open(file_path,'wb'){|f|
      Tests::Log << "Data enregistrées dans le fichier Marshal: #{data.inspect}"
      Marshal.dump(data,f)
    }
  end

  # Attention : se rappeler qu'au cours d'un test, seuls les tests doivent
  # passer par ici, au tout début
  def init
    exist? && File.unlink(file_path)
    @data = {
      start_test: Time.now.to_i,
      delimiteur_tableau: (RET+('-'*30)+Time.now.to_i.to_s+('-'*30)+RET)
    }
    save
  end

  def data
    @data ||= load
  end
  def load
    exist? ? File.open(file_path,'rb'){|f|Marshal.load(f)} : Hash.new()
  end

  # Retourne TRUE si le fichier data existe
  def exist?
    File.exist?(file_path)
  end

  def file_path
    @file_path ||= File.join(Tests.folder, 'data.msh')
  end

end #/<< self
end #/Data
end #/Tests
