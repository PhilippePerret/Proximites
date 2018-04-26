# encoding: UTF-8
=begin
  Module principal pour le texte courant.
=end
class Texte
class << self

  # Le texte courant
  def current
    @current ||= new(Prox.path)
  end

end #/self
end #/Texte

# Retourne l'instance courante du texte.
def texte_courant
  Texte.current
end
alias :current_text :texte_courant
