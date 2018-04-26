# encoding: UTF-8
class Texte


  # Méthode principale procédant au check complet du texte
  def analyse
    suivi '-> Texte#check (grand check complet avec sauvegarde)'

    # Le fait d'appeler la méthode-propriété `mots` va calculer toutes les
    # occurences des mots et créer des instances Texte::Mot de ces mots
    decompose_en_mots
    puts "= Décomposition du texte en mots opérée (#{nombre_total_mots.mille} mots)"

    Occurences.check_proximites
    puts "= Occurences analysées (#{Occurences.count.mille} mots uniques)"
    puts "= Proximités trouvées (#{Proximity.count.mille})"

    save_all
    puts "= Données sauvegardées dans les fichiers."
    puts '(utiliser la commande `prox show [what] [path]` pour voir les résultats — ou demander l’aide)'

    marque_temps 'FIN DE L’ANALYSE'
    puts RET2

    set_info(:last_analyse, Time.now)
  end


end#/Texte
