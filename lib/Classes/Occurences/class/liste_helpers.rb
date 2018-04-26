# encoding: UTF-8
class Occurences
class << self

  # Clé de tri (accessible ici notamment pour les affichages de messages)
  attr_accessor :key_sorted

  def display_table_occurences
    suivi '-> Occurences::display_table_occurences'
    # La liste à prendre en fonction des options
    self.key_sorted = CLI.options[:ksort] || 'count'
    liste_occurences = send("table_sorted_by_#{key_sorted}".to_sym)
    entete = ENTETE_DISPLAY_TABLE.sub(/#{' MOT'.ljust(20)}/," MOT (#{liste_occurences.count}/#{count})".ljust(20))
    puts entete
    liste_occurences.each do |occurence|
      occurence.mot != '' || next
      occurence.display_table
    end
    puts LEGENDE_DISPLAY_TABLE % {sorted: key_sorted == 'count' ? 'décroissant par nombre d’occurences' : 'alphabétique'}
  end

end #/<< self
end #/Occurences
