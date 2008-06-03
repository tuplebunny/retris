require 'rubygems'

require 'object'
require 'yaml'
require 'array'
require 'enumerator'
require 'pp'
require 'gosu'
require 'audible'
require 'game_window'
require 'state_machine'
require 'states/initial_state'
require 'states/playing_state'

game = GameWindow.new
game.show