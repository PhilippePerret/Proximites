# encoding: UTF-8
class Prox
class << self

  # Pour afficher à l'écran le contenu du log check
  def show_log_check ; LogCheck.show end
  # Raccourci : pour ajouter un message au log
  def log_check mess, is_op = nil ; LogCheck.mess(mess, is_op) end

end #/<< self
end #/ Prox
