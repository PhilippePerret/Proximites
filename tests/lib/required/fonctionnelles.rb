# encoding: UTF-8

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
