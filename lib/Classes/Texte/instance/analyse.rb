# encoding: UTF-8
class Texte


  # Méthode principale procédant au check complet du texte
  def analyse
    suivi '-> Texte#check (grand check complet avec sauvegarde)'

    # Le fait d'appeler la méthode-propriété `mots` va calculer toutes les
    # occurences des mots et créer des instances Texte::Mot de ces mots
    marque_temps 'Décomposition du texte en mot (occurences)…'
    decompose_en_mots
    puts "= Décomposition du texte en mots opérée (#{nombre_total_mots} mots)"

    marque_temps 'Calcul des proximités…'
    Occurences.check_proximites
    puts "= Occurences analysées (#{Occurences.count} mots uniques)"
    puts "= Proximités trouvées (#{Proximity.count})"

    marque_temps 'Enregistrement des informations…'
    save_all
    puts "= Données sauvegardées dans les fichiers."
    puts '(utiliser la commande `prox show [what] [path]` pour voir les résultats — ou demander l’aide)'

    marque_temps 'FIN DE L’ANALYSE'
    puts RET2
  end


end#/Texte
