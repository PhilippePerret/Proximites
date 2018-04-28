#!/usr/bin/env ruby
# encoding: UTF-8
#
# CLI 1.1.0
#
# Note : l'application doit définir :
#   class CLI
#     DIM_OPT_TO_REAL_OPT = {
#       '<diminutif>' => '<version longue>',
#       '<diminutif>' => '<version longue>',
#       etc.
#     }
#
class CLI

  class << self

    attr_accessor :command, :params, :options

    attr_accessor :last_command # sans l'application

    # Pour savoir si c'est la ligne de commande qui est utilisée
    def command_line?
      true
    end

    # Utiliser CLI.verbose? pour savoir si c'est le mode verbeux ?
    # Utiliser l'option --verbose ou -vb mais définir alors dans le
    # DIM_OPT_TO_REAL_OPT de l'application : 'vb' => 'verbose'
    def verbose?
      self.options && self.options[:verbose]
    end
    def quiet?
      self.options && self.options[:quiet]
    end

    # Initialisation de CLI
    def init
      # La commande = le premier mot (pas forcément)
      self.command= nil
      # log "Commande : #{CLI.command.inspect}"
      self.options  = Hash.new
      self.params   = (a = Array.new ; a << nil ; a)
    end

    # Analyse de la ligne de commande
    def analyse_command_line arguments_v = nil
      arguments_v ||= ARGV
      init
      # On mémorise la dernière commande, c'est-à-dire la ligne complète fournie
      # à cette méthode.
      self.last_command = (arguments_v||[]).join(' ')

      # Ensuite, on peut trouver des paramètres ou des options. Les options
      # se reconnaissent au fait qu'elles commencent toujours par "-" ou "--"
      # puts "ARGV : #{ARGV.inspect}"
      arguments_v.empty? || begin
        arguments_v.each do |argv|
          if argv.start_with?('-')
            traite_arg_as_option argv
          elsif self.command.nil?
            self.command = (DIM_OPT_TO_REAL_OPT[argv] || argv).gsub(/\-/,'_')
          else
            traite_arg_as_param argv
          end
        end
      end
      return true
    end

    def traite_arg_as_option arg
      if arg.start_with?('--')
        opt, val = arg[2..-1].strip.split('=')
      else # is start_with? '-'
        # <= diminutif
        opt_dim, val = arg[1..-1].strip.split('=')
        opt = DIM_OPT_TO_REAL_OPT[opt_dim]
        opt != nil || begin
          error "L'option #{opt_dim.inspect} est inconnue…"
          return
        end
      end
      self.options.merge!(opt.to_sym => real_val_of(val))
    end

    # La vraie valeur de l'option, qui est exprimée forcément en
    # string.
    # Noter que nil retourne true
    def real_val_of val
      case val
      when 'false'        then false
      when 'true'         then true
      when 'null', 'nil'  then nil
      when /^[0-9]+$/       then val.to_i
      when /^[0-9\.]+$/     then val.to_f
      when nil            then true
      else
        val
      end
    end

    def traite_arg_as_param arg
      self.params << arg
    end

    # Messagerie
    def log mess
      puts "\033[1;94m#{mess}\033[0m"
    end
    def error err_mess
      puts "\033[1;31m#{err_mess}\033[0m"
      return false
    end

  end #/<< self
end #/CLI
