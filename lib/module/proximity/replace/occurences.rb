# encoding: UTF-8
class Occurences

  # Pour retirer le mot +imot+ ({Texte::Mot}) des occurences courantes (quand
  # par exemple il a été modifié)
  def retire_mot imot
    # Dans un premier temps, on doit trouver l'index du mot dans les listes,
    index_mot_in_liste = nil
    @offsets.each_with_index do |offset, index|
      if offset == imot.offset
        index_mot_in_liste = index
        break
      end
    end
    index_mot_in_liste || begin
      raise 'Un index aurait dû être trouvé…'
    end

    # On retire l'offset
    @offsets.delete_at(index_mot_in_liste)
    # On retire l'index
    deleted_index = @indexes.delete_at(index_mot_in_liste)
    deleted_index == imot.index || begin
      raise 'L’index retiré aurait dû être celui du mot…'
    end

    # On retire le mot des autres listes si nécessaire
    @similarites.reject!{ |i| i == imot.index }
    @derives    .reject!{ |i| i == imot.index }

  end
  # /retire_mot

  def retire_proximite prox_id
    @proximites.reject! { |pid| pid == prox_id }
  end

  # Méthode de modification d'un mot qui vérifie les proximités avant et arrière
  # du mot +imot+
  def check_proximite_vers imot, en_avant
    en_arriere = !en_avant
    # On met le mot après (si en_avant) directement dans mot_tested
    mot_tested = nil
    index_tested = nil
    @offsets.each_with_index do |offset, index|
      if en_arriere
        if offset < imot.offset
          # Note : ici, on conserve l'index des mots avant jusqu'au plus près
          mot_tested = index
        else
          mot_tested && mot_tested = texte_courant.mots[mot_tested]
          break
        end
      elsif en_avant && offset > imot.offset
        mot_tested = texte_courant.mots[indexes[index]]
        break # on en a forcément fini
      end
    end
    #/boucle sur tous les offsets

    # Si un mot avant ou après a été trouvé, on peut vérifier sa proximité
    # C'est ici qu'on va affecter la proximité
    if mot_tested
      if en_avant
        check_proximite(imot, mot_tested)
      else
        check_proximite(mot_tested, imot)
      end
    end


  end
  #/check_proximite_vers

end #/Occurences
