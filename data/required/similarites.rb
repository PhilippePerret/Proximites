class Texte
class Mot


  # Si 'mais' et 'maison' sont comparés, il va en résulter une similarité
  # au niveau des 4 premiers caractères dont des 2/3. On déclare ici que ces
  # deux mots ne sont pas similaires.
  ARR_SIMILARITES_IMPOSSIBLES = {
    'mais' => ['maison']
  }


  SIMILARITES_IMPOSSIBLES = Hash.new()
  ARR_SIMILARITES_IMPOSSIBLES.each do |court, liste_longs|
    SIMILARITES_IMPOSSIBLES.merge!(court => Hash.new)
    liste_longs.each do |long|
      SIMILARITES_IMPOSSIBLES[court].merge!(long => true)
    end
  end

end #/Mot
end #/Texte
