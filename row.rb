class Row
  
  attr_accessor :locations
  
  def initialize
    @locations = Array.new
  end
  
  def clear
    @locations.each { |location| location.clear }
  end
  
  def <<(location)
    @locations << location
  end
  
  # It is expected the lower row is empty. Concentrate on occupied locations.
  #
  def move_into(lower_row)
    @locations.each do |location|
      if location.occupied?
        lower_row.locations.find { |lrl| lrl.column == location.column }.block = location.block.dup
        location.clear
      end
    end
  end
  
  def complete?
    @locations.all? { |location| location.occupied? }
  end
  
  def incomplete?
    not complete? and not empty?
  end
  
  def empty?
    @locations.all? { |location| location.empty? }
  end
  
  # Best guess as to my index.
  #
  def index
    @locations.first.row
  end
  
end