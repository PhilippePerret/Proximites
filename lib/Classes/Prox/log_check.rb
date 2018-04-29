# encoding: UTF-8
class Prox
class << self

  def log_check?
    if @log_check_required === nil
      @log_check_required = CLI.options[:log]
      @log_check_required && begin
        load_module('log_check')
        Prox::LogCheck.init
      end
    end
    return @log_check_required
  end

end #<< self
end #/Prox
