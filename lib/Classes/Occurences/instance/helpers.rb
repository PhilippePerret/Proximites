# encoding: UTF-8
=begin
  Module des méthodes d'aide à l'affichage
=end
class Occurences

  ENTDT =     ' MOT'.ljust(20) +
    'NOMBRE'.ljust(8)       +
    'PRÉSENCE'.ljust(12)    +
    'DISTANCE'.ljust(9)     +
    ' TRAITER ?'.ljust(20)
  LINE_ENDTDT = ('-'*ENTDT.length)
  ENTETE_DISPLAY_TABLE = RET3 + LINE_ENDTDT + RET + ENTDT + RET + LINE_ENDTDT + RET
  LEGENDE_DISPLAY_TABLE = <<-EOT

  * Classement %{sorted}
  * La `DISTANCE` représente le nombre de signes minimum qui doivent séparer deux mots
    pour qu’ils ne soient pas considérés en proximité.

  EOT

  # Affichage de la table courante des occurences du mot de l'occurence
  def display_table
    mot_str       = "*#{mot}*".ljust(20)
    count_str     = " #{count}".ljust(8)
    # offset_str  = "#{offsets_disp.ljust(38)}"
    presence_str  = "#{presence} ‰".ljust(12)
    dist_str      = " #{distance_min}".ljust(9)
    trait_str     = "#{traitable? ? ' oui' : raison_non_traitable}".ljust(20)
    traitable? || trait_str = trait_str.gris
    puts mot_str + count_str + presence_str + dist_str + trait_str

  end
  #/display_table

  # Affichage des informations concernant le mot
  # Si l'option --deep est utilisée, on montre les informations en profondeur,
  # par exemple en donnant tous les extraits où le mot apparait.
  #
  def show_infos
    puts RET3 + "=== INFOS SUR LE MOT #{mot.inspect} ===" + RET2
    indeep = CLI.options[:deep]

    count_proximites =
      traitable? ?
      proximites.count :
      "--- " + "(#{raison_non_traitable})".gris

    puts <<-EOT
    = MOT : #{mot.inspect}
    =
    = Nombre d’occurences   : #{count} => présence de #{presence} ‰
    = Nombre de proximités  : #{count_proximites}
    = Nombre de similarités : #{similarites.count}
    = Nombre de dérivés     : #{derives ? derives.count : 0}
    #{if indeep
      "\n#{table_deep_infos}"
    else
      "\n\t(pour obtenir des informations complètes, ajouter l’option --deep)"
    end}


    EOT
  end

  def table_deep_infos
    table_occurences = indexes.collect do |index|
      imot = texte.mots[index]
      "\t\t- #{imot.extrait}"
    end.join("\n")

    nombre_proximites = proximites.count
    index_prox = 0
    table_proximites = proximites.collect do |prox_id|
      index_prox += 1
      iprox = Proximity[prox_id]
      "\t- #{iprox.as_line(index_prox, nombre_proximites)}"
    end.join("\n")

    table_similarites =
      if similarites.empty?
        '--- Aucune similarité ---'
      else
        similarites.collect{|mid| texte.mots[mid].mot }.join(', ')
      end

    table_derives     =
      if derives.empty?
        '--- Aucun dérivés ---'
      else
        derives.collect{|mid| texte.mots[mid].mot }.join(', ')
      end

    titre_tbl_occurences  = "\t" + "TABLE OCCURENCES DU MOT “#{mot}”".underlined('=',"\t")
    titre_tbl_proximites  = "\t" + "TABLE PROXIMITÉS DU MOT “#{mot}”".underlined('=',"\t")
    titre_tbl_similarites = "\t" + "TABLE SIMILARITÉS DU MOT “#{mot}”".underlined('=',"\t")
    titre_tbl_derives     = "\t" + "TABLE DÉRIVÉS DU MOT “#{mot}”".underlined('=',"\t")

    explication_fin = <<-EOT
    Rechercher “TABLE OCCURENCES”, “TABLE PROXIMITÉS”, “TABLE SIMILARITÉS” ou
    “TABLE DÉRIVÉS” pour voir les informations respectives.
    EOT

    <<-EOT


#{titre_tbl_occurences}

#{table_occurences}

#{titre_tbl_proximites}

#{table_proximites}

#{titre_tbl_similarites}

#{"\t" + table_similarites}

#{titre_tbl_derives}

#{"\t" + table_derives}

#{explication_fin}
    EOT
  end


end #/Occurences
