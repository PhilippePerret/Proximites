# encoding: UTF-8
=begin

  version 1.0.0

  Le module `HelpFile.rb` permet d'afficher correctement une aide en couleur
  dans le Terminal à l'aide de less.

  @usage

    helpfile = HelpFile.new(path)
    helpfile.read

    <path>
      Path absolu du fichier contenant le texte qui sera évalué dans le contexte
      du programme, donc qui peut contenir des #{ma_variable} et autres appels à
      fonction comme #{'bonjour'.bleu}.

=end
class HelpFile

  # Le path du fichier contenant le texte
  attr_reader :original_path
  attr_reader :texte

  # Lecture, page par page, du fichier d'aide
  def read
    up_to_date? || prepare_et_save
    system "less -R \"#{path}\""
  end
  alias :display :read

  def initialize original_path
    @original_path   = original_path
    File.exist?(original_path) || raise('Le fichier contenant le texte de l’aide doit impérativement exister. Je ne trouve pas “%s”.' % [original_path])
  end

  # Le fichier construit avec le texte final
  def path
    @path ||= File.join(folder,".HF#{name}")
  end
  # Si on définit le texte
  def prepare_et_save
    prepare
    save
  end

  def prepare
    @texte = eval('"' + File.read(original_path).gsub(/"/,'\\"') + '"')
  end

  def save
    File.open(path,'wb'){|f|f.write texte}
  end

  def up_to_date?
    File.exist?(path) && File.stat(path).mtime > File.stat(original_path).mtime
  end

  def name    ; @name     ||= File.basename(original_path)  end
  def folder  ; @folder   ||= File.dirname(original_path)   end

end #/HelpFile
