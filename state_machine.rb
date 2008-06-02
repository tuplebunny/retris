module StateMachine
  class Base
    
    include Gosu
    
    def self.bootstrap(game_window)
      @@game_window = game_window
    end
    
    def self.initial_state
      Loading.new
    end
    
    def game_window
      @@game_window
    end
    
  end
end