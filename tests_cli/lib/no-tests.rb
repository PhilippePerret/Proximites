# encoding: UTF-8
=begin
  Module qui est chargé quand on n'est pas en test
=end
# La classe Tests::Log par défaut pour ne pas avoir de problème
# ou de tests à faire pour savoir si on est en tests.
class Tests
  class Log
    class << self
      def <<(mess) ; end
      def error(msg) ; end
    end #<< self
  end#/Log
end#/Tests
