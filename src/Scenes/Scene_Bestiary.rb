#===============================================================================
# ** Scene_Bestiary
#------------------------------------------------------------------------------
#  This class performs bestiary screen processing.
#===============================================================================

class Scene_Bestiary < Scene_Base

  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(menu_index = nil)
    @menu_index = menu_index
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background()
    
    @gameEnemy = Game_Enemy.new(0, 1)
    @subSceneScan = Sub_Scene_Scan.new
    @subSceneScan.start()
    @subSceneScan.windows_update(@gameEnemy)
    @subSceneScan.show_windows()
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background()
    
    @subSceneScan.terminate if @subSceneScan != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    @subSceneScan.update
    
    if @subSceneScan.isClosable 
      quit_command()
    elsif (Input.repeat?(Input::Y) || Input.repeat?(Input::Z))
      update_enemy_windows(Input.press?(Input::Z))
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Return scene
  #--------------------------------------------------------------------------
  def return_scene
    if @menu_index != nil
      $scene = Scene_Menu.new(@menu_index)
    else
      $scene = Scene_Map.new
    end
  end
  private :return_scene
   
  #--------------------------------------------------------------------------
  # * Update Enemy object in all windows
  #     isRight : true to go to the right, else false to go to the left in the bestiary
  #-------------------------------------------------------------------------- 
  def update_enemy_windows(isRight)
    enemyChange = false
    if isRight
      if @gameEnemy.enemy_id < $data_enemies.size-1
        @gameEnemy = Game_Enemy.new(0, @gameEnemy.enemy_id+1)
        enemyChange = true
      end
    else
      if @gameEnemy.enemy_id > 1
        @gameEnemy = Game_Enemy.new(0, @gameEnemy.enemy_id-1)
        enemyChange = true
      end
    end

    if enemyChange
      @subSceneScan.windows_update(@gameEnemy)
    end 
  end
  private :update_enemy_windows
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    return_scene
  end
  private :quit_command
  
end
