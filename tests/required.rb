# encoding: UTF-8
=begin

Utile pour les tests

=end

# === MÉTHODES DE TEST ===

# Jouer une commande et retourner le résultat
def run cmd, quiet = false
  cmd = cmd.sub(/^proximite/,'proximite --test ')
  res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}"`
  # quiet || puts(res)
  self.test_retour = res
  return res
end

def retour_ne_contient_pas searched, into = nil
  into ||= test_retour
  if test_find_in(into, searched) then
    add_failure "Le retour :\n\n\t“““#{into.strip}”””\n\n… NE DEVRAIT PAS contenir \n\n\t“““#{searched}”””"
  else
    add_success "Le retour contient bien le texte #{searched.gsub(/\n/,'¶')}"
  end
end
def retour_contient searched, into = nil
  into ||= test_retour
  if test_find_in(into, searched) then
    add_success "Le retour contient bien le texte #{searched.gsub(/\n/,'¶')}"
  else
    add_failure "Le retour :\n\n\t“““#{into.strip}””” \n\n… devrait contenir \n\n\t“““#{searched}”””"
  end
end


def fin_tests
  puts "\n\n\n"
  methode = failure_list.empty? ? :vert : :rouge
  puts "#{success_list.count} success  -  #{failure_list.count} failures".send(methode)
  puts "\n\n"
  unless failure_list.empty?
    failure_list.each do |err|
      puts err.rouge
    end
  end
  if defined?(DETAILED) && DETAILED
    unless success_list.empty?
      success_list.each do |succ|
        puts "\t#{succ.vert}"
      end
    end
  end
end

# === MÉTHODES FONCTIONNELLES ===

def test_retour ; @test_retour end
def test_retour= value ; @test_retour = value end

def failure_list  ; @failure_list ||= Array.new   end
def success_list  ; @success_list ||= Array.new   end
def add_success mess
  success_list << mess
  print '*'.vert
  STDOUT.flush # mais ne fonctionne pas sans retour chariot
end
def add_failure mess
  failure_list << mess
  print 'F'.rouge
  STDOUT.flush # mais ne fonctionne pas sans retour chariot
end
def test_find_in retour, searched
  retour = retour.gsub(/\033\[0(.*?)m/,'').gsub(/ +/, ' ')
  return retour.include?(searched)
end

require './lib/required'
