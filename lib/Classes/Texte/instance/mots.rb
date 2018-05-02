# encoding: UTF-8
=begin
  Module gérant les mots du texte

=end
class Texte

  def mots
    @mots === nil && load_mots
    @mots
  end

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
    liste_mots.each_with_index do |mot, index_mot|
      texte_long? && begin
        print "\033[5;23H"
        print "#{(1+index_mot).to_s.rjust(len_nombre_mots)}"
      end
      Prox.log_check? && Prox.log_check("\tTraitement du mot #{mot.inspect.jaune}")

      # ==============================================
      imot = add_mot(mot, index_mot, current_offset)
      # ==============================================

      Prox.log_check? && begin
        imot.mot == imot.mot_base || Prox.log_check("\t\tMot de base : #{imot.mot_base.inspect}")
      end

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

  # On ajoute le mot du texte à l'instance Texte
  # En même temps, on gère les instances Occurences
  #
  # C'est la grande méthode qui permet ensuite de traiter les proximités.
  #
  # Retourne l'instance Texte::Mot du mot créé
  def add_mot mot_str, index_mot, current_offset, next_char = nil
    imot = Texte::Mot.new(self, mot_str, index_mot, current_offset, next_char || segment[current_offset + mot_str.length])
    #           Le caractère qui suit le mot --------------------------^
    @mots << imot
    Occurences.add(imot)
    return imot
  end

  def nombre_total_mots
    @nombre_total_mots ||= mots.count
  end

  def liste_mots
    @liste_mots ||= begin
      lm = segment.split(/[^[[:alnum:]]]/)
      puts "segment dans liste_mots : #{segment.inspect}"
      puts "mots : #{lm.inspect}"
      lm
    end
  end


end#/Texte
