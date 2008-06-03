class LoadingState < StateMachine::Base

  def initialize
    Audible.bootstrap(self)
    game_objects[:loading_bg] = Gosu::Image.new(game_window, 'media/loading-screen.png', true)
  end
  
  def update
    if loaded?
      load_resources
    else
      
    end
  end
  
  def draw
    game_objects[:loading_bg].draw(0, 0, 0)
  end
  
  def button_down(id)
    close if id == Gosu::Button::KbEscape
  end
  
  def button_up(id)
  end
  
  protected
  
    def loaded?
      @loaded ||= false
    end
  
    def load_resources
      return
      required_files.each { |file| require(file) }

      Block.bootstrap(game_window)
      GridLocation.load_block(game_window)
      Shape.bootstrap

      game_objects[:background] = Gosu::Image.new(self, 'media/bg.png', true)
      game_objects[:grid] = Grid.new(:columns => 10, :rows => 20)
      game_objects[:cursor] = Cursor.new(:shape => Shape.random, :location => @grid.cursor_origin)
      game_objects[:score] = Gosu::Font.new(self, Gosu::default_font_name, 40)
    end
    
    def required_files
      %w{
        row
        location
        shape_location
        grid_location
        block
        shape
        grid
        cursor
        tetris
      }
    end
  
end