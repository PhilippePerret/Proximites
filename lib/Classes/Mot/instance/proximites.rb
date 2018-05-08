# encoding: UTF-8
class Texte
  class Mot

    # Renvoie TRUE si le mot courant est à moins de +distance+ caractères du
    # mot +imot+
    def trop_proche_de? imot, distance
      (imot.offset - self.offset) < distance
    end

  end#/Mot
end#/Texte
