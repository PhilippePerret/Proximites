# encoding: UTF-8
=begin
  Méthodes et données de listes classées (principalement par nombre et
  par mot alphabétique)
=end
class Occurences
class << self

  def table_sorted_by_count
    @table_sorted_by_count ||= begin
      table_filtred.sort_by{|occu| - occu.count}
    end
  end

  def table_sorted_by_mot
    @table_sorted_by_mot ||= begin
      table_filtred.sort_by{|occu| occu.mot}
    end
  end

  def table_filtred
    tbl = table.values
    CLI.options[:treated] && begin
      tbl = tbl.reject { |occu| !occu.traitable? }
    end
    CLI.options[:only] && tbl = tbl[0..(CLI.options[:only].to_i - 1)]

    return tbl
  end

end #/<< self
end #/Occurences
