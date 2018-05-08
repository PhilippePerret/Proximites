# encoding: UTF-8
=begin
  Module qui est chargé quand on n'est pas en test
=end
# La classe Tests::Log par défaut pour ne pas avoir de problème
# ou de tests à faire pour savoir si on est en tests.
class Tests
  def self.delimiteur_tableau ; end
  class Log
    class << self
      def <<(mess)    ; end
      alias :w :<<
      alias :ecrire :<<
      def error(msg)  ; end
      def print(msg)  ; end
    end #<< self
  end#/Log
end#/Tests
