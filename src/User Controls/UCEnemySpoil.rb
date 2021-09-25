#==============================================================================
# ** UCEnemySpoil
#------------------------------------------------------------------------------
#  Represents a group of controls to show the enemy spoil data in the bestiary
#==============================================================================

class UCEnemySpoil < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelIconValue for the number of enemy encountered
  attr_reader :ucEncounters
  # UCLabelIconValue for the number of enemy defeated
  attr_reader :ucDefeated
  # UCLabelIconValue for the number of enemy escaped
  attr_reader :ucEscaped
  # UCLabelIconValue for the EXP given by the enemy
  attr_reader :ucExp
  # UCLabelIconValue for the GOLD given by the enemy
  attr_reader :ucGold
  # Enemy object
  attr_reader :enemy
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucEncounters.visible = visible
    @ucDefeated.visible = visible
    @ucEscaped.visible = visible
    @ucExp.visible = visible
    @ucGold.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucEncounters.active = active
    @ucDefeated.active = active
    @ucEscaped.active = active
    @ucExp.active = active
    @ucGold.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     enemy : enemy object
  #     rect : rectangle to position the controls for the enemy
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, enemy, rect, spacing=24,
                 active=true, visible=true)
    super(active, visible)
    @enemy = enemy
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucEncounters = UCLabelIconValue.new(window, rects[0][1], 
                                         rects[0][0], rects[0][2],
                                         Vocab::encounters_label, BESTIARY_CONFIG::ICON_ENCOUNTERS, 0)
    @ucEncounters.cValue.align = 2
    @ucEncounters.active = active
    @ucEncounters.visible = visible
    
    @ucDefeated = UCLabelIconValue.new(window, rects[1][1], 
                                      rects[1][0], rects[1][2],
                                       Vocab::defeated_label, BESTIARY_CONFIG::ICON_DEFEATED, 0)
    @ucDefeated.cValue.align = 2
    @ucDefeated.active = active
    @ucDefeated.visible = visible
    
    @ucEscaped = UCLabelIconValue.new(window, rects[2][1], 
                                      rects[2][0], rects[2][2],
                                      Vocab::escaped_label, BESTIARY_CONFIG::ICON_ESCAPED, 0)
    @ucEscaped.cValue.align = 2
    @ucEscaped.active = active
    @ucEscaped.visible = visible
    
    @ucExp = UCLabelIconValue.new(window, rects[3][1], 
                                  rects[3][0], rects[3][2],
                                  Vocab::exp_label,BESTIARY_CONFIG::ICON_EXP, 0)
    @ucExp.cValue.align = 2
    @ucExp.active = active
    @ucExp.visible = visible
    
    @ucGold = UCLabelIconValue.new(window, rects[4][1], 
                                   rects[4][0], rects[4][2],
                                   Vocab::gold_label, BESTIARY_CONFIG::ICON_GOLD, 0)
    @ucGold.cValue.align = 2
    @ucGold.active = active
    @ucGold.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucEncounters.draw()
    @ucDefeated.draw()
    @ucEscaped.draw()
    @ucExp.draw()
    @ucGold.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,80,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[1] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,80,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[2] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,80,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    
    # Rects Adjustments
    
    # ucEncounters
    rects[0][1].x += rects[0][0].width
    rects[0][2].x = rects[0][1].x + rects[0][1].width
    rects[0][2].width = rect.width - rects[0][0].width - rects[0][1].width
    
    # ucDefeated
    rects[1][0].y += spacing
    rects[1][1].x += rects[1][0].width
    rects[1][1].y = rects[1][0].y
    rects[1][2].x = rects[1][1].x + rects[1][1].width
    rects[1][2].y = rects[1][0].y
    rects[1][2].width = rect.width - rects[1][0].width - rects[1][1].width
    
    # ucEscaped
    rects[2][0].y += spacing*2
    rects[2][1].x += rects[2][0].width
    rects[2][1].y = rects[2][0].y
    rects[2][2].x = rects[2][1].x + rects[2][1].width
    rects[2][2].y = rects[2][0].y
    rects[2][2].width = rect.width - rects[2][0].width - rects[2][1].width
    
    # ucExp
    rects[3][0].y += spacing*3
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].x = rects[3][1].x + rects[3][1].width
    rects[3][2].y = rects[3][0].y
    rects[3][2].width = rect.width - rects[3][0].width - rects[3][1].width
        
    # ucGold
    rects[4][0].y += spacing*4
    rects[4][1].x += rects[4][0].width
    rects[4][1].y = rects[4][0].y
    rects[4][2].x = rects[4][1].x + rects[4][1].width
    rects[4][2].y = rects[4][0].y
    rects[4][2].width = rect.width - rects[4][0].width - rects[4][1].width
    
    return rects
  end
  private :determine_rects
  
end
