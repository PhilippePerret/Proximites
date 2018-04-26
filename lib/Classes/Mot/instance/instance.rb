# encoding: UTF-8
class Texte
  class Mot

    # Instance Texte du texte contenant le mot
    attr_reader :texte

    # Le mot "réel", tel qu'il apparait dans le texte
    attr_reader :real_mot
    alias :mot :real_mot

    # Index du mot, dans la liste des mots du texte (où ne sont comptés que les
    # mots réels)
    attr_reader :index

    # Décalage exact du mot dans le texte.
    attr_reader :offset

    # Parfois, le mot qui sera affiché dans le texte de proximité doit être
    # allongé pour pouvoir indiquer dessous son ID et la distance de l'autre
    # mot. Dans ce cas-là, ça n'est pas le mot (mot.mot) qui est affiché, mais
    # ce mot allongé.
    attr_accessor :mot_displayed

    # On initialise un mot avec son index dans le texte et le mot
    # qu'il est ainsi que son offset dans le texte.
    def initialize texte, real_mot, index, offset
      @texte    = texte
      @real_mot = real_mot
      @index    = index
      @offset   = offset
    end

    # La longueur, pour ne pas avoir à la calculer tout le temps
    def length ; @length ||= mot.length end

    # Les deux premiers caractères, pour accélérer la comparaison
    def two_first_letters
      @two_first_letters ||= self.real_mot[0..1]
    end


  end #/Mot
end #/Texte
