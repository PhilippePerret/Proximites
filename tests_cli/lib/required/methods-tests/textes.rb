# encoding: UTF-8
=begin
  Méthodes utilisables dans les tests pour checker le contenu d'un string
=end
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
