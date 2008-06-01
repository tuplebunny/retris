class Tetris
  
  def self.valid_position?(options)
    return false if out_of_bounds?(options)
    return false if blocks_overlap?(options)
    true
  end
  
  def self.docked?(options)
    if valid_position?(:grid => options[:grid], :cursor => options[:cursor].pretend.move_down)
      false
    else
      true
    end
  end
  
  def self.assimilate(options)
    grid, cursor = options[:grid], options[:cursor]
    
    cursor.locations.each do |cursor_location|
      grid.locations.find do |grid_location|
        cursor_location == grid_location
      end.block = cursor_location.block.dup
    end
  end
  
  # Are there any locations in shape that are filled in the grid? If so we
  # have a shape that is trying to sit on top of an already-occupied
  # location.
  #
  def self.blocks_overlap?(options)
    grid, cursor = options[:grid], options[:cursor]
    
    cursor.locations.any? do |cursor_location|
      grid.locations.find do |grid_location|
        cursor_location == grid_location && grid_location.occupied?
      end
    end
  end
  
  # Are all shape locations present in grid? If not we have a shape who is
  # trying to move outside the boundaries of the grid.
  #
  def self.out_of_bounds?(options)
    grid, cursor = options[:grid], options[:cursor]
    
    cursor.locations.any? do |cursor_location|
      not grid.locations.include?(cursor_location)
    end
  end
  
  def self.add_to_score(lines)
    self.lines[lines] ||= 0
    self.lines[lines] += 1
  end
  
  def self.lines
    @lines ||= Hash.new
  end
  
  def self.score
    score = 0
    
    lines.each do |combo, times|
      if combo == 4
        score += 4 * 10 * 2
      else
        score += 10 * combo * times
      end
    end
    
    score
  end
  
end