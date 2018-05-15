# encoding: UTF-8
class Prox
class << self

  # = main =
  #
  # Méthode principale qui check les données
  #
  def data_control
    puts Tests.delimiteur_tableau

    # Contrôle des fichiers produit. Cf. files.rb
    control_files || return

    puts Tests.delimiteur_tableau
  end


  # Méthode principale à appeler pour écrire un résultat-ligne
  def confirm ok, message, data = nil
    data ||= Hash.new
    couleur = ok ? :bleu : :rouge
    puts ((ok ? '  OK  ' : 'FAILED') + ' ' + (message % data).ljust(70)).send(couleur)
  end

end #/<< self
end #/ Prox
