# encoding: utf-8
#
# ask
# v. 1.0
#


# Pose la +question+ est retourne TRUE si la réponse est oui (dans tous les
# formats possible) ou FALSE dans le cas contraire.
def yesOrNo question
  print "#{question} (y/o/yes/oui ou n/non) : "
  r = STDIN.gets.strip
  case r.upcase
  when 'N','NO','NON', '' then return false
  else return true
  end
end

# Pose la +question+ qui attend forcément une valeur non nulle et raise
# l'exception +msg_error+ dans le cas contraire.
def askForOrRaise(question, msg_error = "Cette donnée est obligatoire")
  print "#{question} : "
  r = STDIN.gets.strip
  r != '' || raise(msg_error)
  return r
end

# Pose la +question+ et retourne la réponse, même vide.
def askFor(question, default = nil)
  default && question << " (défaut : #{default}) "
  print "#{question} : "
  retour = STDIN.gets.strip
  retour != '' ? retour : default
end



# @param {Hash} params
#               :default    Valeur par défaut à mettre dans le fichier
#               Si c'est un string, c'est le message à afficher avant
def askForText params = Hash.new
  case params
  when String then params = {message: params}
  end

  params[:message] && (puts params[:message])
  q = "Êtes-vous prêt ?"
  q << (params[:required] ? ' (donnée requise)' : " (choisissez `n` ou `Entrée` pour passer cette propriété)")
  if yesOrNo(q)
    fp = './.te.txt'
    File.unlink(fp) if File.exist?(fp)
    File.open(fp,'wb'){|f| f.write "#{params[:default]}\n"}
    `mate "#{File.expand_path(fp)}"`
    if yesOrNo "Puis-je prendre le contenu du fichier ?"
      begin
        yesOrNo("Le fichier est-il bien enregistré et fermé ?") || raise
      rescue
        retry
      end
      contenu = File.read(fp).force_encoding('utf-8').nil_if_empty
      contenu.nil? && params[:required] && raise("Cette donnée est obligatoire. Je dois m'arrêter là.")
      #File.exist?(fp) && File.unlink(fp)
      puts "CONTENU :\n#{contenu}"
      return contenu
    end#/Si ruby peut prendre le code de la signature
  end#/En attendant que l'utilisateur soit prêt
  params[:required] &&  raise("Cette donnée est obligatoire. Je dois m'arrêter là.")
  return nil
end
