#===============================================================================
# ** Sub_Scene_Scan
#------------------------------------------------------------------------------
#  This class performs the scan screen processing.
#===============================================================================

class Sub_Scene_Scan < Sub_Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Z-index adjustment for the windows
  attr_reader :zindex_adjustment
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @isClosable = false
    @zindex_adjustment = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    if BESTIARY_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(BESTIARY_CONFIG::IMAGE_BG)
      @bg.opacity = BESTIARY_CONFIG::IMAGE_BG_OPACITY
      @bg.visible = false
    end
    
    @enemy_name_window = Window_Enemy_Name.new(0, 0, 440, 56)
    @enemy_name_window.visible = false
    @bestiary_info_window = Window_Bestiary_Info.new(440, 0, 200, 56)
    @bestiary_info_window.visible = false
    
    @enemy_status_window = Window_Enemy_Status.new(0, 56, 640, 424)
    @enemy_status_window.visible = false

    @enemy_image_window = Window_Enemy_Image.new(0, 56, 200, 260)
    @enemy_image_window.visible = false
    @enemy_image_window.active = false
    
    @enemy_skills_window = Window_Enemy_Skills.new(410, 56, 230, 104)
    @enemy_skills_window.visible = false
    @enemy_skills_window.active = false
    @enemy_skills_window_headers = Window_Selectable_Headers.new(@enemy_skills_window, 18)
    @enemy_skills_window_headers.visible = false
    @enemy_skills_window_headers.addHeader(Vocab::bestiary_skills_header, 
                                           0,100, 0,  Font.selectable_headers_font)
    @enemy_skills_window_headers.addHeader(Vocab::bestiary_skills_cost_header, 
                                           134,60, 2, Font.selectable_headers_font)
    @enemy_skills_window_headers.refresh()

    @enemy_drops_window = Window_Enemy_Drops.new(410, 186, 230, 104)
    @enemy_drops_window.visible = false
    @enemy_drops_window.active = false
    @enemy_drops_window_headers = Window_Selectable_Headers.new(@enemy_drops_window, 18)
    @enemy_drops_window_headers.visible = false
    @enemy_drops_window_headers.addHeader(Vocab::bestiary_drops_header, 
                                          0,100, 0, Font.selectable_headers_font)
    @enemy_drops_window_headers.addHeader(Vocab::bestiary_drops_chances_header, 
                                          134,60, 2, Font.selectable_headers_font)
    @enemy_drops_window_headers.refresh()

    @equip_details_window = Window_EquipDetails.new(0,384,640,96, nil)
    @equip_details_window.visible = false
    @item_details_window = Window_ItemDetails.new(0,384,640,96, nil)
    @item_details_window.visible = false
        
    @skill_details_window = Window_SkillDetails.new(0,384,640,96, nil)
    @skill_details_window.visible = false
    @enemy_skills_window.detail_window = @skill_details_window
    
    positions = []
    positions.push(CursorPosition.new(Rect.new(@enemy_image_window.x,
                            @enemy_image_window.y-56, 
                            @enemy_image_window.width-32, 
                            @enemy_image_window.height-32)))
    positions.push(CursorPosition.new(Rect.new(@enemy_skills_window.x, 
                            @enemy_skills_window.y-56, 
                            @enemy_skills_window.width-32, 
                            @enemy_skills_window.height-32)))
    positions.push(CursorPosition.new(Rect.new(@enemy_drops_window.x, 
                            @enemy_drops_window.y-56, 
                            @enemy_drops_window.width-32, 
                            @enemy_drops_window.height-32)))
    
    @command_window = Window_Custom_Selectable.new(0, 56, 640, 424, positions)
    @command_window.opacity = 0
    @command_window.visible = false
    @command_window.active = false
    @command_window.index = 0

    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    @help_window.visible = false
    
    @enemy_image_window.help_window = @help_window
    @enemy_skills_window.help_window = @help_window
    @enemy_drops_window.help_window = @help_window
    
    [@enemy_name_window, @bestiary_info_window, @enemy_image_window,
     @enemy_skills_window_headers, @enemy_status_window, @enemy_drops_window_headers,
     @equip_details_window, @item_details_window, @skill_details_window, @help_window].each{
      |w| w.opacity = BESTIARY_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BESTIARY_CONFIG::WINDOW_BACK_OPACITY
    }

  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @enemy_name_window.dispose if @enemy_name_window != nil
    @bestiary_info_window.dispose if @bestiary_info_window != nil
    @enemy_image_window.dispose if @enemy_image_window != nil
    @enemy_skills_window_headers.dispose if @enemy_skills_window_headers != nil
    @enemy_skills_window.dispose if @enemy_skills_window != nil
    @enemy_status_window.dispose if @enemy_status_window != nil
    @enemy_drops_window_headers.dispose if @enemy_drops_window_headers != nil
    @enemy_drops_window.dispose if @enemy_drops_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
    @item_details_window.dispose if @item_details_window != nil
    @skill_details_window.dispose if @skill_details_window != nil
    @help_window.dispose if @help_window != nil
    @command_window.dispose if @command_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @enemy_name_window.update
    @bestiary_info_window.update

    @enemy_image_window.update
    @enemy_skills_window_headers.update
    @enemy_skills_window.update
    @enemy_status_window.update
    @enemy_drops_window_headers.update
    @enemy_drops_window.update
    @equip_details_window.update
    @item_details_window.update
    @skill_details_window.update
    @help_window.update
    @command_window.update

    if @command_window.active
      update_command_selection()
    elsif @enemy_image_window.active
      update_image_selection()
    elsif @enemy_skills_window.active
      update_skill_selection()
    elsif @enemy_drops_window.active
      update_drop_selection()
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Update windows
  #--------------------------------------------------------------------------
  def windows_update(gameEnemy)
    @isClosable = false
    # Return to initial state when the enemy changes
    @command_window.index = 0
    cancel_command()
    
    # If already scanned
    if $game_party.monsters_scanned.include?(gameEnemy.enemy_id)
      scan_mode = BESTIARY_CONFIG::FULL_SCAN_MODE
    else
      # Gets the scan mode depending on the number of enemy defeated
      for s in BESTIARY_CONFIG::SCAN_MODES
        if gameEnemy.defeated >= s.rangeEnd
          scan_mode = s.mode
        end
      end
    end
       
    @enemy_name_window.window_update(gameEnemy.enemy, scan_mode)
    @enemy_image_window.window_update(gameEnemy.enemy, scan_mode)
    @enemy_skills_window.window_update(gameEnemy.enemy, scan_mode)
    @enemy_status_window.window_update(gameEnemy, scan_mode)
    @enemy_drops_window.window_update(gameEnemy.enemy, scan_mode)
    @bestiary_info_window.window_update()
    
    @command_window.positions[1].enabled = @enemy_skills_window.hasSkills
    @command_window.positions[2].enabled = @enemy_drops_window.hasDrops
  end
  
  #--------------------------------------------------------------------------
  # * Show windows
  #--------------------------------------------------------------------------
  def show_windows
    super
    @bg.visible = true if @bg != nil
    @enemy_name_window.visible = true
    @bestiary_info_window.visible = true
    @enemy_image_window.visible = true
    @enemy_image_window.active = false
    @enemy_status_window.visible = true
    @enemy_skills_window_headers.visible = true
    @enemy_skills_window.visible = true
    @enemy_skills_window.active = false
    @enemy_drops_window_headers.visible = true
    @enemy_drops_window.visible = true
    @enemy_drops_window.active = false
    @command_window.visible = true
    @command_window.active = true   
  end
  
  #--------------------------------------------------------------------------
  # * Hide windows
  #--------------------------------------------------------------------------
  def hide_windows
    super
    @bg.visible = false if @bg != nil
    @enemy_name_window.visible = false
    @bestiary_info_window.visible = false
    @enemy_image_window.visible = false
    @enemy_image_window.active = false
    @enemy_status_window.visible = false
    @enemy_skills_window_headers.visible = false
    @enemy_skills_window.visible = false
    @enemy_skills_window.active = false
    @enemy_drops_window_headers.visible = false
    @enemy_drops_window.visible = false
    @enemy_drops_window.active = false
    @command_window.visible = false
    @command_window.active = false
  end
  
  #--------------------------------------------------------------------------
  # * Update windows Z-index
  #     new_z : new Z-index
  #--------------------------------------------------------------------------
  def update_windows_zindex(new_z)
    if new_z != nil
      
      if @zindex_adjustment != new_z
        # Determine the Z-index to apply to the windows
        z = new_z - @zindex_adjustment
        
        @zindex_adjustment = new_z
     
        # Update Z-index of the windows
        @bg.z += @enemy_name_window.z-1 + z if @bg != nil
        @enemy_name_window.z += z 
        @bestiary_info_window.z += z 
        @enemy_image_window.z += z 
        @enemy_status_window.z += z 
        @enemy_skills_window_headers.z += z 
        @enemy_skills_window.z += z 
        @enemy_drops_window_headers.z += z 
        @enemy_drops_window.z += z 
        @command_window.z += z
        @equip_details_window.z += z
        @item_details_window.z += z 
        @skill_details_window.z += z 
        @help_window.z += z
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Detail window depending of the type of the drop item
  #     item : item object
  #-------------------------------------------------------------------------- 
  def update_detail_window(item)    
    if item.is_a?(RPG::Item)
      @enemy_drops_window.detail_window = @item_details_window
    else
      @enemy_drops_window.detail_window = @equip_details_window
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Command Selection
  #--------------------------------------------------------------------------
  def update_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      quit_command()
     
    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 0  # Notes
        Sound.play_decision
        notes_command()
      when 1  # Skills
        Sound.play_decision
        skills_command()
      when 2  # Drops
        Sound.play_decision
        drops_command()
        update_detail_window(@enemy_drops_window.selected_item)
      end
    end
    
  end
  private :update_command_selection

  #--------------------------------------------------------------------------
  # * Update Skill Selection
  #--------------------------------------------------------------------------
  def update_skill_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    end
  end
  private :update_skill_selection
  
  #--------------------------------------------------------------------------
  # * Update Image Selection
  #--------------------------------------------------------------------------
  def update_image_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    end
  end
  private :update_image_selection
  
  #--------------------------------------------------------------------------
  # * Update Drop Selection
  #--------------------------------------------------------------------------
  def update_drop_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP)
      update_detail_window(@enemy_drops_window.selected_item)
    end
  end
  private :update_drop_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
    @enemy_image_window.active = false
    @enemy_skills_window.active = false
    @enemy_drops_window.active = false
    @equip_details_window.window_update(nil)
    @equip_details_window.visible = false
    @item_details_window.window_update(nil)
    @item_details_window.visible = false
    @skill_details_window.window_update(nil)
    @skill_details_window.visible = false
    @help_window.window_update("")
    @help_window.active = false
    @help_window.visible = false
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    @command_window.active = false
    @isClosable = true
  end
  private :quit_command
  
  #--------------------------------------------------------------------------
  # * Notes command
  #--------------------------------------------------------------------------
  def notes_command()
    @command_window.active = false
    @enemy_image_window.active = true
    @enemy_image_window.call_update_help()
    @help_window.visible = true
    @help_window.active = true
  end
  private :notes_command

  #--------------------------------------------------------------------------
  # * Skills command
  #--------------------------------------------------------------------------
  def skills_command()
    @command_window.active = false
    @enemy_skills_window.active = true
    @enemy_skills_window.call_update_help()
    @help_window.visible = true
  end
  private :skills_command
  
  #--------------------------------------------------------------------------
  # * Drops command
  #--------------------------------------------------------------------------
  def drops_command()
    @command_window.active = false
    @enemy_drops_window.active = true
    @enemy_drops_window.call_update_help()
    @help_window.visible = true
  end
  private :drops_command
  
end
