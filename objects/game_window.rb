class GameWindow < Gosu::Window

  attr_accessor :state

  def initialize
    super(600, 600, false)
    self.caption = "Retris"
    @state = InitialState.new(self)
  end
  
  def update
    @state.update
  end
  
  def draw
    @state.draw
  end

  def button_down(id)
    @state.button_down(id)
  end
  
  def button_up(id)
    @state.button_up(id)
  end
  
  def game_objects
    @game_objects ||= Hash.new
  end
    
end