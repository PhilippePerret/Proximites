# encoding: UTF-8
class Rapport

  # Texte écrit à la fin du rapport, dans la console
  def cloture
    puts "\n\nPour voir le résultat de cette analyse de fréquence et de proximité, consulter les fichier :"
    puts "\t* rapport_proximites.txt (proximités en chiffres)"
    puts "\t* res_proximites.txt (intégralité du texte, avec indication des proximités)"
    puts "\t* res_occurences.txt (indication des fréquences de mots — simple)"
    puts "\n\n"
  end


end #/Rapport
