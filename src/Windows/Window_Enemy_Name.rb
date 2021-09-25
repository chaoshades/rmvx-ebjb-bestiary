#===============================================================================
# ** Window_Enemy_Name
#------------------------------------------------------------------------------
#  This window displays the enemy name
#===============================================================================

class Window_Enemy_Name < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label control for the enemy id
  attr_reader :cEnemyId
  # Label control for the enemy name
  attr_reader :cEnemyName
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @cEnemyId = CLabel.new(self, Rect.new(0,0,50,WLH), "")
    @cEnemyName = CLabel.new(self, Rect.new(50,0,240,WLH), "")
    @cEnemyName.font = Font.bold_font
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #     enemy : enemy object
  #     scan_mode : scan mode
  #--------------------------------------------------------------------------
  def window_update(enemy, scan_mode)
    if enemy != nil
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_NAME)
        @cEnemyId.text = sprintf(BESTIARY_CONFIG::ENEMY_ID_PATTERN,enemy.id)
        @cEnemyName.text = enemy.name
      else
        @cEnemyId.text = sprintf(BESTIARY_CONFIG::ENEMY_ID_PATTERN,enemy.id)
        @cEnemyName.text = ([BESTIARY_CONFIG::HIDE_CHAR] * enemy.name.length).join
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cEnemyId.draw()
    @cEnemyName.draw()
  end
  
end
