# encoding: UTF-8
=begin

  Module fonctionnement avec le module cli.rb qui permet de définir, pour
  l'application propre, la conversion des diminutifs.

=end

class CLI
  DIM_OPT_TO_REAL_OPT = {
    'c'               => 'check',
    'i'               => 'interactif',
    'o'               => 'output',
    'prog'            => 'programmation',
    'prox'            => 'proximite',
    'proxs'           => 'proximites',
    's'               => 'show',
    't'               => 'texte',
    'tr'              => 'traited',
    'vb'              => 'verbose',

    'cur'             => 'current',
    'dev'             => 'developpement',
    'sim'             => 'simule',
    'now'             => 'today'
  }
end#/CLI
