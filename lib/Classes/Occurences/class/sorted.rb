# encoding: UTF-8
=begin
  Méthodes et données de listes classées (principalement par nombre et
  par mot alphabétique)
=end
class Occurences
class << self

  def table_sorted_by_count
    @table_sorted_by_count ||= begin
      table.values.sort_by{|occu| - occu.count}
    end
  end

  def table_sorted_by_mot
    @table_sorted_by_mot ||= begin
      table.values.sort_by{|occu| occu.mot}
    end
  end

end #/<< self
end #/Occurences
