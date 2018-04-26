# encoding: UTF-8
class Proximity

  # Retourne TRUE si la proximité doit être affichée
  def displayable?
    CLI.options[:all] || (!treated? && !deleted?)
  end

class << self

  attr_accessor :changements_operes

  # Méthode principale appelée quand on fait `prox show proximites [path]`
  #
  # On procède en deux temps :
  #   * on relève la liste des proximités à afficher (sauf si --all)
  #   * on affiche les proximités (de façon interactive si nécessaire)
  #
  def show
    mode_interactif = CLI.options[:interactif]
    show_all        = !!CLI.options[:all]


    liste_proximites = table.values.select{ |prox| prox.displayable? }
    nombre_proximites = liste_proximites.count

    nombre_displayed = "total : #{table.count} / non traitées : #{nombre_proximites}"

    entete = "=== AFFICHAGE DES PROXIMITÉS (#{nombre_displayed}) ==="
    puts "#{RET3}#{entete}#{RET3}"

    proced =
      if mode_interactif
        Proc.new do |prox, numero|
          prox.displayable? || next
          puts RET2 + prox.as_line(numero, nombre_proximites) + RET2
          traite_proximite_mode_interactif(prox) && break
        end
      else
        Proc.new do |prox, numero|
          prox.displayable? || next
          puts prox.as_line(numero, nombre_proximites)
        end
      end

    # =========================================================
    # On boucle sur chaque proximité à afficher
    liste_proximites.each_with_index do |prox, index_prox|
      proced.call(prox, 1 + index_prox)
    end
    puts RET3
    # =========================================================

    if mode_interactif && changements_operes
      yesOrNo("Faut-il enregistrer les changements opérés ?") && save
    end
  end


  def traite_proximite_mode_interactif iprox
    while true
      print "Opération (n=suivante, o=marquer traitée, s=supprimer, z=tout arrêter) : "
      c = STDIN.gets.strip_nil
      case c
      when NilClass, 'n' then return false # pour poursuivre
      when 'z'     then return true
      when 'o', 'ok', 'oui'
        # => marquer cette proximité traitée
        yesOrNo('Cette proximité a-t-elle vraiment été traitée ?') && begin
          iprox.set_treated
          self.changements_operes = true
        end
        return false # pour ne pas interrompre
      when 's', 'delete', 'supprimer'
        # => supprimer cette proximité après confirmation
        yesOrNo('Dois-je vraiment supprimer cette proximité (ne plus en tenir compte) ?') && begin
          iprox.set_deleted
          self.changements_operes = true
        end
        return false # pour ne pas interrompre
      else
        error "Le choix #{c} est invalide."
      end
    end
    return false
  end
end #/<< self
end #/Proximity
