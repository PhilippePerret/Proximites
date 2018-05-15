require './tests_cli/lib/required'
=begin

  Fonctionnement de ce test
  -------------------------
  Quand une erreur se produit, en corrigeant Cloaca Maxima, on fait une copie
  du dossier de proximités dans le dossier test et on reproduit l'erreur pour la
  corriger.

=end
#
# Tests.titre 'Problème de "lorsque" changé en "quand" mais la proximité demeure.'
# path = 'test/Manuscrit-2.txt'
# run(('proximite correct %s' % [path]), [
#   'rp quand',   # Remplacement demandé
#   'o',          # Confirmer que oui, malgré l'alerte
#   'oo',         # Confirmer la modification
#   'z',          # Pour finir la correction
#   'n',          # Ne pas enregistrer
#   'o',          # Confirmer qu'on n'enregistre pas
#   'q'           # Terminer le programme
#   ])
# Tests.show_tableaux


# ---------------------------------------------------------------------
=begin
undefined method `retire_mot' for nil:NilClass (détail dans le fichier ./.tests_cli/test.log)
# ..../Proximites/lib/module/proximity/replace/mot.rb:128:in `set_mot'
=end
# Tests.titre 'Problème d’occurence Nil'
# path = 'test/Manuscrit-3.txt'
# run(('proximite correct %s' % [path]), [
#   'rp jeté',    # Remplacement demandé
#   'o',          # Confirmer que oui, malgré l'alerte
#   'rs jeta',    # Remplacement du second mot
#   'o',          # Confirmer le second remplacement
#   'oo',         # Confirmer la modification
#   # -- Suivant --
#   'rs brandir', # Remplacer le second
#   'o',          # Confirmer le remplacement du second
#   # --- Fin ---
#   'z',          # Pour finir la correction
#   'n',          # Ne pas enregistrer
#   'o',          # Confirmer qu'on n'enregistre pas
#   'q'           # Terminer le programme
#   ])
# Tests.show_tableaux


# TODO Se servir du 4 pour voir un problème de remplacement de "nouveau" par
# "façonner" qui a produit l'erreur :
# undefined method `retire_mot' for nil:NilClass (détail dans le fichier ./.tests_cli/test.log)
# /Users/philippeperret/Documents/Ecriture/Divers/Programmes/Proximites/lib/module/proximity/replace/mot.rb:128:in `set_mot'
# ATTENTION : ce n'est pas le premier mot à remplacer, mais peut-être le sixième ou septième.

fin_tests
