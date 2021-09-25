#===============================================================================
# ** Game Battler
#------------------------------------------------------------------------------
#  Function aliases for bestiary
#===============================================================================

class Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias skill_effect
  #--------------------------------------------------------------------------
  alias skill_effect_ebjb skill_effect unless $@
  def skill_effect(user, skill)
    skill_effect_ebjb(user, skill)
    if user.actor? and !self.actor?
      if BESTIARY_CONFIG::SCAN_SKILLS_ID.include?(skill.id)
        $game_party.monsters_scanned.push(enemy.id) unless $game_party.monsters_scanned.include?(enemy.id)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias item_effect
  #--------------------------------------------------------------------------
  alias item_effect_ebjb item_effect unless $@
  def item_effect(user, item)
    item_effect_ebjb(user, item)
    if user.actor? and !self.actor?
      if BESTIARY_CONFIG::SCAN_ITEMS_ID.include?(item.id)
        $game_party.monsters_scanned.push(enemy.id) unless $game_party.monsters_scanned.include?(enemy.id)
      end
    end
  end
  
end
