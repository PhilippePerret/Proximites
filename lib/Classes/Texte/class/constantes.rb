# encoding: UTF-8
class Texte

  LONGUEUR_PAGE = 1500

  class << self

    def longueur_page= value ; @longueur_page = value.to_i end
    def longueur_page
      @longueur_page ||= LONGUEUR_PAGE
    end
  end#/<< self

end #/Texte
