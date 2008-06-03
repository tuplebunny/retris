class StateMachine
  
  attr_accessor :base
  
  include Gosu
  
  def initialize(base)
    self.base = base
  end
  
  def update
  end
  
  def draw
  end
  
  def button_down(id)
  end
  
  def button_up(id)
  end
    
end