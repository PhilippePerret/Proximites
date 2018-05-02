# encoding: UTF-8
=begin

Utile pour les tests

=end

# === MÉTHODES DE TEST ===

FOLDERTESTS = File.dirname(File.dirname(File.expand_path(__FILE__)))
defined?(THISFOLDER) || THISFOLDER = File.dirname(FOLDERTESTS)

# On charge la librairie de l'application
# Il faut le faire absolument avant de charger les modules de tests, qui
# surclassent certaines méthodes
require './lib/required'

# On charge tous les modules de tests
# On surclasse toutes les méthodes interactives (module ask -> ask-for-tests)
Dir[FOLDERTESTS+'/lib/required/**/*.rb'].each{|m|load(m)}
# Dir[FOLDERTESTS+'/lib/required/**/*.rb'].each{|m|require(m)}
# Les modules propres à l'application s'ils existent
Dir[FOLDERTESTS+'/lib/app_tests_cli/**/*.rb'].each{|m|load(m)}

Tests.init
