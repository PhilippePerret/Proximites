# encoding: UTF-8
=begin
  Module contenant toutes les méthodes d'état des occurences, pour savoir,
  par exemple, si la proximité des mots doit être checkée
=end
class Occurences


  def mot_length
    @mot_length ||= mot.length
  end

end #/Occurences
