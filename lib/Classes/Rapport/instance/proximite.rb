# encoding: UTF-8
class Rapport


  # Méthode principale pour construire un rapport de proximité
  #
  # Ce rapport doit sortir :
  #
  #   * le mot le plus en proximité (avec la fréquence et la densité)
  #   * les proxmités par mot proches
  #
  # @param texte Instance {Texte} du texte
  def build_rapport_proximite texte

    # Nombre total de mots
    nombre_mots = texte.mots.count
    # Nombre total de mots différents
    nombre_mots_differents = texte.occurences[:real_mots].count

    Rapport.set_outputfile_for(:rapport_proximite)
    output "=== RAPPORT DE PROXIMITES ===\n\n"
    output explication_rapport_proximite
    # On classe le rapport par proximités
    rapport_proximite.each do |m, h|
      densite = ((1 / (h[:proximites].inject(:+).to_f / h[:proximites].count)) * 100).round(2)
      h.merge!({
        densite: densite,
        real_densite: (densite * h[:count]).round(2)
        })
    end
    rapp_sorted = rapport_proximite.sort_by { |m,h| - h[:real_densite] }.collect{ |m,h|h}
    # puts "rapport_proximite = #{rapport_proximite.inspect}"
    # puts "rapp_sorted = #{rapp_sorted.inspect}"
    output "= Mot le plus en proximité : #{rapp_sorted.first[:mot]} (#{rapp_sorted.first[:count]} fois)"

    # Les proximités à corriger
    tableau_proximite_to_correct

    output "\n\n=== MOTS PAR NOMBRE DE PROXIMITÉ ET DENSITÉ ===\n\n"
    output explication_tableau_nombre_proximite_et_densite
    # On va écrire les proximités
    output "\n\n"
    entete = " #{'MOT'.ljust(20)}#{'PROXIMITÉS'.ljust(15)}#{'DENSITÉ'.ljust(8)} "
    output entete
    output "-"*entete.length
    # Notes
    # -----
    #   La +densite+ est l'inverse de la moyenne des proximités
    #   La +real_densite+ est la densité multipliée par le nombre de proximité
    rapp_sorted.each do |tprox|
      nb = tprox[:count]
      pct = ((nb.to_f / nombre_mots) * 1000).round(2)
      pct = "#{pct} ‰"
      output "#{tprox[:mot].ljust(20)}x#{nb.to_s.ljust(5)}#{pct.ljust(10)}#{tprox[:real_densite].to_s.ljust(8)}"
    end

  ensure
    Mot.close_outputfile
  end


  # Retourne un tableau avec les proxmités à corriger
  #
  # On fonctionne par centaine, du plus important au moins important
  def tableau_proximite_to_correct

    # Un tableau qui va contenir les mots en fonction de leur proximité.
    # Chaque mot est classé par centaine de caractère de distance.
    # Le tableau ressemble à :
    #     [
    #       {mots: [], max: 99}, # index = 0 => de 0 à 99
    #       { # index = 1 => de 100 à 199
    #               max: 199,
    #               mots: [
    #                 'terme1' => {proximites: []},
    #                 'terme2' => {proximites: }
    #                 ]}
    #     ]
    prox = Array.new
    30.times do |itime|
      max = (100*itime)+99
      prox << { mots: Hash.new, max: max }
    end
    MOTS.each do |mot|
      mot.mot_prox_apres || next
      distance = mot.mot_prox_apres.offset - mot.offset
      kdistance = (distance / 100)
      proxdis = prox[kdistance]
      terme = mot.mot
      proxdis[:mots].key?(terme) || proxdis[:mots].merge!(terme => {terme: terme, proximites: Array.new})
      proxdismot = proxdis[:mots][terme]
      proxdismot[:proximites] << {mot: mot, mot_apres: mot.mot_prox_apres, offset: mot.offset, offset_next: mot.mot_prox_apres.offset, distance:distance}
    end

    # On ne prend que les centaines définies
    proxparcent = prox.reject { |hprox| hprox[:mots].empty? }

    # On classe les distances par ordre croissant
    proxparcent.each do |hprox|
      hprox[:mots].each do |terme, hterme|
        # Classer les proximités par la distance
        # puts "\n\nhterme[:proximites] avant : #{hterme[:proximites]}"
        hterme[:proximites] = hterme[:proximites].sort_by { |h| h[:distance]}
        # puts "hterme[:proximites] après : #{hterme[:proximites]}"
      end
    end

    # On classe les mots par plus courte distance en prenant le premier mot
    proxparcent.each do |hprox|
      hprox[:mots] = hprox[:mots].collect{|t,hterme| hterme}
      hprox[:mots] = hprox[:mots].sort_by { |hterme| hterme[:proximites][0][:distance]}
    end

    output "\n\n=== MOTS PAR PROXIMITÉS PAR CENTAINES ===\n\n"
    proxparcent.each do |hprox|
      output "\n\n-- Mots à proximité de #{hprox[:max] - 99} à #{hprox[:max]} --"
      hprox[:mots].each do |hterme|
        terme = hterme[:terme]
        output "\n\n\t* #{terme}"
        hterme[:proximites].each do |t|
          dist = "<-#{t[:distance]}->".ljust(10)
          off = t[:offset] ; offn = t[:offset_next]
          extrait = t[:mot].extrait
          extrait_apres = t[:mot_apres].extrait
          output "\t\t\t\t#{t[:offset].to_s.ljust(9)}#{dist}#{t[:offset_next].to_s.ljust(9)}#{extrait} --- #{extrait_apres}"
        end
      end
    end
  end


  def rapport_proximite
    @rapport_proximite ||= begin
      h = Hash.new
      MOTS.each do |mot|
        # Si le mot n'a pas de proximité, on peut le passer
        mot.id_proximite || next
        m = mot.mot
        # Est-ce le premier ?
        h.key?(m) || h.merge!(m => {count: 0, mot: m, proximites: Array.new, instances: Array.new})
        # Ajouter cette proximité au mot
        h[m][:count] += 1
        if mot.mot_prox_apres
          h[m][:proximites] << (mot.mot_prox_apres.offset - mot.offset)
        end
        h[m][:instances] << mot
      end
      h
    end
  end


  def explication_rapport_proximite
    <<-EOT

    Ce rapport présente les proximités qui existent dans le texte soumis à
    l'examen (#{PATH_TEXTE}).

    Table des matières
    ------------------
        * MOTS PAR PROXIMITÉS PAR CENTAINES (<100, <200, <300 etc.)
          Cette table permet de voir d'abord les mots les plus proches, à moins
          d'une centaine de signes, puis de 200 signes, 300 signes, etc.

        * MOTS PAR NOMBRE DE PROXIMITÉ ET DENSITÉ
          Cette table présente dans l'ordre les mots les plus souvent proches,
          en indiquant cette densité de proximité, qui est l'inverse de la
          proximité. Plus la densité est élevée et plus le mot est proche.

    EOT
  end

  def explication_tableau_nombre_proximite_et_densite
    <<-EOT
    La table par nombre de proximités et densité permet de voir quelles sont
    les densités de proximité les plus fortes par mot.
    - Colonne 1 : indique le mot concerné par une proximité
    - Colonne 2 : indique le nombre de proximités qui existent avec le mot
    - Colonne 3 : indique le pourcentage du mot dans le texte, sur
      1000 mot. Si le mot n'apparait qu'une fois sur mille mots, sont pourcentage
      est de 1, s'il apparait 10 fois, sont pourcentage est de 10.
    - Colonne 4 : densité des proximités. Plus le nombre est élevé et plus
      le mot concerné est proche d'un jumeau et proche souvent. Cette densité
      est calculée par rapport à la proximité (plus c'est proche, plus c'est
      élevé) et par rapport au nombre d'occurrence proches.
    EOT
  end
end #/Rapport
