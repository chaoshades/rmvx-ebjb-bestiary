#==============================================================================
# ** UCDropItem
#------------------------------------------------------------------------------
#  Represents a drop item on a window
#==============================================================================

class UCDropItem < UserControl
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icon control for the drop item
  attr_reader :ucIcon
  # Label control for the drop name
  attr_reader :cDropName
  # Label control for the drop chances
  attr_reader :cDropChances
  # Item object
  attr_reader :dropItem
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIcon.visible = visible
    @cDropName.visible = visible
    @cDropChances.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cDropName.active = active
    @cDropChances.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     dropItem : item object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, dropItem, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @dropItem = dropItem
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    case dropItem.kind
      when 1
        item = $data_items[dropItem.item_id]
      when 2
        item = $data_weapons[dropItem.weapon_id]
      when 3
        item = $data_armors[dropItem.armor_id]
    end

    @ucIcon = UCIcon.new(window, rects[0], item.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cDropName = CLabel.new(window, rects[1], item.name)
    @cDropName.active = active
    @cDropName.visible = visible
    @cDropName.cut_overflow = true

    @cDropChances = CLabel.new(window, rects[2], "1/" + dropItem.denominator.to_s)
    @cDropChances.align = 2
    @cDropChances.active = active
    @cDropChances.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cDropName.draw()
    @cDropChances.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,60,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cDropName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cDropChances
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects

end
