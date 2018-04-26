# encoding: UTF-8
class Mot
  class << self

    # Le texte complet qui est analysé
    # Note : on le trouve aussi dans <rapport>.texte (où <rapport> est
    # l'instance Rapport courante)
    attr_accessor :texte_complet


  end #/ << self
end #/Mot
