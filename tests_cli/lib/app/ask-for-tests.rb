# encoding: utf-8
#
# ask-for-test
# v. 1.2
#
# Voir aussi le module Extension/ask.rb qui fonctionne en parallèle de celui-ci
#


def getc message
  return Tests.next_reponse(from: 'getc')
end

# Pose la +question+ est retourne TRUE si la réponse est oui (dans tous les
# formats possible) ou FALSE dans le cas contraire.
#
# Attention, en mode test, ces méthodes sont surclassées par les méthodes
# de test
#
def yesOrNo question
  # Tests.suivi("-> yesOrNo('#{question}')")
  case Tests.next_reponse(from: "yesOrNo(#{question.inspect})")
  when 'true', 'o', 'oui', 'y', 'yes' # next_reponse retourne toujours un string
    true
  else
    false
  end
end

# Pose la +question+ qui attend forcément une valeur non nulle et raise
# l'exception +msg_error+ dans le cas contraire.
def askForOrRaise(question, msg_error = "Cette donnée est obligatoire")
  val = Tests.next_reponse(from: "askForOrRaise(#{question.inspect})")
  val.is_a?(Array) || raise('Pour un askForOrRaise, il faut fournir un Array avec en première valeur la réponse donnée en ligne de commande et en seconde valeur le message de l’erreur générée. Elle sera générée si la première valeur est vide.')
  r, msg_error = val
  r || r != '' || raise(msg_error)
  return r
end

# Pose la +question+ et retourne la réponse, même vide.
def askFor(question, default = nil)
  Tests.next_reponse(from: "askFor(#{question.inspect})")
end



# @param {Hash} params
#               :default    Valeur par défaut à mettre dans le fichier
#               Si c'est un string, c'est le message à afficher avant
def askForText params = Hash.new
  Tests.next_reponse(from: "askForTest(default: #{params[:default].inspect})")
end
