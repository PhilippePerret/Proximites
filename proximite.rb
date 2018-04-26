#!/usr/bin/env ruby
# encoding: UTF-8
=begin
  Module répondant à la commande `proximite` (alias `prox`) pour lancer
  les tests de proximité et autres.
=end


THISFOLDER = File.dirname(__FILE__)
Dir.chdir(THISFOLDER) do
  require './lib/required'
  Prox.run
end #/chdir
