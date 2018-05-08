# encoding: UTF-8
class Tests
class << self

  # Pour ré-initialiser, notamment pour supprimer le dossier `./.texte_prov`
  # s'il existe
  def reset
    File.exist?('./.texte_prov') && FileUtils.rm_rf('./.texte_prov')
  end

end #/<< self
end #/Tests
