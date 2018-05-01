# encoding: UTF-8
require 'json'

Dir["./lib/Extensions/**/*.rb"].each{|m|require m}
CLI.analyse_command_line
Dir["./lib/Classes/**/*.rb"].each{|m|require m}
Dir["./data/required/**/*.rb"].each{|m|require m}

# Si on est en mode test
if CLI.options[:test]
  Dir['./tests/lib/app/**/*.rb'].each{|m|require(m)}
  # Pour les messages de log et les réponses
  Dir['./tests/lib/required/Tests/**/*.rb'].each{|m|require(m)}
else
  # Sinon, on simule la classe Tests::Log pour ne pas avoir de problème
  # ou de tests à faire pour savoir si on est en tests.
  class Tests
    class Log
      class << self
        def << mess ; end
      end #<< self
    end#/Log
  end#/Tests
end
