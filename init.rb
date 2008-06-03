require 'rubygems'

require 'ruby_extensions/object'
require 'yaml'
require 'ruby_extensions/array'
require 'enumerator'
require 'pp'
require 'gosu'
require 'lib/audible'
require 'objects/game_window'
require 'objects/state_machine'
require 'states/initial_state'
require 'states/playing_state'

game = GameWindow.new
game.show