# encoding: UTF-8
class Occurences
class << self

  def display_table_occurences
    suivi '-> Occurences::display_table_occurences'
    puts ENTETE_DISPLAY_TABLE
    table.each do |mot, occurence|
      occurence.display_table
    end
    puts LEGENDE_DISPLAY_TABLE
  end

end #/<< self
end #/Occurences
