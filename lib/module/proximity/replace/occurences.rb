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

  def retire_proximite prox_id
    @proximites.reject! { |pid| pid == prox_id }
  end


end #/Occurences
