# encoding: UTF-8
=begin
  Module gérant les mots du texte

=end
class Texte

  attr_reader :mots

  # Méthode qui analyse le texte pour le décomposer en mots et faire les
  # occurences.
  # Produit :
  #   @mots
  #   @nombre_total_mots
  #   Les occurences
  #
  # La méthode demande aussi d'enregistrer le résultat
  #
  def decompose_en_mots
    Prox.log_check? && Prox.log_check("*** Décomposition en mots…", is_op = true)
    @mots = Array.new
    # Pour connaitre le décalage du mot.
    current_offset = 0
    liste_mots.each_with_index do |mot, index_mot|
      Prox.log_check? && Prox.log_check("\tTraitement du mot #{mot.inspect}")
      add_mot(mot, index_mot, current_offset)
      current_offset += mot.length + 1
    end
    Prox.log_check? && Prox.log_check("=== Fin de la décomposition en mots", is_op = true)
  end

  # On ajoute le mot du texte à l'instance Texte
  # En même temps, on gère les instances Occurences
  #
  # C'est la grande méthode qui permet ensuite de traiter les proximités.
  def add_mot mot_str, index_mot, current_offset
    mot = Texte::Mot.new(self, mot_str, index_mot, current_offset)
    @mots << mot
    Occurences.add(mot)
  end



  def nombre_total_mots
    @nombre_total_mots ||= mots.count
  end

  def liste_mots
    @liste_mots ||= segment.my_downcase.split(/[^[[:alnum:]]]/)
  end


end#/Texte
