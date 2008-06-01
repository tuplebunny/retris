class Block
  
  def self.bootstrap(gosu_window)
    @@gosu_window = gosu_window
  end
  
  attr_reader :image, :color
  
  def initialize(color)
    @image = Gosu::Image.new(@@gosu_window, 'media/block.png', true)
    @color = color
  end
  
  def initialize_copy(old)
    @image = old.image
    @color = old.color
  end
  
  def draw(location)
    @image.draw(location.column * size + 50, location.row * size + 50, 1, 1, 1, @color)
  end
  
  def size
    25
  end
  
end