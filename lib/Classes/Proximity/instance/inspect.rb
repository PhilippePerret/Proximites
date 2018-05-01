# encoding: UTF-8
class Proximity

  # Pour une inspection plus parlante
  def inspect
    "PROXIMITY ID ##{id}"+RET+
    "mot avant : #{mot_avant.inspect}" +RET+
    "mot après : #{mot_apres.inspect} (à #{mot_apres.offset - mot_avant.offset} signes)"+ RET+
    "Treated? #{treated?.inspect} / Deleted? #{deleted?.inspect}"
  end

end #/Proximity
