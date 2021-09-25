#===============================================================================
# ** RPG::Enemy Addon
#------------------------------------------------------------------------------
#  Addon function for skills & drops lists
#===============================================================================

class RPG::Enemy
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get skills list
  #--------------------------------------------------------------------------
  def skills
    skills = []
    for action in actions
      if action.kind == 1
        obj = $data_skills[action.skill_id]
        unless skills.include?(obj)
          skills.push(obj) 
        end
      end
    end
    return skills
  end
  
  #--------------------------------------------------------------------------
  # * Get drops list
  #--------------------------------------------------------------------------
  def drops
    drops = []
    if drop_item1.kind != 0
      drops.push(drop_item1)
    end
    if drop_item2.kind != 0
      drops.push(drop_item2)
    end

    return drops
  end
  
end 
