# encoding: UTF-8


def error err_mess, options = nil
  puts "\n#\n#\t#{err_mess}\n#\n".rouge_gras
end
def message mess, options = nil
  puts mess.bleu_gras
end
alias :notice :message

def suivi msg
  (!CLI.quiet? || CLI.options[:log]) && log(msg)
  CLI.verbose? && puts(msg)
end
