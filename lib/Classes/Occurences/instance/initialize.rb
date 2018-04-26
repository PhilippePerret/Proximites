# encoding: UTF-8
=begin
  Module des méthodes d'instanciation d'une instance Occurences
=end
class Occurences

  # {String} Le mot dont c'est l'occurence
  # ATTENTION : Il s'agit bien d'une class String. Dans la classe Occurences,
  # les instances Texte::Mot portent le nom `imot`.
  attr_reader :mot

  # {Array of Fixnum} Tous les décalages de mots de cette occurence
  attr_reader :offsets


  def initialize mot
    @mot      = mot
    @offsets  = Array.new
  end

  # Ajoute l'instance {Texte::Mot} de +imot+ dans l'occurence courante
  #
  # C'est la méthode de base qui est utilisée à l'analyse du texte et sa
  # décomposition en mots
  # @param {Texte::Mot} imot
  #
  def add imot
    @offsets << imot.offset
  end

  # Nombre d'occurences du mot
  def count
    @count ||= offsets.count
  end

  # Ajoute
end #/Occurences
