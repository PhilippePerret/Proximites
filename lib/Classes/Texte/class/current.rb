# encoding: UTF-8
=begin
  Module principal pour le texte courant.
=end
class Texte
class << self

  attr_reader :current

  # Définir le texte courant
  def current= texte_or_path
    t = new()
    t.has_a_file= File.exist?(File.expand_path(texte_or_path))
    if t.has_file?
      Prox.path = t.path = File.expand_path(texte_or_path)
    else
      t.texte = texte_or_path
    end
    @current = t
  end

end #/self
end #/Texte

# Retourne l'instance courante du texte.
def texte_courant
  Texte.current
end
alias :current_text :texte_courant
