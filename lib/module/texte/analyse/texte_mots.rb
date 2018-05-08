# encoding: UTF-8
=begin
  Module gérant les mots du texte

=end
class Texte

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

    nombre_mots     = liste_mots.count
    len_nombre_mots = nombre_mots.to_s.length

    texte_long? && begin
      print "\033[4;1H"
      print("*** Décomposition en mot. Merci de patienter… ")
      print "\033[5;0H"
      print "    Traitement du mot #{'0'.rjust(len_nombre_mots)} sur #{nombre_mots}."
    end

    # Pour connaitre le décalage du mot.
    current_offset = 0
    next_index_for_display = 1000

    liste_mots.each_with_index do |mot, index_mot|

      if index_mot > next_index_for_display
        next_index_for_display += 1000
        texte_long? && begin
          print "\033[5;23H"
          print "#{(1+index_mot).to_s.rjust(len_nombre_mots)}"
        end
      end
      # Prox.log_check? && Prox.log_check("\tTraitement du mot #{mot.inspect.jaune}")

      # ==============================================
      imot = add_mot(mot, index_mot, current_offset)
      # ==============================================

      # Prox.log_check? && begin
      #   imot.mot == imot.mot_base || Prox.log_check("\t\tMot de base : #{imot.mot_base.inspect}")
      # end

      current_offset += mot.length + 1

    end

    # Si le texte se termine par une ponctuation précédée d'une espace, elle
    # n'est pas prise en compte. Il faut done artificiellement créer ce mot,
    # qui sera un mot vide avec pour next_char la ponctuation.
    if segment.match(/[  \\][?!;:]$/)
      ponctuation = segment.match(/[  \\]([?!;:])$/).to_a[1]
      add_mot('', liste_mots.length, segment.length - 2, ponctuation)
    end

    Prox.log_check? && Prox.log_check("=== Fin de la décomposition en mots", is_op = true)
  end
  #/decompose_en_mots

end#/Texte
