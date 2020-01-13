# encoding: UTF-8
class Float
  # Retourne le floatant sous forme de pourcentage ou de pourmillage
  # Note : la méthode existe aussi pour les Integer
  # Rappel : pour obtenir le pourcentage, on fait <nombre>/<nombre total>
  def pourcentage rnd = 2, pour_mille = false
    "#{(self * 100).round(rnd)} #{pour_mille ? '‰' : '%'}"
  end
end
