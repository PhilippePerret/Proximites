# encoding: UTF-8
class Mot


  class << self


    # Affiche les récurrences des mots
    def show_occurences
      set_outputfile_for(:occurences)
      output "\n\n========= RÉCURRENCES =============\n\n"
      t = RECURRENCES.sort_by{|mot,hmot| - hmot[:count]}.collect do |mot, hmot|
        mot.length > 0 || next
        "\t#{mot.ljust(20)}#{hmot[:count].to_s.ljust(5)}"
      end.compact
      output t
      output "\n\n===========================================\n\n"
    ensure
      OPTIONS[:output_file].close
    end


  end #/<< self
end#/Mot
