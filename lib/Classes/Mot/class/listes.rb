# encoding: UTF-8
class Texte
  class Mot
    class << self

      # Retourne un Hash avec la liste des longs mots à éviter. Ils sont pris
      # dans la liste définie dans le dossier ./data
      def longs_mots_a_eviter
        @longs_mots_a_eviter ||= begin
          h = Hash.new ; LONGS_MOTS_A_EVITER.each do |mot|
            h.merge!(mot.my_downcase => true)
          end ; h
        end
      end

      # Retourne un Hash avec la liste des mots courts à traiter. Ils sont pris
      # dans la liste définie dans le dossier ./data
      def mots_courts_a_prendre
        @mots_courts_a_prendre ||= begin
          h = Hash.new ; MOTS_COURTS_A_TRAITER.each do |mot|
            h.merge!(mot.my_downcase => true)
          end ; h
        end
      end


    end #/ << self
  end #/Mot
end #/Texte
