# encoding: UTF-8
class Log
class << self
  def log msg
    reflog.puts "#{Time.now.strftime('%d-%m-%Y %H:%M')}   #{msg}"
  end
  def reflog
    @reflog ||= begin
      File.exist?(logpath) && File.unlink(logpath) # ou pas pour tout garder
      File.open(logpath,'a')
    end
  end
  def logpath ; @logpath ||= File.join(THISFOLDER,'journal.log') end
end #/<< self
end #/Log

def log msg ; Log.log(msg) end
