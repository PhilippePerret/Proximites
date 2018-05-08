# encoding: UTF-8
=begin
  Module des méthodes d'instanciation d'une instance Occurences
=end
class Occurences
  
  # La méthode avec un "s" (check_proimites) checke toutes les proximités de
  # l'occurence du mot, celle-ci ne checke que le motA et le motB et crée
  # l'instance de proximité si une proximité est décellée
  def check_proximite motA, motB
    motA && motA.trop_proche_de?(motB, distance_min) || return
    # <= Une proximité a été détectée
    # => C'est peut-être un mauvaise proximité, mais il faut déjà vérifier
    Prox.log_check? && Prox.log_check("\t\t\t\tProximité détectée avec le mot précédent (à tester)")
    #    pour voir s'il ne s'agit pas d'une locution répétitive. Pour ce
    #    faire, on doit prendre le mot avant, le mot juste après le mot
    #    avant et le mot après.
    Texte::Mot.locution_repetitive?(motA, motB) && return
    # Pour voir s'il ne s'agit pas de mot à distance minimum fixe qui sont
    # trop éloignés
    Texte::Mot.distance_minimum_fixe_too_big?(motA, motB) && return

    # => Il faut créer une proximité
    Prox.log_check? && Prox.log_check("\t\t\t\tPROXIMITÉ CONFIRMÉE")
    # puts "Le mot #{motB.mot_base.inspect} à #{motA.offset} est trop proche de celui à #{motB.offset} (distance = #{distance})"
    # puts "motA = #{motA.mot}:#{motA.offset} / motB = #{motB.mot}:#{motB.offset}"
    # STDOUT.flush
    prox = Proximity.new(motA, motB, distance_min)
    # On ajoute l'ID de la nouvelle proximité à la liste des proximités
    # de l'occurence de mot.
    self.proximites << prox.id
    # On ajoute cet ID également au mot avant et au mot après
    motA.add_proximite(prox, apres = true)
    motB.add_proximite(prox, apres = false)
  end
  # /check_proximite

end #/Occurences
