#==============================================================================
# ** Window_Bestiary_Info
#------------------------------------------------------------------------------
#  This window displays different statistics on the bestiary
#==============================================================================

class Window_Bestiary_Info < Window_Base
  include EBJB
    
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelIcon for the bestiary completion
  attr_reader :ucBestiaryCompletion
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    
    @ucBestiaryCompletion = UCLabelIcon.new(self, Rect.new(56,0,200,WLH), Rect.new(24,0,WLH,WLH), 
                            "", 
                            BESTIARY_CONFIG::ICON_COMPLETION)
    
    window_update()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucBestiaryCompletion.draw()
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def window_update()
    @ucBestiaryCompletion.cLabel.text = sprintf(BESTIARY_CONFIG::RATE_COMPLETION, bestiary_completion)
    
    refresh()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Bestiary completion rate
  #--------------------------------------------------------------------------
  def bestiary_completion
    completion = 0.0
    
    for enemy in $data_enemies
      next if enemy == nil
      next if $game_party.monsters_defeated[enemy.id] == nil
      next if $game_party.monsters_defeated[enemy.id] == 0 &&
              !$game_party.monsters_scanned.include?(enemy.id)
      
      # If already scanned
      if $game_party.monsters_scanned.include?(enemy.id)
        completion += 1
      else
        rate = 0
        # Gets the scan mode depending on the number of enemy defeated
        for s in BESTIARY_CONFIG::SCAN_MODES
          if $game_party.monsters_defeated[enemy.id] >= s.rangeEnd
            rate += 1
          end
        end
        completion += rate / BESTIARY_CONFIG::SCAN_MODES.size.to_f
      end

    end
    
    completion *= 100.0
    completion /= $data_enemies.size
    return completion
  end
  private :bestiary_completion
  
end
