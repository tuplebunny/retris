class Shape
  
  include Audible
  
  sample :name => :rotate, :filename => 'media/rotate.wav'
  
  # Read the shapes/ directory and create a collection of instances. Each file
  # represents one shape and should contain four orientation definitions.
  #
  def self.bootstrap
    Dir.foreach('shapes') do |file|
      shapes << Shape.new(IO.read('shapes/' + file)) if file =~ /\.shape$/
    end
  end

  def self.shapes
    @shapes ||= Array.new
  end
  
  def self.random
    shapes.randomize.randomize.randomize.first.dup
  end
  
  
  
  attr_accessor :orientation
  
  def initialize(yaml)
    @color = random_color
    
    YAML.load(yaml).each do |orientation_set|
      orientations << Array.new(build_orientations_from_set(orientation_set))
    end
  end
  
  def initialize_copy(old_shape)
    @orientation = old_shape.orientation
    @orientations = old_shape.orientations.dup
  end
  
  def rotate_clockwise
    @orientation = orientations.next_index
    play_sample(:rotate)
  end
  
  def rotate_counter_clockwise
    @orientation = orientations.previous_index
  end
  
  def locations(offset_location = nil)
    return orientations[orientation] if offset_location.nil?
    
    orientations[orientation].collect do |location|
      location.offset(offset_location)
    end
  end

  # protected
  
    def orientations
      @orientations ||= Array.new
    end
  
    def orientation
      @orientation ||= 0
    end
    
    def build_orientations_from_set(orientation_set)
      returning(Array.new) do |locations|
        orientation_set.each_with_index do |row, row_i|
          row.each_with_index do |column, column_i|
            locations << Location.new(:column => column_i, :row => row_i, :block => Block.new(@color)) if column == 1
          end
        end
      end
    end
    
    def colors
      @colors ||= [
        0xFF00FFFF, # turqoise
        0xFFDC143C, # crimson
        0xFFADFF2F, # lime green
        0xFFFFD700  # gold
      ].randomize
    end
    
    def random_color
      puts "A random color was taken"
      colors.shift
    end
  
end