# encoding: UTF-8
class Rapport
  OPTIONS = {
    output:       :file, # :console
    output_file:  nil  # La référence au fichier à écrire
  }

  # Pour les instances des rapports
  def output str
    self.class.output str
  end

  class << self

    attr_accessor :options

    def output str
      case options(:output)
      when :console then puts str
      when :file    then OPTIONS[:output_file].puts str
      end
    end

    def set_outputfile_for foo
      OPTIONS[:output_file] = File.open(get_path_output_file_for(foo), 'wb')
    end
    def get_path_output_file_for foo
      case foo
      when :proximite
        path_file_proximite
      when :occurences
        path_file_occurences
      when :rapport_proximite
        path_file_rapport_proximite
      else
        raise "Erreur dans la définition du fichier de sortie."
      end
    end

    def close_outputfile
      OPTIONS[:output_file].close
    end

    def options key
      OPTIONS[key]
    end

    def path_file_proximite
      @path_file_proximite ||= './res_proximites.txt'
    end
    def path_file_occurences
      @path_file_occurences ||= './res_occurences.txt'
    end
    def path_file_rapport_proximite
      @path_file_rapport_proximite ||= './rapport_proximites.txt'
    end
  end#/<< self
end #/Rapport
