# encoding: UTF-8
=begin
  Module affichant l'aide pour la programmation
=end
class Prox
class << self

  def display_help
    HelpFile.new(help_user_path).display
  end
  def help_user_path
    @help_user_path ||= File.join(folder_module,'aide','help_user_text.txt')
  end

  def display_help_programmation
    HelpFile.new(help_dev_path).display
  end
  def help_dev_path
    @help_dev_path ||= File.join(folder_module,'aide','help_dev_text.txt')
  end

end #/<< self
end #/Prox
