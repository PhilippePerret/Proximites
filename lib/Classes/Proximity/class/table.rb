# encoding: UTF-8
class Proximity
class << self

  # La grande table qui va contenir toutes les proximités du texte courant.
  def table
    @table ||= Hash.new()
  end

  def save_table
    File.exist?(path_file_table) && File.unlink(path_file_table)
    File.open(path_file_table,'wb'){|f| Marshal.dump(Proximities.table,f)}
  end
  def load_table with_message = true
    if File.exist?(path_file_table)
      self.table = File.open(path_file_table,'rb'){|f| Marshal.load(f)}
    else
      Texte.current.define_table_proximites
      save_table
    end
  end

  # Pour ajouter une proximité {proximity} à la table
  def add prox
    table.key?(prox.centaine) || begin
      table.merge!(
        prox.centaine => {
          count: 0,
          proximities: Array.new()
        }
      )
    end
    #/ fin d'ajout de la clé centaine si nécessaire

    # On peut ajouter la proximité
    table[prox.centaine][:count] += 1
    table[prox.centaine][:proximities] << prox

  end

end #/<< self
end #/ Proximity
