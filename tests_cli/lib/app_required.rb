# encoding: UTF-8
#
# Module chargé par l'application CLI quand l'option --test est utilisé
#
Dir['./tests_cli/lib/app/**/*.rb'].each{|m|require(m)}
Dir['./tests_cli/lib/required/Tests/**/*.rb'].each{|m|require(m)}
