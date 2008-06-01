class Location
  
  attr_reader :column, :row, :block
  
  def initialize(options)
    @column, @row, = options[:column], options[:row]
    @block = options[:block]
  end
  
  def initialize_copy(old)
    @column = old.column
    @row = old.row
    @block = old.block
  end

  # This is printing nil.
  #
  def draw
    return false unless occupied?
    @block.draw(self)
  end
  
  def occupied?
    !!@block
  end
  
  def clear
    @block = nil
  end
  
  def hash
    %{C#{ @column } R#{ @row }}
  end

  def eql?(other)
    hash == other.hash
  end
  
  def ==(other)
    hash == other.hash
  end
  
  # Possible point of errors with :block =>.
  #
  def offset(location)
    self.class.new(:column => column + location.column, :row => row + location.row, :block => @block.dup)
  end
  
  def move_left
    @column -= 1
  end
  
  def move_right
    @column += 1
  end
  
  def move_down
    @row += 1
  end
  
end