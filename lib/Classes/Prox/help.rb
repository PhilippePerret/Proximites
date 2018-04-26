# encoding: UTF-8
=begin
  Module affichant l'aide pour la programmation
=end
class Prox
class << self

  def display_help
    load_module('aide/user') || return
    puts tableau_help
  end

  def display_help_programmation
    load_module('aide/programmation') || return
    puts tableau_help_programmation
  end

end #/<< self
end #/Prox
