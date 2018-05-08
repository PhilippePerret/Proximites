# encoding: UTF-8
class Texte


  # Méthode principale procédant au check complet du texte
  def analyse

    # Si le texte a déjà été analysé et que des mots ont été remplacé, on ne
    # peut pas relancer une analyse complète, ce qui aurait pour effet de tout
    # supprimer.
    if info(:locked)
      if CLI.options[:force]
        set_info(locked: false)
      else
        error "Des proximités ont été modifiés dans ce texte, il est donc#{RETDT}"+
              "impossible de l’analyser à nouveau, ce qui perdrait toutes les#{RETDT}"+
              "corrections. Au lieu de ça, copier le texte et lancer une nouvelle#{RETDT}"+
              "analyse."
        notice "Vous pouvez néanmoins décider de toute perdre en ajoutant l'option --force…#{RET3}"
        return
      end
    end

    # On évalue les mots à distance min fixe. Cette distance min fixe doit être
    # calculée chaque fois car elle dépend de la configuration, par exemple de
    # la longueur d'une page.
    Texte::Mot.evalue_valeurs_mots_a_distance_min_fixe

    # Clearer la fenêtre
    puts "\033c"

    texte_long? && begin
      print "\033[2;1H" # 2e ligne
      puts '*** Analyse du texte…'
    end
    suivi '-> Texte#check (grand check complet avec sauvegarde)'
    Prox.log_check? && Prox.log_check("Début de l'analyse du texte", is_op = true)

    # Certaines options peuvent redéfinir des valeurs de configuration, comme
    # par exemple la distance maximale de proximité (cf. dans le module infos.rb)
    texte_long? && print("*** Configuration… ")
    define_configuration
    texte_long? && puts("OK")

    decompose_en_mots

    # Recherche des proximités dans les occurences formées
    Occurences.check_proximites

    # Sauvegarde de toutes les tables (mots, proximités, occurences)
    texte_long? && print("*** Enregistrement des données… ")
    save_all
    texte_long? && puts("OK")

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
