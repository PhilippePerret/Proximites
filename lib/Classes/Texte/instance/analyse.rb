# encoding: UTF-8
class Texte


  # Méthode principale procédant au check complet du texte
  def analyse
    suivi '-> Texte#check (grand check complet avec sauvegarde)'
    Prox.log_check? && Prox.log_check("Début de l'analyse du texte", is_op = true)

    # Certaines options peuvent redéfinir des valeurs de configuration, comme
    # par exemple la distance maximale de proximité (cf. dans le module infos.rb)
    define_configuration

    # Le fait d'appeler la méthode-propriété `mots` va calculer toutes les
    # occurences des mots et créer des instances Texte::Mot de ces mots
    decompose_en_mots

    # Recherche des proximités dans les occurences formées
    Occurences.check_proximites

    # Sauvegarde de toutes les tables (mots, proximités, occurences)
    save_all

    # On affiche à la fin un message explicatif.
    puts explication_fin_analyse.jaune

    set_info(:last_analyse, Time.now)

  end

  def explication_fin_analyse
    <<-EOT

    Informations sur le résultat (nombre mots, proximités, etc.) :

        #{'prox[imite] show stats'.jaune} ou #{'prox show statistiques'}

    Pour voir le texte avec les proximités en exergue :

        #{'prox[imite] show texte [--from_page=<page>] [--to_page=<page>]'.jaune}

    Pour pouvoir corriger les proximités relevées, utilisez la commande :

        #{'prox[imite] show proximites -i'.jaune}
        # Le #{'-i'.jaune} permet de corriger chaque proximité l'une
        # après l'autre


    (utiliser l'aide pour obtenir une information plus précise)
    EOT
  end
end#/Texte
