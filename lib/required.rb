# encoding: UTF-8
require 'json'

Dir["./lib/Extensions/**/*.rb"].each{|m|require m}
CLI.analyse_command_line
Dir["./lib/Classes/**/*.rb"].each{|m|require m}
Dir["./data/required/**/*.rb"].each{|m|require m}
