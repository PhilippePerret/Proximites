#!/usr/bin/env ruby
# encoding: UTF-8

PATH_TEXTE = "/Users/philippeperret/Documents/Ecriture/Romans/Cloaca_Maxima/VERSION-4.0/mots.txt"

# Si on ne veut pas tout analyser du texte, on peut définir un offset de départ
# et de fin
FROM_OFFSET = nil
TO_OFFSET   = nil
# FROM_OFFSET = 0
# TO_OFFSET   = 10000

THISFOLDER = File.dirname(__FILE__)


Dir.chdir(THISFOLDER) do

  require './lib/required'

  # Affichage du résultat
  # TODO Utiliser la classe Rapport plutôt
  Mot.show_proximites
  # Affichage des récurrences de mots
  # TODO Utiliser la classe Rapport plutôt
  Mot.show_occurences

  marque_temps 'Rapport de proximités…'
  rapport.build_rapport_proximite

  marque_temps 'Fin de l’opération.'

  rapport.cloture

end
