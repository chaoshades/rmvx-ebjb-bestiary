#===============================================================================
# ** Scene Battle
#------------------------------------------------------------------------------
#  Add the feature to call the Scan screen in battle
#===============================================================================

class Scene_Battle
  include EBJB
    
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_info_viewport
  #--------------------------------------------------------------------------
  alias create_info_viewport_ebjb create_info_viewport unless $@
  def create_info_viewport
    create_info_viewport_ebjb
    @scan_info_window = Window_Info_Help.new(BESTIARY_CONFIG::HELP_WINDOW_X, 
                        BESTIARY_CONFIG::HELP_WINDOW_Y, 
                        BESTIARY_CONFIG::HELP_WINDOW_W, 
                        BESTIARY_CONFIG::HELP_WINDOW_H, 
                        Vocab::bestiary_help_text)

    @scan_info_window.cText.align = 1
    # Refresh for the text alignment
    @scan_info_window.refresh()
    @scan_info_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_ebjb start unless $@
  def start
    start_ebjb
    @subSceneScan = Sub_Scene_Scan.new
    @subSceneScan.start()
  end
  
  #--------------------------------------------------------------------------
  # * Alias terminate
  #--------------------------------------------------------------------------
  alias terminate_ebjb terminate unless $@
  def terminate
    @scan_info_window.dispose if @scan_info_window != nil
    @subSceneScan.terminate if @subSceneScan != nil
    terminate_ebjb 
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_target_enemy_selection
  #--------------------------------------------------------------------------
  alias update_target_enemy_selection_ebjb update_target_enemy_selection unless $@
  def update_target_enemy_selection
    
    #------------------------------------------
    # If the Target Window is Active
    #------------------------------------------
    if @target_enemy_window.active
      
      # If already scanned or at least 1 defeated to be able to show scan information
      if $game_party.monsters_scanned.include?(@target_enemy_window.enemy.enemy_id) ||
         @target_enemy_window.enemy.defeated > 0
         
        if BESTIARY_CONFIG::HELP_WINDOW_ON
          # Updates the Z-index to be sure it is over the target window
          @scan_info_window.z = @target_enemy_window.z + 1
          @scan_info_window.visible = true
        end
        if Input.trigger?(BESTIARY_CONFIG::ENEMY_SCAN_BUTTON)
          Sound.play_decision
          @subSceneScan.windows_update(@target_enemy_window.enemy)
          @subSceneScan.update_windows_zindex(@target_enemy_window.z)
          @subSceneScan.show_windows()
          
          @scan_info_window.visible = false
          @target_enemy_window.active = false
        elsif Input.trigger?(Input::B)
          @scan_info_window.visible = false
        elsif Input.trigger?(Input::C)
          @scan_info_window.visible = false
        end
      end
      
      update_target_enemy_selection_ebjb
    
    #------------------------------------------
    # If the Scan Window is Active
    #------------------------------------------
    else
      @subSceneScan.update
    
      if @subSceneScan.isClosable 
        quit_command()
      end
    end
    
  end

  #--------------------------------------------------------------------------
  # * Show Action Results
  #     target : Target
  #     obj    : Skill or item
  #--------------------------------------------------------------------------
  def display_action_effects(target, obj = nil)
    unless target.skipped
      line_number = @message_window.line_number
      wait(5)
      display_critical(target, obj)
      display_damage(target, obj)
      display_state_changes(target, obj)
      display_scan(target, obj)
      if line_number == @message_window.line_number
        display_failure(target, obj) unless target.states_active?
      end
      if line_number != @message_window.line_number
        wait(30)
      end
      @message_window.back_to(line_number)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Show Scan
  #     target : Target
  #     obj    : Skill or item
  #--------------------------------------------------------------------------
  def display_scan(target, obj = nil)
    return if obj == nil
    
    if (BESTIARY_CONFIG::SCAN_SKILLS_ID.include?(obj.id) ||
        BESTIARY_CONFIG::SCAN_ITEMS_ID.include?(obj.id))
        
      text = sprintf(Vocab::bestiary_scan_text_1, target.name)
      @message_window.add_instant_text(text)
      wait(60*BESTIARY_CONFIG::SCAN_MSG_TIMEOUT)
      @message_window.add_instant_text(Vocab::bestiary_scan_text_2)
      wait(30*BESTIARY_CONFIG::SCAN_MSG_2_TIMEOUT)
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    @subSceneScan.hide_windows()
    @target_enemy_window.active = true
  end
  private :quit_command
  
end
