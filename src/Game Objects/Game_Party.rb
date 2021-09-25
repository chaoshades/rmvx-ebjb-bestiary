#===============================================================================
# ** Game Party
#------------------------------------------------------------------------------
#  Variables and properties for bestiary
#===============================================================================

class Game_Party < Game_Unit
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array that contains the number of encounters by enemy id
  attr_writer :monsters_encounters
  # Array that contains the number of defeated monsters
  attr_writer :monsters_defeated
  # Array that contains the number of escaped monsters
  attr_writer :monsters_escaped
  # Array that contains the number of scanned monsters
  attr_writer :monsters_scanned
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Array that contains the number of encounters
  #--------------------------------------------------------------------------
  # GET
  def monsters_encounters
    @monsters_encounters = {} if @monsters_encounters == nil
    return @monsters_encounters
  end
  
  #--------------------------------------------------------------------------
  # * Array that contains the number of defeated monsters
  #--------------------------------------------------------------------------
  # GET
  def monsters_defeated
    @monsters_defeated = {} if @monsters_defeated == nil
    return @monsters_defeated
  end
  
  #--------------------------------------------------------------------------
  # * Array that contains the number of escaped monsters
  #--------------------------------------------------------------------------
  # GET
  def monsters_escaped
    @monsters_escaped = {} if @monsters_escaped == nil
    return @monsters_escaped
  end
  
  #--------------------------------------------------------------------------
  # * Array that contains the number of scanned monsters
  #--------------------------------------------------------------------------
  # GET
  def monsters_scanned
    @monsters_scanned = [] if @monsters_scanned == nil
    return @monsters_scanned
  end
  
end
