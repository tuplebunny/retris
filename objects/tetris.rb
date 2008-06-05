class Tetris
  
  include Audible
  
  sample :name => :dock, :filename => 'media/docking.wav'
  sample :name => :crash, :filename => 'media/crash.mp3'
  
  def valid_position?(options)
    return false if out_of_bounds?(options)
    return false if blocks_overlap?(options)
    true
  end
  
  def docked?(options)
    if valid_position?(:grid => options[:grid], :cursor => options[:cursor].pretend.move_down)
      false
    else
      true
    end
  end
  
  def assimilate(options)
    play_sample(:dock)
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
  def blocks_overlap?(options)
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
  def out_of_bounds?(options)
    grid, cursor = options[:grid], options[:cursor]
    
    cursor.locations.any? do |cursor_location|
      not grid.locations.include?(cursor_location)
    end
  end
  
  def add_to_score(lines)
    self.lines[lines] ||= 0
    self.lines[lines] += 1
  end
  
  def lines
    @lines ||= Hash.new
  end
  
  def score
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
  
  def total_lines
    lines.inject(0) { |sum, key_value_array| sum + (key_value_array.first * key_value_array.last) }
  end
  
  def player_lost
    play_sample(:crash)
    @player_lost = true
  end
  
  def end_game
  end
  
  def player_lost?
    !!@player_lost
  end
  
  def difficulty_level
    total_lines.divmod(10).first
  end
  
  def drop_rate
    drop_rate = 2000 - (difficulty_level * 90)
    if drop_rate >= 1800
      200
    else
      drop_rate
    end
  end
  
end