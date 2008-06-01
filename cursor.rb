class Cursor

  attr_accessor :location, :shape
  
  def initialize(options)
    @location, @shape = options[:location], options[:shape]
  end
  
  def locations
    @shape.locations(@location)
  end
  
  def draw
    locations.each { |location| location.draw }
  end
  
  def move_left
    @location.move_left
    self
  end
  
  def move_right
    @location.move_right
    self
  end
  
  def move_down
    @location.move_down
    self
  end
  
  def rotate_clockwise
    @shape.rotate_clockwise
    self
  end
  
  def pretend
    self.class.new(:location => @location.clone, :shape => @shape.clone)
  end
  
end