# encoding: UTF-8
=begin
  Module contenant toutes les méthodes d'état des occurences, pour savoir,
  par exemple, si la proximité des mots doit être checkée
=end
class Occurences


  # @return TRUE si le mot doit être traité en proximité
  #
  def traitable?
    @occurences_traitable === nil || begin
      Prox.log_check? && Prox.log_check("\t\t#{@occurences_traitable ? 'traitable' : 'non traitable'}")
      return @occurences_traitable
    end
    # Toute les conditions ci-dessous doivent être réunies
    self.raison_non_traitable = check_if_traitable
    @occurences_traitable = self.raison_non_traitable.nil?
    Prox.log_check? && begin
      mess = @occurences_traitable ? 'traitable' : "non traitable (#{raison_non_traitable})"
      Prox.log_check("\t\tDéfini comme #{mess}")
    end
    @occurences_traitable
  end

  def check_if_traitable
    mot_length == 0 && (return 'vide')
    count > 1 || (return 'unique')
    mot_length > 2 && self.long_a_eviter?     && (return 'mot long à éviter')
    mot_length < 3 && !self.court_a_prendre?  && (return 'mot trop court')
    return nil # aucune raison de ne pas le traiter
  end

  # Retourne TRUE si c'est un mot long à éviter
  # Note : la longueur doit déjà avoir été traitée
  def long_a_eviter?
    Texte::Mot.longs_mots_a_eviter[mot] == true
  end
  # Retourne TRUE si c'est un mot court à prendre
  # Note : la longueur doit déjà avoir été testée
  def court_a_prendre?
    Texte::Mot.mots_courts_a_prendre[mot] == true
  end

end #/Occurences
