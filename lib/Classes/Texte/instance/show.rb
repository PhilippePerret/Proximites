# encoding: UTF-8
=begin
  Module de méthodes gérant l'affichage des données à l'écran
=end
class Texte

  def show_proximites
    ensure_mots_proximites
    if CLI.options[:output]
      # <= Sortie dans un fichier
      p = File.expand_path('./mots')
      p = Rapport.export_in_file(p, tables_proximites, CLI.options[:output], {formate: true, open: false})
      notice "Proximités exportées dans le fichier #{p.inspect}"
    else
      # Sortie en console
      puts tableau_proximites
    end
  end

  # Affiche la fréquence des mots, en pourcentage (millième) et la distance
  # minimale pour considérer la répétition.
  def show_distances_per_frequences
    ensure_occurences
    # puts "NOMBRE_TOTAL_MOTS     = #{nombre_total_mots}"
    # puts "DISTANCE_MAX_NORMALE  = #{DISTANCE_MAX_NORMALE}"
    entete = "\t#{'MOT'.ljust(20)}#{'NOMBRE'.ljust(7)}#{'PRÉSENCE'.ljust(12)}#{'DISTANCE'.ljust(12)}"

    puts entete
    puts "\t" + '-'*entete.length
    puts ""
    occurences[:mot_bases].sort_by{|mot,hmot| -hmot[:count]}.each do |mot, hmot|
      hmot[:count] > 1 || begin
        puts "\n\n\tTous les autres mots ont une fréquence de 1 (donc pas de présence et de distance minimale)\n\n"
        break
      end
      puts "\t#{mot.ljust(20)}#{hmot[:count].to_s.ljust(7)}#{hmot[:presence_mot].to_s.ljust(12)}#{hmot[:distance_min].to_s.ljust(12)}"
    end
  end

end#/Texte
