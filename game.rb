require 'rubygems'
require 'gosu'
require 'init'
require 'pp'

class GameWindow < Gosu::Window
  
  def initialize
    super(600, 600, false)
    self.caption = "Retris"
    
    @background = Gosu::Image.new(self, 'media/bg.png', true)
    Block.bootstrap(self)
    @grid = Grid.new(:columns => 10, :rows => 20)
    Shape.bootstrap
    @cursor = Cursor.new(:shape => Shape.random, :location => @grid.cursor_origin)
    GridLocation.load_block(self)
    # @score = Gosu::Font.new(self, 'media/mizufalp.ttf', 39) # Font renders ugly as hell, unfortunately...
    @score = Gosu::Font.new(self, Gosu::default_font_name, 40)
    @docked_sound = Gosu::Sample.new(self, 'media/docking.wav')
    @line_clear_sound = Gosu::Sample.new(self, 'media/clear-line.wav')
    @rotate_sound = Gosu::Sample.new(self, 'media/rotate.wav')
    @score_3 = Gosu::Sample.new(self, 'media/score-1.mp3')
    @score_instance = @score_3.play(0.5)
    @crash = Gosu::Sample.new(self, 'media/crash.mp3')
  end

  def update
    unless Tetris.player_lost?    
      if Tetris.docked?(:grid => @grid, :cursor => @cursor)
        if @cursor.top?
          Tetris.player_lost
          @score_instance.stop
          @crash.play
          return
        end
      
        @docked_time ||= Gosu::milliseconds
      
        if Gosu::milliseconds > @docked_time + 1000 # or button_down?(Gosu::Button::KbDown) # Force dock?
          @last_automatic_downward_motion = nil
          Tetris.assimilate(:grid => @grid, :cursor => @cursor)
          @docked_sound.play
          @cursor = Cursor.new(:shape => Shape.random, :location => @grid.cursor_origin)
        end
      else
        @docked_time = nil
      end
    
      @rows = @grid.completed_rows.size
    
      unless @rows.zero?
        Tetris.add_to_score(@rows)
        @line_clear_sound.play
        @grid.clear_completed_rows
      end
    
      @last_automatic_downward_motion ||= Gosu::milliseconds
    
      # Gradually move the shape downward.
      if Gosu::milliseconds > @last_automatic_downward_motion + 1000
        puts "Moving it down!"
        @cursor.move_down if Tetris.valid_position?(:cursor => @cursor.pretend.move_down, :grid => @grid)
        @last_automatic_downward_motion = nil
      end
    
      if button_down?(Gosu::Button::KbLeft)
        return if key_locked?
        lock_left
        @cursor.move_left if Tetris.valid_position?(:cursor => @cursor.pretend.move_left, :grid => @grid)
      end
    
      if button_down?(Gosu::Button::KbRight)
        return if key_locked?
        lock_right
        @cursor.move_right if Tetris.valid_position?(:cursor => @cursor.pretend.move_right, :grid => @grid)
      end
    
      if button_down?(Gosu::Button::KbDown)
        @cursor.move_down if Tetris.valid_position?(:cursor => @cursor.pretend.move_down, :grid => @grid)
        @last_automatic_downward_motion = Gosu::milliseconds
      end
    
      if button_down?(Gosu::Button::KbUp)
        return if key_locked?
        lock_up
        @cursor.rotate_clockwise if Tetris.valid_position?(:cursor => @cursor.pretend.rotate_clockwise, :grid => @grid)
        @rotate_sound.play(0.5)
      end
    
      @grid.reset_row_objects
      @score_3.play(0.5) unless @score_instance.playing?
    else
      
    end
  end

  def draw
    @background.draw(0, 0, 0)
    @grid.draw
    @cursor.draw
    @score.draw_rel(Tetris.score.to_s.rjust(6, '0'), 425, 100, 1, 0.5, 0.5, 1, 1, 0xffffffff, :default)
  end
  
  def button_down(id)
    close if id == Gosu::Button::KbEscape
  end
  
  def button_up(id)
    @lock_up = false if id == Gosu::Button::KbUp
    @lock_down = false if id == Gosu::Button::KbDown
    @lock_left = false if id == Gosu::Button::KbLeft
    @lock_right = false if id == Gosu::Button::KbRight
  end
  
  def lock_left
    @lock_left = true
  end
  
  def lock_right
    @lock_right = true
  end
  
  def lock_down
    @lock_down = true
  end

  def lock_up
    @lock_up = true
  end
  
  def key_locked?
    @lock_left or @lock_right or @lock_down or @lock_up or false
  end
  
end

window = GameWindow.new
window.show