# encoding: UTF-8

# Jouer une commande et retourner le résultat produit à l'écran
# On peut le tester ensuite avec `retour_contient` `retour_ne_contient_pas`
def run cmd, quiet = false
  cmd = cmd.sub(/^prox(imite)?/,'proximite --test ')
  res = `bash -c ". /Users/philippeperret/.bash_profile; shopt -s expand_aliases\n#{cmd}"`
  # quiet || puts(res)
  self.test_retour = res
  return res
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

  # À la fin des tests, on lit le fichier Tests::Log et si on trouve des
  # messages d'erreur, on les affiche.
  Tests::Log.display_errors_messages
end
