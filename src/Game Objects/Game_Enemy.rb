#===============================================================================
# ** Game Enemy
#------------------------------------------------------------------------------
#  Function aliases for bestiary
#===============================================================================

class Game_Enemy < Game_Battler
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize(index, enemy_id)
    initialize_ebjb(index, enemy_id)
    if $game_party.monsters_encounters[enemy_id] == nil
      $game_party.monsters_encounters[enemy_id] = 0
    end
    $game_party.monsters_encounters[enemy_id] += 1 unless $scene.is_a?(Scene_Bestiary)
  end
  
  #--------------------------------------------------------------------------
  # * Alias transform
  #--------------------------------------------------------------------------
  alias transform_ebjb transform unless $@
  def transform(enemy_id)
    transform_ebjb(enemy_id)
    if $game_party.monsters_encounters[enemy_id] == nil
      $game_party.monsters_encounters[enemy_id] = 0
    end
    $game_party.monsters_encounter[enemy_id] += 1
  end
  
  #--------------------------------------------------------------------------
  # * Alias collapse
  #--------------------------------------------------------------------------
  alias perform_collapse_ebjb perform_collapse unless $@
  def perform_collapse
    perform_collapse_ebjb
    if $game_temp.in_battle and dead?
      if $game_party.monsters_defeated[enemy_id] == nil
        $game_party.monsters_defeated[enemy_id] = 0
      end
      $game_party.monsters_defeated[enemy_id] += 1
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Alias escape
  #--------------------------------------------------------------------------
  alias escape_ebjb escape unless $@
  def escape
    if $game_party.monsters_escaped[enemy_id] == nil
      $game_party.monsters_escaped[enemy_id] = 0
    end
    $game_party.monsters_escaped[enemy_id] += 1
    escape_ebjb
  end
  
  #--------------------------------------------------------------------------
  # * Number that have been encountered
  #--------------------------------------------------------------------------
  def encounters
    if $game_party.monsters_encounters[enemy_id] == nil
      $game_party.monsters_encounters[enemy_id] = 0
    end
    return $game_party.monsters_encounters[enemy_id]
  end
  
  #--------------------------------------------------------------------------
  # * Number that have been defeated
  #--------------------------------------------------------------------------
  def defeated
    if $game_party.monsters_defeated[enemy_id] == nil
      $game_party.monsters_defeated[enemy_id] = 0 
    end
    return $game_party.monsters_defeated[enemy_id]
  end
  
  #--------------------------------------------------------------------------
  # * Number that have escaped
  #--------------------------------------------------------------------------
  def escaped
    if $game_party.monsters_escaped[enemy_id] == nil
      $game_party.monsters_escaped[enemy_id] = 0 
    end
    return $game_party.monsters_escaped[enemy_id]
  end
  
end
