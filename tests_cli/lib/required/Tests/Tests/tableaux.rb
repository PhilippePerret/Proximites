# encoding: UTF-8
class Tests
class << self

  # ---------------------------------------------------------------------
  #   Pour la gestion des "tableaux"
  #
  #   Rappel/principe : la sortie d'une commande se faisant en une seule
  #   fois dans un texte (grâce aux séquences de touches), on peut diviser
  #   la sortie en "tableaux" à l'aide du `Tests.delimiteur_tableau`.
  #   Grâce à cette méthode, on peut afficher tous les tableaux ou les
  #   récupérer
  # ---------------------------------------------------------------------

  # Montre tous les tableaux du résultat
  def show_tableaux
    show_tableaux_in(resultat_final)
  end

  # Retourne le tableau d'index +index_tableau+
  def tableau index_tableau
    tableaux_in(resultat_final)[index_tableau]
  end

  # Pour délimiter les retours successifs avec un délimiteur qui permettra de
  # tester plus facilement les résultats
  def delimiteur_tableau
    @delimiteur_tableau ||= Data[:delimiteur_tableau]
  end
  alias :delimiteur_tableaux :delimiteur_tableau

  # +res+ (String} est le retour offert par la command `run`.
  # Retourne les tableaux. Pour récupérer un tableau en particulier, on
  # peut donc faire :
  #     tableaux = Tests.tableaux_in(res)
  #     tableau = tableaux[x]
  def tableaux_in res
    res.split(delimiteur_tableaux)
  end
  # Cette méthode sert surtout à trouver le tableau concerné par le test,
  # avant de l'appeler par `Tests.tableaux_in(res)[x]`
  # +res+ {String} est le retour de la commande `run`
  def show_tableaux_in res
    header = ('-'*40) + (' TABLEAU INDEX %s ') + ('-'*40)
    footer = ('-'*40) + ('/Tableau index %s')  + ('-'*40)
    tbls = tableaux_in(res)
    nombre_tableaux = tbls.count
    dernier_index   = nombre_tableaux - 1
    tbls.each_with_index do |tbl, index_tableau|
      index_mark = "#{index_tableau} / dernier index: #{dernier_index}"
      puts RET3 + (header % [index_mark]) +
            RET2 + tbl + RET2 + (footer % [index_mark])
    end
  end

end #/<< self
end #/Tests
