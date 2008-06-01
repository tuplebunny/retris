class GridLocation
  
  attr_accessor :block
  
  def self.load_block(window)
    @block ||= Gosu::Image.new(window, "media/grid-block.png", true)
    @block_2 ||= Gosu::Image.new(window, "media/block.png", true)
  end
  
  def self.block
    @block
  end
  
  def self.block2
    @block_2
  end
  
  attr_reader :column, :row, :filled
  
  def initialize(options)
    @column, @row, @filled = options[:column], options[:row], !!options[:filled]
  end
  
  def block_size
    25
  end
  
  def draw
    # return nil if @filled.nil?
    if occupied?
      @block.draw(self)
    else
      # self.class.block.draw(@column * block_size + 50, @row * block_size + 50, 0)
    end
  end
  
  def clear
    @block = nil
  end
  
  def offset(location)
    self.class.new(:column => column + location.column, :row => row + location.row, :filled => filled)
  end
  
  def hash
    %{C#{ @column } R#{ @row }}
  end
  
  def occupied?
    !!@block
  end
  
  def fill!
    @filled = true
  end
  
  def filled?
    @filled == true
  end
  
  def empty?
    not occupied?
  end

  def eql?(other)
    hash == other.hash
  end
  
  def ==(other)
    hash == other.hash
  end
  
end