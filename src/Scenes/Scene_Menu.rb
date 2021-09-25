#===============================================================================
# ** Scene Menu
#------------------------------------------------------------------------------
#  Add the Bestiary item in the menu
#===============================================================================

class Scene_Menu < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_command_window
  #--------------------------------------------------------------------------
  alias create_command_window_ebjb create_command_window unless $@
  def create_command_window
    # Keeps the selected index and cancel the @menu_index
    # (because in the original create_command_window, 
    # this line is called after the creation of the window :
    #   @command_window.index = @menu_index
    # and with a command that doesn't exist, the index will be invalid)
    temp_index = @menu_index
    @menu_index = -1
    create_command_window_ebjb
    @command_bestiary = @command_window.add_command(Vocab::bestiary_menu_title)
    # Finally, apply the index when all the necessary commands are added
    @command_window.index = temp_index
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_command_selection
  #--------------------------------------------------------------------------
  alias update_command_selection_ebjb update_command_selection unless $@
  def update_command_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when @command_bestiary
        Sound.play_decision
        $scene = Scene_Bestiary.new(@command_window.index)
      end
    end
    update_command_selection_ebjb
  end
  
end
