# encoding: UTF-8
class Texte


  # Méthode principale procédant au check complet du texte
  def analyse
    suivi '-> Texte#check (grand check complet avec sauvegarde)'

    # Le fait d'appeler la méthode-propriété `mots` va calculer toutes les
    # occurences des mots et créer des instances Texte::Mot de ces mots
    decompose_en_mots

    marque_temps 'FIN'
    return

    marque_temps 'Calcul des valeurs de proximités…'
    calc_distances_minimales_per_frequence

    marque_temps 'Test de proximités…'
    mots.each do |mot|
      mot.test_proximite
    end

    marque_temps 'Définition de la table des proximités…'
    define_table_proximites

    # On enregistre tous les résultats obtenus, c'est-à-dire les données
    # d'occurences et les données de proximités.
    marque_temps 'Sauvegarde des résultats…'
    save_all

    marque_temps 'FIN DU CHECK'
  end


end#/Texte
