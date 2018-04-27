# encoding: UTF-8
=begin
  Module calculant les proximités dans l'occurence voulue

  Principe :
    On passe en revue tous les mots retenus, on prend leur distance
    par rapport à l'occurence suivante. Si cette occurence est trop
    rapprochée (distance_min ou la distance par défaut) alors on génènre une
    proximité (instance Proximité).

=end
class Occurences

  # Recherche les proximités qui peuvent exister dans un texte.
  def check_proximites
    distance = distance_min
    # Le mot précédent
    last_imot = nil

    puts "indexes: #{indexes.inspect}"
    STDOUT.flush

    # Boucle sur tous les indexs de mots
    indexes.each do |index_mot|
      imot = texte.mots[index_mot]
      last_imot && last_imot.trop_proche_de?(imot, distance) && begin
        # <= Une proximité a été détectée
        # => C'est peut-être un mauvaise proximité, mais il faut déjà vérifier
        #    pour voir s'il ne s'agit pas d'une locution répétitive. Pour ce
        #    faire, on doit prendre le mot avant, le mot juste après le mot
        #    avant et le mot après.
        Texte::Mot.locution_repetitive?(last_imot, imot) || begin
          # => Il faut créer une proximité
          # puts "Le mot #{imot.mot_base.inspect} à #{last_imot.offset} est trop proche de celui à #{imot.offset} (distance = #{distance})"
          # puts "last_imot = #{last_imot.mot}:#{last_imot.offset} / imot = #{imot.mot}:#{imot.offset}"
          # STDOUT.flush
          prox = Proximity.new(last_imot, imot, distance)
          self.proximites << prox.id
        end
      end
      last_imot = imot
    end
  end

end #/Occurences
class Texte
class Mot
  def trop_proche_de? imot, distance
    (imot.offset - self.offset) < distance
  end
end#/Mot
end #/Texte
