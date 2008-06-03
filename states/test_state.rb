class TestState < StateMachine
  
  def initialize(base)
    super
    @block = Gosu::Image.new(base, 'media/block.png', true)
  end
  
  def draw
    @block.draw(0, 0, 0)
  end
  
end