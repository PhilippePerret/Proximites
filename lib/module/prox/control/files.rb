# encoding: UTF-8
class Prox
class << self

  # On s'assure :
  #   - que tous les fichiers nécessaires ait été produits
  def control_files

    confirm(File.exist?(folder), 'Le dossier principal “%s” existe', [File.basename(folder)])
    File.exist?(folder) || return

    ['infos', 'mots', 'proximites', 'occurences'].each do |affixe|
      p = File.join(folder,"#{affixe}.msh")
      confirm(File.exist?(p), 'Le fichier de données “%s” existe', ["#{affixe}.msh"])
    end

    return true # pour continuer
  end

end #/<< self
end #/Prox
