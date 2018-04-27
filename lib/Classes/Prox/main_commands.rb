# encoding: UTF-8
=begin

  Module qui doit définir TOUTES (sans exception) les commandes principales
  qui peuvent suivre la commande `proximite` (alias `prox`)

  Dans ce fichier ne doivent être définies QUE les commandes, et rien d'autre,
  pour la clarté.
=end
class Prox
class << self

  # Affichage de l'aide
  # Avec l'option -prog, c'est l'aide de la programmation qui est affiché
  def help
    CLI.options[:programmation] ? display_help_programmation : display_help
  end
  alias :aide :help


  # Check d'un fichier dont le path doit être défini en argument.
  #
  def check
    texte_courant.analyse
    texte_courant.set_info(:last_command, ARGV.join(' '))
  end
  alias :analyse :check

  # Montre les informations d'occurence et de proximité du fichier donné
  # en argument
  def show
    show_informations
    texte_courant.set_info(:last_command, ARGV.join(' '))
  end

  # Liste des mots (uniques) en proximité, dans l'ordre alphabétique et autres
  # informations comme
  def proximites
    # Charger toutes les données
    texte_courant.mots || texte_courant.load_all

    nombre_proximites = Proximity.count

    tbl = Hash.new
    Proximity.table.values.collect{|prox|prox.mot_avant}
      .each do |imot|
        tbl.key?(imot.mot_base) || tbl.merge!(imot.mot_base => {mot: imot.mot_base, count: 0, versions: Array.new})
        tbl[imot.mot_base][:count] += 1
        tbl[imot.mot_base][:versions] << imot.mot
      end

    # Pour connaitre le pourcentage de proximité, par exemple combien de
    # mots sont à seulement une proximité, combien de 2 à 10, de 11 à 50,
    # de 51 à 100, de 101 à 200 etc.
    h_par_nb_prox = {1 => 0, '10>x<1' => 0, '50>x<11' => 0, '100>x<51' => 0, '200>x<101' => 0}
    tbl.each do |mot_base, hmot|
      c = hmot[:count]
      k =
        if c == 1     then 1
        elsif c < 11  then '10>x<1'
        elsif c < 51  then '50>x<11'
        elsif c < 101 then '100>x<51'
        else
          # Par centaine
          k = (((c - 1) / 100) + 1) * 100
          h_par_nb_prox.key?(k) || h_par_nb_prox.merge!(k => 0)
          k
        end
      h_par_nb_prox[k] += 1
    end

    proc_prox = Proc.new do |paire|
      lib, k = paire
      nombre = h_par_nb_prox[k]
      "Mots avec #{lib} proximité(s)".ljust(36)+" : " +
        nombre.to_s.ljust(8) +
        pourcentage(nombre, nombre_proximites)
    end

    tbl_nb_prox = <<-EOT
\t#{proc_prox.call(['1', 1])}
\t#{proc_prox.call(['de 2   à 10 ', '10>x<1'])}
\t#{proc_prox.call(['de 11  à 50 ', '50>x<11'])}
\t#{proc_prox.call(['de 51  à 100', '100>x<51'])}
    EOT
    tbl_nb_prox <<
      (2..10).collect do |centaines|
        cent = centaines * 100
        h_par_nb_prox.key?(cent) || next
        lib = "de #{cent - 99} à #{cent}"
        "\t#{proc_prox.call([lib, cent])}"
      end.compact.join("\n")

    # Pour déterminer le type de classement, alphabétique ou par nombre
    # de proximité
    proced =
      if CLI.options[:ksort] == 'count'
        Proc.new { |hmot| - hmot[:count] }
      else
        Proc.new { |hmot| hmot[:mot].normalize }
      end

    tbl = tbl.sort_by { |mot, hmot| proced.call(hmot) }

    tbl.each do |mot, hmot|
      str = "\t\t#{mot.ljust(20)}"
      str << "#{hmot[:count]} prox.".ljust(14)
      hmot[:versions].count > 1 && begin
        vrs = hmot[:versions].uniq.join(', ')
        str << " (#{vrs})"
      end
      puts str
      STDOUT.flush
    end

    puts <<-EOT

\tNombre mots en proximité     : #{tbl.count}
\tNombre total de proximités   : #{nombre_proximites}

#{tbl_nb_prox}

    Pour obtenir le détail de toutes les proximités et les corriger, utiliser la
    commande `prox[imite] [-i] show proximites`.


    EOT
  end

  def pourcentage nbr, tot, rnd = 2
    "#{((nbr.to_f / tot) * 100).round(rnd)} %"
  end

  # Affichage des infos sur le texte (ne pas confondre avec les statistiques)
  def infos
    texte_courant.show_infos
  end

end #/<< self
end #/Prox
