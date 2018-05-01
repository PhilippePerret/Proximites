# encoding: UTF-8
class Texte
  class Mot

    # Instance Texte du texte contenant le mot
    attr_reader :texte

    # Le mot "réel", tel qu'il apparait dans le texte, par exemple avec la
    # capitale alors que :mot ne l'aura pas
    attr_reader :real_mot
    attr_reader :mot

    # Index du mot, dans la liste des mots du texte (où ne sont comptés que les
    # mots réels)
    attr_reader :index

    # Décalage exact du mot dans le texte.
    attr_reader :offset

    # Le caractère qui suit le mot (espace, point, apostrophe, etc.)
    attr_reader :next_char

    # Décalage d'offset, lorsque le mot original, qui a permet de créer l'ins-
    # tance, a été remplacé par un autre mot de longueur différente. Dans ce
    # cas, +offset_correction+ contient la différence, qu'il faut ajouter pour
    # connaitre la différence, ajouter de l'offset au mot suivant si le mot est
    # plus long ou retirer de l'offset si le mot est plus court.
    attr_reader :offset_correction

    # Table des Identifiants des proximités du mot, if any,
    # Contient {:apres, :avant} et un ID en valeur.
    attr_accessor :prox_ids


    # On initialise un mot avec son index dans le texte et le mot
    # qu'il est ainsi que son offset dans le texte.
    def initialize texte, real_mot, index = nil, offset = nil, next_char = nil
      @texte      = texte
      @mot        = real_mot.my_downcase
      @real_mot   = real_mot
      @index      = index
      @offset     = offset
      @next_char  = next_char || '' # le dernier mot, par exemple
    end

    def init
      @length = @complet = @two_first_letters = nil
    end

    # Le mot complet, i.e. avec son caractère suivant. Pour un affichage rigou-
    # reusement identique
    def complet ; @complet ||= real_mot + next_char end

    # La longueur, pour ne pas avoir à la calculer tout le temps
    def length ; @length ||= mot.length end

    # L'occurence du mot ({Occurences})
    def occurence
      @occurence ||= Occurences[mot_base]
    end

    # Les deux premiers caractères, pour accélérer la comparaison
    def two_first_letters
      @two_first_letters ||= self.real_mot[0..1]
    end

    # Ajout d'une proximité pour le mot courant. Si +apres+ est true, l'autre
    # mot se trouve après, sinon, c'est le mot avant.
    def add_proximite iprox, apres
      @prox_ids ||= Hash.new
      key = apres ? :apres : :avant
      @prox_ids.merge!( key => iprox.id )
    end

  end #/Mot
end #/Texte
