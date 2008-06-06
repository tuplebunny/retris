class PlayingState < StateMachine

  def initialize(base)
    super
    
    @grid = base.game_objects[:grid]
    @cursor = base.game_objects[:cursor]
    @background = base.game_objects[:background]
    @score = base.game_objects[:score]
    @tetris = base.game_objects[:tetris]
    @song = Gosu::Sample.new(base, 'media/score-2.mp3')
    @song_instance = @song.play
    @current_difficult_level = Gosu::Font.new(base, Gosu::default_font_name, 40)
  end
  
  def update
    unless @tetris.player_lost?
      if @tetris.docked?(:grid => @grid, :cursor => @cursor)
        if @cursor.top?
          @tetris.player_lost
          @song_instance.stop
          return
        end
      
        @docked_time ||= Gosu::milliseconds
      
        if (Gosu::milliseconds > @docked_time + 1000) or (base.button_down?(Gosu::Button::KbDown) and Gosu::milliseconds > @docked_time + 500) # Force dock
          @last_automatic_downward_motion = nil
          @tetris.assimilate(:grid => @grid, :cursor => @cursor)
          @cursor = Cursor.new(:shape => base.game_objects[:next_shape], :location => @grid.cursor_origin)
          base.game_objects[:next_shape] = Shape.random
        end
      else
        @docked_time = nil
      end
    
      @rows = @grid.completed_rows.size
    
      unless @rows.zero?
        @tetris.add_to_score(@rows)
        @grid.clear_completed_rows
      end
    
      @last_automatic_downward_motion ||= Gosu::milliseconds
    
      # Gradually move the shape downward.
      if Gosu::milliseconds > @last_automatic_downward_motion + @tetris.drop_rate
        @cursor.move_down if @tetris.valid_position?(:cursor => @cursor.pretend.move_down, :grid => @grid)
        @last_automatic_downward_motion = nil
      end
    
      if base.button_down?(Gosu::Button::KbLeft)
        return if key_locked?
        lock_left
        @cursor.move_left if @tetris.valid_position?(:cursor => @cursor.pretend.move_left, :grid => @grid)
      end
    
      if base.button_down?(Gosu::Button::KbRight)
        return if key_locked?
        lock_right
        @cursor.move_right if @tetris.valid_position?(:cursor => @cursor.pretend.move_right, :grid => @grid)
      end
    
      if base.button_down?(Gosu::Button::KbDown)
        @cursor.move_down if @tetris.valid_position?(:cursor => @cursor.pretend.move_down, :grid => @grid)
        @last_automatic_downward_motion = Gosu::milliseconds
      end
    
      if base.button_down?(Gosu::Button::KbUp)
        return if key_locked?
        lock_up
        @cursor.rotate_clockwise if @tetris.valid_position?(:cursor => @cursor.pretend.rotate_clockwise, :grid => @grid)
      end
    
      unless @tetris.player_lost? or @song_instance.playing?
        @delay_before_replay ||= Gosu::milliseconds
        
        if Gosu::milliseconds > @delay_before_replay + 1000
          @delay_before_replay = nil
          @song_instance = @song.play
        end
      end
      
      @grid.reset_row_objects
    else
      
    end
  end
  
  def draw
    @background.draw(0, 0, 0)
    @grid.draw
    @cursor.draw
    @score.draw_rel(@tetris.score.to_s.rjust(6, '0'), 440, 250, 1, 0.5, 0.5, 1, 1, 0xffffffff, :default)
    @current_difficult_level.draw_rel(@tetris.difficulty_level.to_s, 440, 390, 1, 0.5, 0.5, 1, 1, 0xffffffff, :default)
    # base.game_objects[:next_shape].draw(425, 100, 10)
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