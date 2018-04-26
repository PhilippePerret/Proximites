# encoding: UTF-8
class Texte

  # Le texte initial, tel que donné en ligne de commande ou dans le fichier
  attr_writer :texte

  # Pour définir la portion du texte à analyser. Noter que cette valeur
  # déterminera les paths des fichiers produits.
  attr_writer :from_offset, :to_offset

  # Le texte complet et initial, tel que fourni en ligne de commande ou
  # dans le fichier.
  def texte
    @texte ||= begin
      has_file? && exist? && File.read(path).force_encoding('utf-8')
    end
  end

  # Segment de texte à analyser, en fonction de from_offset et to_offset. Par
  # défaut, c'est le texte complet.
  def segment
    @segment ||= texte[from_offset..to_offset]
  end

  def from_offset ; @from_offset  ||= CLI.options[:from] || 0   end
  def to_offset   ; @to_offset    ||= CLI.options[:to]   || -1  end


end #/Texte
