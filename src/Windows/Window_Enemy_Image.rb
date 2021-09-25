#===============================================================================
# ** Window_Enemy_Image
#------------------------------------------------------------------------------
#  This window displays the enemy image and description
#===============================================================================

class Window_Enemy_Image < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Control to show the enemy graphic
  attr_reader :ucEnemyGraphic
  # Label control to show when the enemy graphic is hidden
  attr_reader :cHiddenImage
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @ucEnemyGraphic = UCEnemyGraphic.new(self, Rect.new(0,0,self.contents.width,self.contents.height), nil)
    @ucEnemyGraphic.cEnemyGraphic.align = 1
    @ucEnemyGraphic.cEnemyGraphic.valign = 2
    @ucEnemyGraphic.cEnemyGraphic.resize_mode = 2
    @cHiddenImage = CLabel.new(self, Rect.new(0,0,170,200), BESTIARY_CONFIG::HIDE_CHAR,
                               1, Font.hidden_image_font)
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @ucEnemyGraphic.enemy != nil
      if @scan_mode.include?(BESTIARY_CONFIG::SHOW_NOTE)
        @help_window.window_update(@ucEnemyGraphic.enemy.note)
      else
        @help_window.window_update(BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN)
      end
    else
      @help_window.window_update("")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     enemy : enemy object
  #     scan_mode : scan mode
  #--------------------------------------------------------------------------
  def window_update(enemy, scan_mode)
    if enemy != nil
      @scan_mode = scan_mode
      @ucEnemyGraphic.enemy = enemy
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    if @scan_mode.include?(BESTIARY_CONFIG::SHOW_IMAGE)
      @ucEnemyGraphic.draw()
    else
      @cHiddenImage.draw()
    end
  end
  
end
