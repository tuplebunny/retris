class Array
  
  def next_element
    @count.nil? ? @count = size + 1 : @count += 1
    self[@count % size]
  end
  
  def previous_element
    @count.nil? ? @count = size + 1 : @count -= 1
    self[@count % size]
  end
  
  def next_index
    @count.nil? ? @count = size + 1 : @count += 1
    @count % size
  end
  
  def previous_index
    @count.nil? ? @count = size + 1 : @count -= 1
    @count % size
  end
  
  def current
    @count ||= 0
    self[@count]
  end
  
  def randomize
    sort_by { rand }
  end
  
end