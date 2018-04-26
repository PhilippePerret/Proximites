# encoding: UTF-8
=begin
  Module de méthodes qui permettent de calculer les valeurs utiles pour
  déterminer si un mot est proche ou non, en fonction de sa fréquence dans le
  texte.

  Si l'option --raw/--brut est choisie, on considère que la distance pour
  n'importe quel mot doit être de 2000 signes maximum
=end
class Texte

  # Cette table des proximités retourne un Hash qui contient toutes les
  # proximités définies par centaines
  def build_table_proximites options = nil

    options ||= Hash.new()

    # On simule la demande de ne prendre que les mots
    options[:prox_max] = 100

    table_proximites.each do |centaine, hcentaine|
      if options.key?(:prox_max)
        (centaine * 100) < options[:prox_max] || next
      end
      hcentaine[:indexes].each do |index_mot|
        mot = mots[index_mot]
        mot_apres = mot.mot_prox_apres
        distance_str  = mot.distance_with_mot_apres.to_s.ljust(8)
        mot_str       = mot.mot
        if mot_apres.mot != mot_str
          mot_str += " (#{mot_apres.mot})"
        end
        amorce  = "#{mot_str} - Distance : #{distance_str}"
        tab = ' ' * 20
        puts "\n---\n\n#{amorce}\n\n#{tab}#{mot.extrait}\n#{tab}#{mot_apres.extrait}"
      end
    end

  end

  def table_proximites
    @table_proximites || load_table_proximites
  end


  def define_table_proximites
    mots.each do |mot|
      # On ne prend que les mots qui définissent une proximité après
      mot.mot_prox_apres || next
      # On crée une instance proximité pour ces deux mots
      prox = Proximity.new(mot, mot.mot_prox_apres)
      Proximity.add(prox)
      # Vérification, au cas où
      # -----------------------
      # La distance maximum pour qu'il y ait proximité
      # On vérifie
      if prox.distance > occurences[:mot_bases][mot.mot_base][:distance_min]
        error "# PROBLÈME : une proximité a été déterminée au-delà de la distance maximale…"
      end
    end
    #/fin de boucle sur chaque mot
  end


  # Calcule les distances minimales et les places dans les données d'occurences
  # du texte
  def calc_distances_minimales_per_frequence

    # Pour mémoriser les valeurs en fonction du nombre d'occurences
    valeurs_per_occurences = Hash.new

    occurences[:mot_bases].sort_by{|mot,hmot| -hmot[:count]}.each do |mot, hmot|
      hmot[:count] > 1 || break
      count = hmot[:count]
      valeurs_per_occurences.key?(count) || begin
        # Le taux de présence du mot. Plus le mot est fréquent, plus son taux
        # est élevé, proportionnellement. Un taux de mot fréquent est 10
        # Un taux de mot rare est en dessous de 0.1
        presence_mot = ((hmot[:count].to_f / nombre_total_mots) * 1000).round(2)
        # Distance maximale pour considérer que deux mots identiques ou similaires ne sont
        # pas en proximité (proches). Plus le mot est rare et plus cette distance augmente
        # distance_min = (DISTANCE_MAX_NORMALE.to_f * 5 / presence_mot).to_i
        distance_min = (DISTANCE_MAX_NORMALE.to_f / presence_mot).to_i
        valeurs_per_occurences.merge!(count => {presence: presence_mot, distance: distance_min})
      end
      occurences[:mot_bases][mot].merge!(
        presence_mot: valeurs_per_occurences[count][:presence],
        distance_min: valeurs_per_occurences[count][:distance]
      )
    end
    # /boucle sur les mot_bases
  end
  #/calc_distances_minimales_per_frequence

end#/Texte
