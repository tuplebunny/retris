class Grid
  
  def initialize(options)
    @rows, @columns = options[:rows], options[:columns]
  end
  
  def cursor_origin
    Location.new(:column => 5, :row => 0)
  end
  
  def draw
    locations.each { |l| l.draw }
  end
  
  def locations
    @locations ||= returning(Array.new) do |locations|
      @rows.times do |row_i|
        @columns.times do |column_i|
          locations << GridLocation.new(:column => column_i, :row => row_i)
        end
      end
    end
  end
  
  def completed_rows
    rows.select { |row| row.complete? }
  end
  
  def find_row_by_index(index)
    rows.find { |row| row.index == index }
  end
  
  def clear_completed_rows
    completed_row_count = completed_rows.size
    highest_row_cleared_index = completed_rows.first.index
    completed_rows.each { |completed_row| completed_row.clear }
    
    rows.reverse.each do |row|
      next if row.index >= highest_row_cleared_index
      next if row.empty?
      row.move_into(find_row_by_index(row.index + completed_row_count))
    end
  end
  
  def rows
    @row_objects ||= returning(Array.new) do |rows|
      locations.each do |location|
        rows[location.row] ||= Row.new
        rows[location.row] << location
      end
    end
  end
  
  # We do this for speed reasons. The rows method is called several times in a
  # single Gosu update operation. This allows us build those objects once per
  # update.
  #
  def reset_row_objects
    @row_objects = nil
  end
  
end