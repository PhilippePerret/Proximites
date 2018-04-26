# encoding: UTF-8
=begin
  Module de méthodes gérant l'affichage des données à l'écran
=end
class Texte


  # ---------------------------------------------------------------------
  #   SOUS-MÉTHODES UTILITAIRES
  # ---------------------------------------------------------------------

  # Retourne la table des proximités
  def tableau_proximites options = nil
    puts "-> Texte#tableau_proximites"
    build_table_proximites
    <<-EOT

=== TABLE DES PROXIMITÉS ===

[À DÉVELOPPER]

    EOT
  end

  # Retourne la table des occurences de mots
  def tables_occurences
    <<-EOT

=== OCCURENCES DES MOTS RÉELS (#{occurences[:real_mots].count}) ===

#{table_occurences_real_mots}

=== OCCURENCES DES MOTS DE BASE (#{occurences[:mot_bases].count}) ===

#{table_occurences_mot_bases}

    EOT
  end
  def table_occurences_real_mots
    table_occurence(:real_mots)
  end
  def table_occurences_mot_bases
    table_occurence(:mot_bases)
  end
  def table_occurence key_occ
    nombre_mots = occurences[key_occ].count
    proc_pourcentage =
      if nombre_mots > 5000
        Proc.new{|nb| (1000.0 * nb / nombre_mots).round(2).to_s + ' ‰' }
      else
        Proc.new{|nb| (100.0 * nb / nombre_mots).round(2).to_s + ' %' }
      end
    occurences[key_occ].sort_by{|m,hm| - hm[:count]}.collect do |mot, hmot|
      pct = proc_pourcentage.call(hmot[:count])
      "    #{hmot[:mot].ljust(20)}#{hmot[:count].to_s.ljust(4)}#{pct}"
    end.join("\n")
  end

end#/Texte
