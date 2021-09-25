#==============================================================================
# ** UCSkill
#------------------------------------------------------------------------------
#  Represents a skill on a window
#==============================================================================

class UCSkill < UserControl
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icon control for the skill
  attr_reader :ucIcon
  # Label control for the skill name
  attr_reader :cSkillName
  # Label control for the skill cost
  attr_reader :cSkillCost
  # Skill object
  attr_reader :skill
  
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
    @cSkillName.visible = visible
    @cSkillCost.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cSkillName.active = active
    @cSkillCost.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     skill : skill object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, skill, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @skill = skill
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], skill.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cSkillName = CLabel.new(window, rects[1], skill.name)
    @cSkillName.active = active
    @cSkillName.visible = visible
    @cSkillName.cut_overflow = true

    @cSkillCost = CLabel.new(window, rects[2], skill.mp_cost)
    @cSkillCost.align = 2
    @cSkillCost.active = active
    @cSkillCost.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cSkillName.draw()
    @cSkillCost.draw()
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
    
    # cSkillName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cSkillCost
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end
