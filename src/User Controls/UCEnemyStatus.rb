#==============================================================================
# ** UCEnemyStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the enemy status in the bestiary
#==============================================================================

class UCEnemyStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icons list for the actives states of the enemy
  attr_reader :ucActStates
  # UCLabelIconValue for the HP stat of the enemy
  attr_reader :ucHpStat
  # UCBar for the HP stat gauge of the enemy
  attr_reader :cHpStatGauge
  # UCLabelIconValue for the MP stat of the enemy
  attr_reader :ucMpStat
  # UCBar for the MP stat gauge of the enemy
  attr_reader :cMpStatGauge
  # UCLabelIconValue for the ATK stat of the enemy
  attr_reader :ucAtkStat
  # UCLabelIconValue for the DEF stat of the enemy
  attr_reader :ucDefStat
  # UCLabelIconValue for the SPI stat of the enemy
  attr_reader :ucSpiStat
  # UCLabelIconValue for the AGI stat of the enemy
  attr_reader :ucAgiStat
  # UCLabelIconValue for the EVA stat of the enemy
  attr_reader :ucEvaStat
  # UCLabelIconValue for the HIT stat of the enemy
  attr_reader :ucHitStat
  # UCLabelIconValue for the CRI stat of the enemy
  attr_reader :ucCriStat
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
    @ucActStates.visible = visible
    @ucHpStat.visible = visible
    @cHpStatGauge.visible = visible
    @ucMpStat.visible = visible
    @cMpStatGauge.visible = visible
    @ucAtkStat.visible = visible
    @ucDefStat.visible = visible
    @ucSpiStat.visible = visible
    @ucAgiStat.visible = visible
    @ucEvaStat.visible = visible
    @ucHitStat.visible = visible
    @ucCriStat.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucActStates.active = active
    @ucHpStat.active = active
    @cHpStatGauge.active = active
    @ucMpStat.active = active
    @cMpStatGauge.active = active
    @ucAtkStat.active = active
    @ucDefStat.active = active
    @ucSpiStat.active = active
    @ucAgiStat.active = active
    @ucEvaStat.active = active
    @ucHitStat.active = active
    @ucCriStat.active = active
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
  #     right_pad : right padding to add to the values
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, enemy, rect, spacing=24, right_pad=2,
                 active=true, visible=true)
    super(active, visible)
    @enemy = enemy
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing, right_pad)
    
    @ucActStates = UCLabelIconsSwitchableList.new(window, rects[0][0], rects[0][1], 
                           Vocab::active_status_label, [0], BESTIARY_CONFIG::ACT_STATES_MAX_ICONS, 
                           BESTIARY_CONFIG::ACT_STATES_ICONS_TIMEOUT)  
    @ucActStates.active = active
    @ucActStates.visible = visible
    
    @ucHpStat = UCLabelIconValue.new(window, rects[1][1], rects[1][0], rects[1][2], 
                                     Vocab::hp_label, BESTIARY_CONFIG::ICON_HP, 0)
    @ucHpStat.cValue.align = 2    
    @ucHpStat.active = active
    @ucHpStat.visible = visible
    @cHpStatGauge = UCBar.new(window, rects[2],
                              Color.hp_gauge_color1, Color.hp_gauge_color2, 
                              Color.gauge_back_color, 0, 0, 1, Color.gauge_border_color)
    @cHpStatGauge.active = active
    @cHpStatGauge.visible = visible
    
    @ucMpStat = UCLabelIconValue.new(window, rects[3][1], rects[3][0], rects[3][2],
                                     Vocab::mp_label, BESTIARY_CONFIG::ICON_MP, 0)
    @ucMpStat.cValue.align = 2
    @ucMpStat.active = active
    @ucMpStat.visible = visible
    @cMpStatGauge = UCBar.new(window, rects[4],
                              Color.mp_gauge_color1, Color.mp_gauge_color2, 
                              Color.gauge_back_color, 0, 0, 1, Color.gauge_border_color)                    
    @cMpStatGauge.active = active
    @cMpStatGauge.visible = visible
    
    @ucAtkStat = UCLabelIconValue.new(window, rects[5][1], rects[5][0], rects[5][2],
                                      Vocab::atk_label, BESTIARY_CONFIG::ICON_ATK, 0)
    @ucAtkStat.cValue.align = 2
    @ucAtkStat.active = active
    @ucAtkStat.visible = visible
    
    @ucDefStat = UCLabelIconValue.new(window, rects[6][1], rects[6][0], rects[6][2],
                                      Vocab::def_label, BESTIARY_CONFIG::ICON_DEF, 0)
    @ucDefStat.cValue.align = 2
    @ucDefStat.active = active
    @ucDefStat.visible = visible
    
    @ucSpiStat = UCLabelIconValue.new(window, rects[7][1], rects[7][0], rects[7][2],
                                      Vocab::spi_label, BESTIARY_CONFIG::ICON_SPI, 0)
    @ucSpiStat.cValue.align = 2
    @ucSpiStat.active = active
    @ucSpiStat.visible = visible
    
    @ucAgiStat = UCLabelIconValue.new(window, rects[8][1], rects[8][0], rects[8][2],
                                      Vocab::agi_label, BESTIARY_CONFIG::ICON_AGI, 0)
    @ucAgiStat.cValue.align = 2
    @ucAgiStat.active = active
    @ucAgiStat.visible = visible
    
    @ucEvaStat = UCLabelIconValue.new(window, rects[9][1], rects[9][0], rects[9][2],
                                      Vocab::eva_label, BESTIARY_CONFIG::ICON_EVA, 0)
    @ucEvaStat.cValue.align = 2
    @ucEvaStat.active = active
    @ucEvaStat.visible = visible
    
    @ucHitStat = UCLabelIconValue.new(window, rects[10][1], rects[10][0], rects[10][2],
                                      Vocab::hit_label, BESTIARY_CONFIG::ICON_HIT, 0)
    @ucHitStat.cValue.align = 2
    @ucHitStat.active = active
    @ucHitStat.visible = visible
    
    @ucCriStat = UCLabelIconValue.new(window, rects[11][1], rects[11][0], rects[11][2],
                                      Vocab::cri_label, BESTIARY_CONFIG::ICON_CRI, 0)
    @ucCriStat.cValue.align = 2
    @ucCriStat.active = active
    @ucCriStat.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucActStates.draw()
    @cHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
    @ucAtkStat.draw()
    @ucDefStat.draw()
    @ucSpiStat.draw()
    @ucAgiStat.draw()
    @ucEvaStat.draw()
    @ucHitStat.draw()
    @ucCriStat.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #     right_pad : right padding to add to the values
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing, right_pad)
    rects = []
    
    # Rects Initialization
    rects[0] = [Rect.new(rect.x,rect.y,90,24),
                Rect.new(rect.x,rect.y,100,24)]
    rects[1] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[2] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[5] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[6] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[7] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[8] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[9] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[10] = [Rect.new(rect.x,rect.y,24,24),
                 Rect.new(rect.x,rect.y,50,24),
                 Rect.new(rect.x,rect.y,rect.width,24)]
    rects[11] = [Rect.new(rect.x,rect.y,24,24),
                 Rect.new(rect.x,rect.y,50,24),
                 Rect.new(rect.x,rect.y,rect.width,24)]
    
    gauge_value_width = rect.width - 24 - 25 - right_pad
    stats_value_width = rect.width - 24 - 50 - right_pad
    gauge_y = 16
        
    # Rects Adjustments
    
    # ucActStates
    rects[0][1].x += rects[0][0].width
    
    # ucHpStat
    rects[1][0].y += spacing
    rects[1][1].x += rects[1][0].width
    rects[1][1].y = rects[1][0].y
    rects[1][2].x = rects[1][1].x + rects[1][1].width
    rects[1][2].y = rects[1][0].y
    rects[1][2].width = gauge_value_width
    
    # cHpStatGauge
    rects[2].y += rects[1][0].y+gauge_y
    rects[2].height = rects[1][0].height-gauge_y
    
    # ucMpStat
    rects[3][0].y += spacing*2
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].x = rects[3][1].x + rects[3][1].width
    rects[3][2].y = rects[3][0].y
    rects[3][2].width = gauge_value_width
    
    # cMpStatGauge
    rects[4].y += rects[3][0].y+gauge_y
    rects[4].height = rects[3][0].height-gauge_y
    
    # ucAtkStat
    rects[5][0].y += spacing*3
    rects[5][1].x += rects[5][0].width
    rects[5][1].y = rects[5][0].y
    rects[5][2].x = rects[5][1].x + rects[5][1].width
    rects[5][2].y = rects[5][0].y
    rects[5][2].width = stats_value_width
    
    # ucDefStat
    rects[6][0].y += spacing*4
    rects[6][1].x += rects[6][0].width
    rects[6][1].y = rects[6][0].y
    rects[6][2].x = rects[6][1].x + rects[6][1].width
    rects[6][2].y = rects[6][0].y
    rects[6][2].width = stats_value_width
    
    # ucSpiStat
    rects[7][0].y += spacing*5
    rects[7][1].x += rects[7][0].width
    rects[7][1].y = rects[7][0].y
    rects[7][2].x = rects[7][1].x + rects[7][1].width
    rects[7][2].y = rects[7][0].y
    rects[7][2].width = stats_value_width
    
    # ucAgiStat
    rects[8][0].y += spacing*6
    rects[8][1].x += rects[8][0].width
    rects[8][1].y = rects[8][0].y
    rects[8][2].x = rects[8][1].x + rects[8][1].width
    rects[8][2].y = rects[8][0].y
    rects[8][2].width = stats_value_width
    
    # ucEvaStat
    rects[9][0].y += spacing*7
    rects[9][1].x += rects[9][0].width
    rects[9][1].y = rects[9][0].y
    rects[9][2].x = rects[9][1].x + rects[9][1].width
    rects[9][2].y = rects[9][0].y
    rects[9][2].width = stats_value_width
    
    # ucHitStat
    rects[10][0].y += spacing*8
    rects[10][1].x += rects[10][0].width
    rects[10][1].y = rects[10][0].y
    rects[10][2].x = rects[10][1].x + rects[10][1].width
    rects[10][2].y = rects[10][0].y
    rects[10][2].width = stats_value_width
    
    # ucCriStat
    rects[11][0].y += spacing*9
    rects[11][1].x += rects[11][0].width
    rects[11][1].y = rects[11][0].y
    rects[11][2].x = rects[11][1].x + rects[11][1].width
    rects[11][2].y = rects[11][0].y
    rects[11][2].width = stats_value_width
    
    return rects
  end
  private :determine_rects
  
end
