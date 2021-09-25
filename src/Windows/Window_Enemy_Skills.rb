#===============================================================================
# ** Window_Enemy_Skills
#------------------------------------------------------------------------------
#  This window displays the enemy skills
#===============================================================================

class Window_Enemy_Skills < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCSkill for every skills of the enemy
  attr_reader :ucEnemySkillsList
  # Label for message (no skills or when skills are hidden)
  attr_reader :cMsg
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current skill
  #--------------------------------------------------------------------------
  # GET
  def selected_skill
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @cMsg = CLabel.new(self, Rect.new(0,20,200,WLH), "", 1)
    
    @ucEnemySkillsList = []
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
      @scan_mode = scan_mode
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_SKILLS)
        @cMsg.text = Vocab::bestiary_no_skills_label
      
        skills = enemy.skills
        @data = []
        if skills != nil
          for skill in skills
            if skill != nil
              @data.push(skill)
            end
          end
          @item_max = @data.size
          create_contents()
          @ucEnemySkillsList.clear()
          for i in 0..@item_max-1
            @ucEnemySkillsList.push(create_item(i))
          end
        end
      
      else
        @cMsg.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @scan_mode.include?(BESTIARY_CONFIG::SHOW_SKILLS) && hasSkills
      self.index = 0
      @ucEnemySkillsList.each() { |enemySkill| enemySkill.draw() }
    else
      self.index = -1
      @cMsg.draw()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_skill != nil
      @help_window.window_update(selected_skill.description)
    else
      @help_window.window_update("")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_skill != nil
      @detail_window.window_update(selected_skill)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_skill != nil && selected_skill.is_a?(RPG::Skill)
  end
  
  #--------------------------------------------------------------------------
  # * Return true if there are skills in the list else false
  #--------------------------------------------------------------------------
  def hasSkills
    return @ucEnemySkillsList.size > 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the EnemySkills list 
  #     index : skill index
  #--------------------------------------------------------------------------
  def create_item(index)
    skill = @data[index]
    rect = item_rect(index, true)

    skillItem = UCSkill.new(self, skill, rect)
                   
    return skillItem
  end
  private :create_item
  
end
