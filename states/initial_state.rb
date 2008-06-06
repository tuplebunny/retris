class InitialState < StateMachine

  def initialize(base)
    super
    Audible.bootstrap(base)
    @loading_screen = Gosu::Image.new(base, 'media/loading-screen.png', true)
    @loaded = false
  end
  
  def update
    unless @loaded
      required_files.each { |file| puts "Requiring file: #{ file }"; puts require(file) }

      Block.bootstrap(base)
      GridLocation.load_block(base)
      Shape.bootstrap

      base.game_objects[:background] = Gosu::Image.new(base, 'media/bg.png', true)
      base.game_objects[:grid] = Grid.new(:columns => 10, :rows => 20)
      base.game_objects[:cursor] = Cursor.new(:shape => Shape.random, :location => base.game_objects[:grid].cursor_origin)
      base.game_objects[:next_shape] = Shape.random
      base.game_objects[:score] = Gosu::Font.new(base, Gosu::default_font_name, 40)
      base.game_objects[:tetris] = Tetris.new
    
      @loaded = true
    else
      base.state = PlayingState.new(base)
    end
  end
  
  def draw
    @loading_screen.draw(0, 0, 0)
  end
  
  def button_down(id)
  end
  
  def button_up(id)
  end
  
  protected
  
    def required_files
      %w{
        objects/row
        objects/location
        objects/shape_location
        objects/grid_location
        objects/block
        objects/shape
        objects/grid
        objects/cursor
        objects/tetris
      }
    end
  
end