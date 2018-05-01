# encoding: UTF-8
require 'json'

Dir["./lib/Extensions/**/*.rb"].each{|m|require m}
CLI.analyse_command_line
Dir["./lib/Classes/**/*.rb"].each{|m|require m}
Dir["./data/required/**/*.rb"].each{|m|require m}

# Si on est en mode test
if CLI.options[:test]
  require('./tests_cli/lib/app_required')
else
  require('./tests_cli/lib/no-tests.rb')
end
