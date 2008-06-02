# Enables objects to play their own samples.
#
# Example:
#
#   class Player
#
#     include Audible
#
#     sample :hi, 'media/hi.wav'
#
#     def say_hi
#       play_sample(:hi)
#     end
#
#   end
#
module Audible
  
  def self.bootstrap(gosu_window)
    puts "Bootstrapping audible with #{ gosu_window }"
    @gosu_window = gosu_window
  end
  
  module ClassMethods
    
    attr_reader :samples

    def sample(options)
      puts "gosu window is: #{ @gosu_window }"
      @samples ||= Hash.new
      @samples[options[:name]] = Gosu::Sample.new(@gosu_window, options[:filename])
    end
    
  end

  # Pass the gosu window to the receiving object, then extend that object with
  # some fancy class-level methods.
  #
  def self.included(receiver)
    puts "Inside included, self is: #{ self }"
    puts "Inside included, receiver is: #{ receiver }"
    gosu_window = @gosu_window
    puts "Inside included, gosu is: #{@gosu_window}"
    receiver.instance_variable_set(:@gosu_window, @gosu_window)
    
    #receiver.class.class_eval do
    #  puts "Inside class_eval, self is: #{ self }"
    #  puts "And my ancestors are: #{ self.ancestors }"
    #  @gosu_window = gosu_window
    #end
    
    receiver.extend(ClassMethods)
  end
 
  def play_sample(name)
    samples[name].play
  end
  
  def samples
    self.class.samples
  end
  
end