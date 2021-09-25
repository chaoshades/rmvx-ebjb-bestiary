################################################################################
#          EBJB Bestiary + Display Scanned Enemy - EBJB_Bestiary      #   VX   #
#                          Last Update: 2012/03/17                    ##########
#                         Creation Date: 2011/06/25                            #
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Contains custom scripts to add a Bestiary feature to your game.             #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the Bestiary_Config class. For #
#  more info on what and how to adjust these settings, see the documentation   #
#  in the class.                                                               #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Alias: Game_Battler - skill_effect, item_effect                             #
#  Alias: Game_Enemy - initialize, transform, perform_collapse, escape         #
#  Alias: Scene_Menu - create_command_window, update_command_selection         #
#  Alias: Scene_Battle - create_info_viewport, start, terminate,               #
#                        update_target_enemy_selection                         #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_Bestiary"] = true

#==============================================================================
# ** BESTIARY_CONFIG
#------------------------------------------------------------------------------
#  Contains the Bestiary configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** Scan_Mode
  #------------------------------------------------------------------------------
  #  Represents a scan mode to show different parts of data of a monster in the Bestiary
  #==============================================================================

  class Scan_Mode
    
    #//////////////////////////////////////////////////////////////////////////
    # * Public Instance Variables
    #//////////////////////////////////////////////////////////////////////////
    
    # End value for the range to apply the scan mode (number of defeated monsters)
    attr_reader :rangeEnd
    # Array of modes that describes the data to show
    attr_reader :mode
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     rangeEnd :
    #     mode : 
    #--------------------------------------------------------------------------
    def initialize(rangeEnd, mode)
      @rangeEnd = rangeEnd
      @mode = mode
    end
    
  end
  
  module BESTIARY_CONFIG
    
    # Background image filename, it must be in folder Pictures
    IMAGE_BG = ""
    # Opacity for background image
    IMAGE_BG_OPACITY = 255
    # All windows opacity
    WINDOW_OPACITY = 255
    WINDOW_BACK_OPACITY = 200
    
    #------------------------------------------------------------------------
    # Bestiary Info Window related
    #------------------------------------------------------------------------
    
    # Format to use for bestiary completion
    RATE_COMPLETION = "%#.05g%%"
    # Icon for the completion rate
    ICON_COMPLETION = 141
    
    #------------------------------------------------------------------------
    # Window Enemy Status related
    #------------------------------------------------------------------------
    
    # Number of icons to show at the same time
    ACT_STATES_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    ACT_STATES_ICONS_TIMEOUT = 1
    
    # Icon for HP
    ICON_HP  = 99
    # Icon for MP
    ICON_MP  = 100
    # Icon for ATK
    ICON_ATK  = 2
    # Icon for DEF
    ICON_DEF  = 52
    # Icon for SPI
    ICON_SPI  = 21
    # Icon for AGI
    ICON_AGI  = 48
    # Icon for EVA
    ICON_EVA  = 158
    # Icon for HIT
    ICON_HIT  = 135
    # Icon for CRI
    ICON_CRI  = 119
    
    # Icon for GOLD
    ICON_GOLD  = 147
    # Icon for EXP
    ICON_EXP  = 62
    # Icon for ENCOUNTERS
    ICON_ENCOUNTERS = 63
    # Icon for DEFEATED
    ICON_DEFEATED  = 157
    # Icon for ESCAPED
    ICON_ESCAPED  = 155
    
    # Gauge pattern
    GAUGE_PATTERN = "%d/%d"
    # Percentage pattern
    PERCENTAGE_PATTERN = "%d%"
    
    #------------------------------------------------------------------------
    # Element Resistance Graph related
    #------------------------------------------------------------------------
    
    # Minimum value used in the Elemental Resistance Graph 
    ELEM_RES_MIN = -100
    # Maximum value used in the Elemental Resistance Graph 
    ELEM_RES_MAX = 200
    
    #------------------------------------------------------------------------
    # Status Resistance Graph related
    #------------------------------------------------------------------------
    
    # Minimum value used in the Status Resistance Graph 
    STATES_RES_MIN = -100
    # Maximum value used in the Status Resistance Graph 
    STATES_RES_MAX = 100
    
    #------------------------------------------------------------------------
    # Window Enemy Name related
    #------------------------------------------------------------------------
    
    # Pattern to use to show the enemy id
    ENEMY_ID_PATTERN = "%03d:"
    
    #------------------------------------------------------------------------
    # Sub Scene Scan related
    #------------------------------------------------------------------------
    
    # Unique ids used to represent scan modes
    # STATS = 10xx
    SHOW_STATS_HP = 1001
    SHOW_STATS_MP = 1002
    SHOW_STATS_ATK = 1003
    SHOW_STATS_DEF = 1004
    SHOW_STATS_SPI = 1005
    SHOW_STATS_AGI = 1006
    SHOW_STATS_EVA = 1007
    SHOW_STATS_HIT = 1008
    SHOW_STATS_CRI = 1009
    
    # SPOIL = 20xx
    SHOW_SPOIL_GOLD = 2001
    SHOW_SPOIL_EXP = 2002
    
    # OTHER = 30xx
    SHOW_NAME = 3001
    SHOW_IMAGE = 3002
    SHOW_NOTE = 3003
    
    # RESIST = 40xx
    SHOW_ELEM_RES = 4001
    SHOW_STATES_RES = 4002
    
    # SKILLS = 50xx
    SHOW_SKILLS = 5001
    
    # DROPS = 60xx
    SHOW_DROPS = 6001
    
    # Character used to hide data
    HIDE_CHAR = "?"
    # Default hide pattern used in the Bestiary windows
    DEFAULT_HIDE_PATTERN = ([HIDE_CHAR] * 5).join
    
    # Scan modes definitions
    
    # Default Full Scan mode
    FULL_SCAN_MODE = [SHOW_STATS_HP, SHOW_STATS_MP, SHOW_STATS_ATK, SHOW_STATS_DEF,
                      SHOW_STATS_SPI, SHOW_STATS_AGI, SHOW_STATS_EVA, SHOW_STATS_HIT,
                      SHOW_STATS_CRI,
                      SHOW_SPOIL_GOLD, SHOW_SPOIL_EXP, 
                      SHOW_NAME, SHOW_IMAGE, SHOW_NOTE,
                      SHOW_ELEM_RES, SHOW_STATES_RES,
                      SHOW_SKILLS, SHOW_DROPS]
    # Scan modes array
    SCAN_MODES = [
      # First mode - Hide all
      Scan_Mode.new(0, []),
      # Second mode - Show Basic information
      Scan_Mode.new(1, [SHOW_SPOIL_GOLD, SHOW_SPOIL_EXP, 
                        SHOW_NAME, SHOW_IMAGE, SHOW_NOTE]),
      # Third mode - Show HP and MP
      Scan_Mode.new(20, [SHOW_STATS_HP, SHOW_STATS_MP, 
                         SHOW_SPOIL_GOLD, SHOW_SPOIL_EXP, 
                         SHOW_NAME, SHOW_IMAGE, SHOW_NOTE, 
                         SHOW_DROPS]),
      # Fourth mode - Show status & Drops
      Scan_Mode.new(40, [SHOW_STATS_HP, SHOW_STATS_MP, SHOW_STATS_ATK, SHOW_STATS_DEF,
                         SHOW_STATS_SPI, SHOW_STATS_AGI, SHOW_STATS_EVA, SHOW_STATS_HIT,
                         SHOW_STATS_CRI,
                         SHOW_SPOIL_GOLD, SHOW_SPOIL_EXP, 
                         SHOW_NAME, SHOW_IMAGE, SHOW_NOTE, 
                         SHOW_DROPS]),
      # Fifth mode - Show all
      Scan_Mode.new(60, FULL_SCAN_MODE)
    ]
    
    # Skills ID that scan monsters
    SCAN_SKILLS_ID = [83]
    
    # Items ID that scan monsters
    SCAN_ITEMS_ID = [21]
    
    #------------------------------------------------------------------------
    # Scene Battle related
    #------------------------------------------------------------------------
    
    # This is the button pressed to trigger the enemy scan window in battle
    ENEMY_SCAN_BUTTON = Input::A

    # This turns the window on and off
    HELP_WINDOW_ON = true
    # This is where the X position is
    HELP_WINDOW_X  = 0
    # This is where the Y position is
    HELP_WINDOW_Y  = 0
    # This is the help window width
    HELP_WINDOW_W  = 640
    # This is the help window height
    HELP_WINDOW_H  = 56

    # Timeout in seconds of SCAN_MSG
    SCAN_MSG_TIMEOUT = 1
    # Timeout in seconds of SCAN_MSG_2
    SCAN_MSG_2_TIMEOUT = 0.5
  end
end

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

#==============================================================================
# ** Font
#------------------------------------------------------------------------------
#  Contains the different fonts
#==============================================================================

class Font
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Graph Label Font
  #--------------------------------------------------------------------------
  def self.graph_label_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Hidden Image Font
  #--------------------------------------------------------------------------
  def self.hidden_image_font
    f = Font.new()
    f.size = 96
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Hidden Resistance Font
  #--------------------------------------------------------------------------
  def self.hidden_res_font
    f = Font.new()
    f.size = 48
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Selectable Window Headers Font
  #--------------------------------------------------------------------------
  def self.selectable_headers_font
    f = Font.new()
    f.size = 14
    f.color = Color.system_color
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Stats Font
  #--------------------------------------------------------------------------
  def self.item_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Plus States Font
  #--------------------------------------------------------------------------
  def self.item_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Minus States Font
  #--------------------------------------------------------------------------
  def self.item_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details HP/MP Font
  #--------------------------------------------------------------------------
  def self.skill_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Plus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Minus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
#  Contains the different colors
#==============================================================================

class Color
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.hp_gauge_color1
    return text_color(20)
  end
  
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.hp_gauge_color2
    return text_color(21)
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.mp_gauge_color1
    return text_color(22)
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.mp_gauge_color2
    return text_color(23)
  end
  
  #--------------------------------------------------------------------------
  # * Get Positive Resist Gauge Color 1
  #--------------------------------------------------------------------------
  def self.pos_resist_gauge_color1
    return text_color(22)
  end
  
  #--------------------------------------------------------------------------
  # * Get Positive Resist Gauge Color 2
  #--------------------------------------------------------------------------
  def self.pos_resist_gauge_color2
    return text_color(23)
  end
  
  #--------------------------------------------------------------------------
  # * Get Negative Resist Gauge Color 1
  #--------------------------------------------------------------------------
  def self.neg_resist_gauge_color1
    return text_color(20)
  end
  
  #--------------------------------------------------------------------------
  # * Get Negative Resist Gauge Color 2
  #--------------------------------------------------------------------------
  def self.neg_resist_gauge_color2
    return text_color(21)
  end
  
  #--------------------------------------------------------------------------
  # * Get Resist Border Color 1
  #--------------------------------------------------------------------------
  def self.resist_border_color1
    return text_color(0)
  end
  
  #--------------------------------------------------------------------------
  # * Get Resist Border Color 2
  #--------------------------------------------------------------------------
  def self.resist_border_color2
    return text_color(7)
  end

end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #//////////////////////////////////////////////////////////////////////////
  # * Stats Parameters related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get HP Label
  #--------------------------------------------------------------------------
  def self.hp_label
    return self.hp
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Label
  #--------------------------------------------------------------------------
  def self.mp_label
    return self.mp
  end
  
  #--------------------------------------------------------------------------
  # * Get ATK Label
  #--------------------------------------------------------------------------
  def self.atk_label
    return self.atk
  end
  
  #--------------------------------------------------------------------------
  # * Get DEF Label
  #--------------------------------------------------------------------------
  def self.def_label
    return self.def
  end
  
  #--------------------------------------------------------------------------
  # * Get SPI Label
  #--------------------------------------------------------------------------
  def self.spi_label
    return self.spi
  end
  
  #--------------------------------------------------------------------------
  # * Get AGI Label
  #--------------------------------------------------------------------------
  def self.agi_label
    return self.agi
  end
  
  #--------------------------------------------------------------------------
  # * Get EVA Label
  #--------------------------------------------------------------------------
  def self.eva_label
    return "EVA"
  end
  
  #--------------------------------------------------------------------------
  # * Get HIT Label
  #--------------------------------------------------------------------------
  def self.hit_label
    return "HIT"
  end
  
  #--------------------------------------------------------------------------
  # * Get CRI Label
  #--------------------------------------------------------------------------
  def self.cri_label
    return "CRI"
  end
  
  #--------------------------------------------------------------------------
  # * Get EXP Label
  #--------------------------------------------------------------------------
  def self.exp_label
    return "EXP"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Details Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Elements list
  #--------------------------------------------------------------------------
  def self.elements_label
    return "ELEMENTS"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the States list
  #--------------------------------------------------------------------------
  def self.states_label
    return "STATES"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Stats
  #--------------------------------------------------------------------------
  def self.stats_label
    return "STATS"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Recovery effect
  #--------------------------------------------------------------------------
  def self.recovery_label
    return "RECOVERY"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Damage effect
  #--------------------------------------------------------------------------
  def self.damage_label
    return "DAMAGE"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Scope list
  #--------------------------------------------------------------------------
  def self.scopes_label
    return "DAMAGE"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Bonus list
  #--------------------------------------------------------------------------
  def self.bonus_label
    return "BONUS"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Menu related
  #//////////////////////////////////////////////////////////////////////////
    
  #--------------------------------------------------------------------------
  # * Get Title to show in the menu
  #--------------------------------------------------------------------------
  def self.bestiary_menu_title
    return "Bestiary"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Window Enemy Status related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the active states list
  #--------------------------------------------------------------------------
  def self.active_status_label
    return "Active status"
  end

  #--------------------------------------------------------------------------
  # * Get Label for Elemental Resistance
  #--------------------------------------------------------------------------
  def self.elem_resist_label
    return "Elemental Resist."
  end
  
  #--------------------------------------------------------------------------
  # * Get Label for States Resistance
  #--------------------------------------------------------------------------
  def self.states_resist_label
    return "States Resist."
  end
    
  #--------------------------------------------------------------------------
  # * Get Label for GOLD
  #--------------------------------------------------------------------------
  def self.gold_label
    return "Gold"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label for ENCOUNTERS
  #--------------------------------------------------------------------------
  def self.encounters_label
    return "Encounters"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label for DEFEATED
  #--------------------------------------------------------------------------
  def self.defeated_label
    return "Defeated"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label for ESCAPED
  #--------------------------------------------------------------------------
  def self.escaped_label
    return "Escaped"
  end
    
  #//////////////////////////////////////////////////////////////////////////
  # Window Enemy Skills related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Skills header for the Skills window in the Bestiary
  #--------------------------------------------------------------------------
  def self.bestiary_skills_header
    return "Skills"
  end
  
  #--------------------------------------------------------------------------
  # * Get Skills Cost header for the Skills window in the Bestiary
  #--------------------------------------------------------------------------
  def self.bestiary_skills_cost_header
    return self.mp_label
  end
  
  #--------------------------------------------------------------------------
  # * Get Label when there are no skills
  #--------------------------------------------------------------------------
  def self.bestiary_no_skills_label
    return "None"
  end
    
  #//////////////////////////////////////////////////////////////////////////
  # Window Enemy Drops related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Drops header for the Drops window in the Bestiary
  #--------------------------------------------------------------------------
  def self.bestiary_drops_header
    return "Drops"
  end
  
  #--------------------------------------------------------------------------
  # * Get Drops Chances header for the Drops window in the Bestiary
  #--------------------------------------------------------------------------
  def self.bestiary_drops_chances_header
    return "Chances"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label when there are no drops
  #--------------------------------------------------------------------------
  def self.bestiary_no_drops_label
    return "None"
  end
    
  #//////////////////////////////////////////////////////////////////////////
  # Scene Battle related
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Get Help text in battle for the Bestiary
  #--------------------------------------------------------------------------
  def self.bestiary_help_text
    return "Press A for more details on the enemy"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when scanning a monster
  #--------------------------------------------------------------------------
  def self.bestiary_scan_text_1
    return "Scanning %s data..."
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when the data is added to the bestiary
  #--------------------------------------------------------------------------
  def self.bestiary_scan_text_2
    return "Added to the bestiary."
  end   
    
end

#==============================================================================
# ** Window_Bestiary_Info
#------------------------------------------------------------------------------
#  This window displays different statistics on the bestiary
#==============================================================================

class Window_Bestiary_Info < Window_Base
  include EBJB
    
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelIcon for the bestiary completion
  attr_reader :ucBestiaryCompletion
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    
    @ucBestiaryCompletion = UCLabelIcon.new(self, Rect.new(56,0,200,WLH), Rect.new(24,0,WLH,WLH), 
                            "", 
                            BESTIARY_CONFIG::ICON_COMPLETION)
    
    window_update()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucBestiaryCompletion.draw()
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def window_update()
    @ucBestiaryCompletion.cLabel.text = sprintf(BESTIARY_CONFIG::RATE_COMPLETION, bestiary_completion)
    
    refresh()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Bestiary completion rate
  #--------------------------------------------------------------------------
  def bestiary_completion
    completion = 0.0
    
    for enemy in $data_enemies
      next if enemy == nil
      next if $game_party.monsters_defeated[enemy.id] == nil
      next if $game_party.monsters_defeated[enemy.id] == 0 &&
              !$game_party.monsters_scanned.include?(enemy.id)
      
      # If already scanned
      if $game_party.monsters_scanned.include?(enemy.id)
        completion += 1
      else
        rate = 0
        # Gets the scan mode depending on the number of enemy defeated
        for s in BESTIARY_CONFIG::SCAN_MODES
          if $game_party.monsters_defeated[enemy.id] >= s.rangeEnd
            rate += 1
          end
        end
        completion += rate / BESTIARY_CONFIG::SCAN_MODES.size.to_f
      end

    end
    
    completion *= 100.0
    completion /= $data_enemies.size
    return completion
  end
  private :bestiary_completion
  
end

#===============================================================================
# ** Window_Enemy_Drops
#------------------------------------------------------------------------------
#  This window displays the enemy drops
#===============================================================================

class Window_Enemy_Drops < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCDropItem for every drops of the enemy
  attr_reader :ucDropItemsList
  # Label for message (no drops or when drops are hidden)
  attr_reader :cMsg
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Get the current drop
  #--------------------------------------------------------------------------
  # GET
  def selected_drop
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #--------------------------------------------------------------------------
  # * Get the current item (contained in the drop)
  #--------------------------------------------------------------------------
  # GET
  def selected_item
    if selected_drop != nil
      case selected_drop.kind
        when 1
          item = $data_items[selected_drop.item_id]
        when 2
          item = $data_weapons[selected_drop.weapon_id]
        when 3
          item = $data_armors[selected_drop.armor_id]
      end
    else
      item = nil
    end
    return item
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
    
    @ucDropItemsList = []
    @drop_detail_window = nil
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
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_DROPS)
        @cMsg.text = Vocab::bestiary_no_drops_label
        
        drops = enemy.drops
        @data = []
        if drops != nil
          for drop in drops
            if drop != nil
              @data.push(drop)
            end
          end
          @item_max = @data.size
          create_contents()
          @ucDropItemsList.clear()
          for i in 0..@item_max-1
            @ucDropItemsList.push(create_item(i))
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
  def refresh()
    self.contents.clear
    if @scan_mode.include?(BESTIARY_CONFIG::SHOW_DROPS) && hasDrops
      self.index = 0
      @ucDropItemsList.each() { |dropData| dropData.draw() }
    else
      self.index = -1
      @cMsg.draw()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_item != nil
      @help_window.window_update(selected_item.description)
    else
      @help_window.window_update("")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && 
           ((selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_ItemDetails)) ||
           (!selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_EquipDetails)))
  end
  
  #--------------------------------------------------------------------------
  # * Return true if there are drops in the list else false
  #--------------------------------------------------------------------------
  def hasDrops
    return @ucDropItemsList.size > 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the ShopItems list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)

    dropItem = UCDropItem.new(self, item, rect)
    
    return dropItem
  end
  private :create_item
  
end

#===============================================================================
# ** Window_Enemy_Image
#------------------------------------------------------------------------------
#  This window displays the enemy image and description
#===============================================================================

class Window_Enemy_Image < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Control to show the enemy graphic
  attr_reader :ucEnemyGraphic
  # Label control to show when the enemy graphic is hidden
  attr_reader :cHiddenImage
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @ucEnemyGraphic = UCEnemyGraphic.new(self, Rect.new(0,0,self.contents.width,self.contents.height), nil)
    @ucEnemyGraphic.cEnemyGraphic.align = 1
    @ucEnemyGraphic.cEnemyGraphic.valign = 2
    @ucEnemyGraphic.cEnemyGraphic.resize_mode = 2
    @cHiddenImage = CLabel.new(self, Rect.new(0,0,170,200), BESTIARY_CONFIG::HIDE_CHAR,
                               1, Font.hidden_image_font)
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @ucEnemyGraphic.enemy != nil
      if @scan_mode.include?(BESTIARY_CONFIG::SHOW_NOTE)
        @help_window.window_update(@ucEnemyGraphic.enemy.note)
      else
        @help_window.window_update(BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN)
      end
    else
      @help_window.window_update("")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     enemy : enemy object
  #     scan_mode : scan mode
  #--------------------------------------------------------------------------
  def window_update(enemy, scan_mode)
    if enemy != nil
      @scan_mode = scan_mode
      @ucEnemyGraphic.enemy = enemy
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    if @scan_mode.include?(BESTIARY_CONFIG::SHOW_IMAGE)
      @ucEnemyGraphic.draw()
    else
      @cHiddenImage.draw()
    end
  end
  
end

#===============================================================================
# ** Window_Enemy_Name
#------------------------------------------------------------------------------
#  This window displays the enemy name
#===============================================================================

class Window_Enemy_Name < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label control for the enemy id
  attr_reader :cEnemyId
  # Label control for the enemy name
  attr_reader :cEnemyName
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width  : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @cEnemyId = CLabel.new(self, Rect.new(0,0,50,WLH), "")
    @cEnemyName = CLabel.new(self, Rect.new(50,0,240,WLH), "")
    @cEnemyName.font = Font.bold_font
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
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_NAME)
        @cEnemyId.text = sprintf(BESTIARY_CONFIG::ENEMY_ID_PATTERN,enemy.id)
        @cEnemyName.text = enemy.name
      else
        @cEnemyId.text = sprintf(BESTIARY_CONFIG::ENEMY_ID_PATTERN,enemy.id)
        @cEnemyName.text = ([BESTIARY_CONFIG::HIDE_CHAR] * enemy.name.length).join
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cEnemyId.draw()
    @cEnemyName.draw()
  end
  
end

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

#===============================================================================
# ** Window_Enemy_Status
#------------------------------------------------------------------------------
#  This window displays the enemy status and resistances
#===============================================================================

class Window_Enemy_Status < Window_Base
  include EBJB
    
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Control that shows the enemy status
  attr_reader :ucEnemyStatus
  # Control that shows the enemy spoil
  attr_reader :ucEnemySpoil
  # Label for the Elemental Resistance graph
  attr_reader :cElementalResistLabel
  # Elemental Resistance graph
  attr_reader :ucElementalResistGraph
  # Label when the Elemental Resistance is hidden
  attr_reader :cHiddenElemRes
  # Label for the States Resistance graph
  attr_reader :cStatesResistLabel
  # States Resistance graph
  attr_reader :ucStatesResistGraph
  # Label when the States Resistance is hidden
  attr_reader :cHiddenStatesRes
  
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
    
    @ucEnemyStatus = UCEnemyStatus.new(self, nil, Rect.new(194,0,190,240))
    
    @ucEnemySpoil = UCEnemySpoil.new(self, nil, Rect.new(0,245,180,120))
    
    @cElementalResistLabel = CLabel.new(self, Rect.new(194,245,175,WLH), Vocab::elem_resist_label)

    @ucElementalResistGraph = UCGraph.new(self, 295, 330, 40, [0], BESTIARY_CONFIG::PERCENTAGE_PATTERN,
                                          BESTIARY_CONFIG::ELEM_RES_MAX,
                                          BESTIARY_CONFIG::ELEM_RES_MIN,
                                          Font.graph_label_font,
                                          Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                          Color.neg_resist_gauge_color1, Color.neg_resist_gauge_color2,
                                          nil, 2, Color.resist_border_color1, Color.resist_border_color2)
    @cHiddenElemRes = CLabel.new(self, Rect.new(194,280,200,100), BESTIARY_CONFIG::HIDE_CHAR,
                                 1, Font.hidden_res_font)
                               
    @cStatesResistLabel = CLabel.new(self, Rect.new(400,245,175,WLH), Vocab::states_resist_label)
    
    @ucStatesResistGraph = UCGraph.new(self, 504, 330, 40, [0], BESTIARY_CONFIG::PERCENTAGE_PATTERN,
                                       BESTIARY_CONFIG::STATES_RES_MAX,
                                       BESTIARY_CONFIG::STATES_RES_MIN,
                                       Font.graph_label_font,
                                       Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                       nil, nil, 
                                       nil, 2, Color.resist_border_color1, Color.resist_border_color2)
    @cHiddenStatesRes = CLabel.new(self, Rect.new(405,280,200,100), BESTIARY_CONFIG::HIDE_CHAR,
                                   1, Font.hidden_res_font)                               
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     gameEnemy : Game Enemy object
  #     scan_mode : scan mode
  #--------------------------------------------------------------------------
  def window_update(gameEnemy, scan_mode)
    if gameEnemy != nil
      @scan_mode = scan_mode
      
      iconsArray = []
      for i in 0 .. gameEnemy.states.size-1
        iconsArray[i] = gameEnemy.states[i].icon_index
      end
      @ucEnemyStatus.ucActStates.icons = iconsArray
      
      #------------------------------------------
      # HP/MP section
      #------------------------------------------
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_HP)
        @ucEnemyStatus.ucHpStat.cValue.text = sprintf(BESTIARY_CONFIG::GAUGE_PATTERN,gameEnemy.hp,
                                                      gameEnemy.base_maxhp)
        @ucEnemyStatus.cHpStatGauge.value = gameEnemy.hp
        @ucEnemyStatus.cHpStatGauge.max_value = gameEnemy.base_maxhp
        
        if gameEnemy.hp == 0
          @ucEnemyStatus.ucHpStat.cValue.font.color = Color.knockout_color
        elsif gameEnemy.hp < gameEnemy.maxhp / 4
          @ucEnemyStatus.ucHpStat.cValue.font.color = Color.crisis_color
        else
          @ucEnemyStatus.ucHpStat.cValue.font.color = Color.normal_color
        end
      else
        @ucEnemyStatus.ucHpStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
        @ucEnemyStatus.cHpStatGauge.value = 0
        @ucEnemyStatus.cHpStatGauge.max_value = 0
        @ucEnemyStatus.ucHpStat.cValue.font.color = Color.normal_color
      end
      
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_MP)
        @ucEnemyStatus.ucMpStat.cValue.text = sprintf(BESTIARY_CONFIG::GAUGE_PATTERN,gameEnemy.mp,
                                                      gameEnemy.base_maxmp)
        @ucEnemyStatus.cMpStatGauge.value = gameEnemy.mp
        @ucEnemyStatus.cMpStatGauge.max_value = gameEnemy.base_maxmp
        
        if gameEnemy.mp < gameEnemy.maxmp / 4
          @ucEnemyStatus.ucMpStat.cValue.font.color = Color.crisis_color
        else
          @ucEnemyStatus.ucMpStat.cValue.font.color = Color.normal_color
        end
      else
        @ucEnemyStatus.ucMpStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
        @ucEnemyStatus.cMpStatGauge.value = 0
        @ucEnemyStatus.cMpStatGauge.max_value = 0
        @ucEnemyStatus.ucMpStat.cValue.font.color = Color.normal_color
      end
      
      #------------------------------------------
      # Stats section
      #------------------------------------------
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_ATK)
        @ucEnemyStatus.ucAtkStat.cValue.text = gameEnemy.base_atk
      else
        @ucEnemyStatus.ucAtkStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_DEF)
        @ucEnemyStatus.ucDefStat.cValue.text = gameEnemy.base_def
      else
        @ucEnemyStatus.ucDefStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_SPI)
        @ucEnemyStatus.ucSpiStat.cValue.text = gameEnemy.base_spi
      else
        @ucEnemyStatus.ucSpiStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_AGI)
        @ucEnemyStatus.ucAgiStat.cValue.text = gameEnemy.base_spi
      else
        @ucEnemyStatus.ucAgiStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_EVA)
        @ucEnemyStatus.ucEvaStat.cValue.text = sprintf(BESTIARY_CONFIG::PERCENTAGE_PATTERN, gameEnemy.eva)
      else
        @ucEnemyStatus.ucEvaStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_HIT)
        @ucEnemyStatus.ucHitStat.cValue.text = sprintf(BESTIARY_CONFIG::PERCENTAGE_PATTERN, gameEnemy.hit)
      else
        @ucEnemyStatus.ucHitStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_STATS_CRI)
        @ucEnemyStatus.ucCriStat.cValue.text = sprintf(BESTIARY_CONFIG::PERCENTAGE_PATTERN, gameEnemy.cri)
      else
        @ucEnemyStatus.ucCriStat.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      
      #------------------------------------------
      # Spoils section
      #------------------------------------------
      @ucEnemySpoil.ucEncounters.cValue.text = gameEnemy.encounters
      @ucEnemySpoil.ucDefeated.cValue.text = gameEnemy.defeated
      @ucEnemySpoil.ucEscaped.cValue.text = gameEnemy.escaped
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_SPOIL_EXP)
        @ucEnemySpoil.ucExp.cValue.text = gameEnemy.exp
      else
        @ucEnemySpoil.ucExp.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      if scan_mode.include?(BESTIARY_CONFIG::SHOW_SPOIL_GOLD)
        @ucEnemySpoil.ucGold.cValue.text = gameEnemy.gold
      else
        @ucEnemySpoil.ucGold.cValue.text = BESTIARY_CONFIG::DEFAULT_HIDE_PATTERN
      end
      
      #------------------------------------------
      # Resistances section
      #------------------------------------------
      elements = []
      showElemRes = scan_mode.include?(BESTIARY_CONFIG::SHOW_ELEM_RES)
      for i in 9..16
        
        if showElemRes
          value = gameEnemy.element_rate(i)
        else
          value = 0
        end
        
        elements.push(GraphElement.new(CORE_CONFIG::ELEMENT_ICONS[i], value))
      end
      @ucElementalResistGraph.elements = elements
      @ucElementalResistGraph.hide_values = !showElemRes

      elements = []
      showStatesRes = scan_mode.include?(BESTIARY_CONFIG::SHOW_STATES_RES)
      for i in 1 .. $data_states.size-1
        state = $data_states[i]
        if !state.nonresistance
          
          if showStatesRes
            value = gameEnemy.state_probability(state.id)
          else
            value = 0
          end
          
          elements.push(GraphElement.new(state.icon_index, value))
        end
      end
      @ucStatesResistGraph.elements = elements
      @ucStatesResistGraph.hide_values = !showStatesRes
      
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucEnemyStatus.draw()
    @ucEnemySpoil.draw()
    @cElementalResistLabel.draw()
    @ucElementalResistGraph.draw()
    if !@scan_mode.include?(BESTIARY_CONFIG::SHOW_ELEM_RES)
      @cHiddenElemRes.draw()
    end
    @cStatesResistLabel.draw()
    @ucStatesResistGraph.draw()
    if !@scan_mode.include?(BESTIARY_CONFIG::SHOW_STATES_RES)
      @cHiddenStatesRes.draw()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update (for the icons list that refreshed after a timeout)
  #--------------------------------------------------------------------------
  def update
    super
    @ucEnemyStatus.ucActStates.update()
  end
  
end

#==============================================================================
# ** UCDropItem
#------------------------------------------------------------------------------
#  Represents a drop item on a window
#==============================================================================

class UCDropItem < UserControl
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icon control for the drop item
  attr_reader :ucIcon
  # Label control for the drop name
  attr_reader :cDropName
  # Label control for the drop chances
  attr_reader :cDropChances
  # Item object
  attr_reader :dropItem
  
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
    @cDropName.visible = visible
    @cDropChances.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cDropName.active = active
    @cDropChances.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     dropItem : item object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, dropItem, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @dropItem = dropItem
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    case dropItem.kind
      when 1
        item = $data_items[dropItem.item_id]
      when 2
        item = $data_weapons[dropItem.weapon_id]
      when 3
        item = $data_armors[dropItem.armor_id]
    end

    @ucIcon = UCIcon.new(window, rects[0], item.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cDropName = CLabel.new(window, rects[1], item.name)
    @cDropName.active = active
    @cDropName.visible = visible
    @cDropName.cut_overflow = true

    @cDropChances = CLabel.new(window, rects[2], "1/" + dropItem.denominator.to_s)
    @cDropChances.align = 2
    @cDropChances.active = active
    @cDropChances.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cDropName.draw()
    @cDropChances.draw()
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
    
    # cDropName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cDropChances
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects

end

#==============================================================================
# ** UCEnemySpoil
#------------------------------------------------------------------------------
#  Represents a group of controls to show the enemy spoil data in the bestiary
#==============================================================================

class UCEnemySpoil < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelIconValue for the number of enemy encountered
  attr_reader :ucEncounters
  # UCLabelIconValue for the number of enemy defeated
  attr_reader :ucDefeated
  # UCLabelIconValue for the number of enemy escaped
  attr_reader :ucEscaped
  # UCLabelIconValue for the EXP given by the enemy
  attr_reader :ucExp
  # UCLabelIconValue for the GOLD given by the enemy
  attr_reader :ucGold
  # Enemy object
  attr_reader :enemy
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucEncounters.visible = visible
    @ucDefeated.visible = visible
    @ucEscaped.visible = visible
    @ucExp.visible = visible
    @ucGold.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucEncounters.active = active
    @ucDefeated.active = active
    @ucEscaped.active = active
    @ucExp.active = active
    @ucGold.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     enemy : enemy object
  #     rect : rectangle to position the controls for the enemy
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, enemy, rect, spacing=24,
                 active=true, visible=true)
    super(active, visible)
    @enemy = enemy
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucEncounters = UCLabelIconValue.new(window, rects[0][1], 
                                         rects[0][0], rects[0][2],
                                         Vocab::encounters_label, BESTIARY_CONFIG::ICON_ENCOUNTERS, 0)
    @ucEncounters.cValue.align = 2
    @ucEncounters.active = active
    @ucEncounters.visible = visible
    
    @ucDefeated = UCLabelIconValue.new(window, rects[1][1], 
                                      rects[1][0], rects[1][2],
                                       Vocab::defeated_label, BESTIARY_CONFIG::ICON_DEFEATED, 0)
    @ucDefeated.cValue.align = 2
    @ucDefeated.active = active
    @ucDefeated.visible = visible
    
    @ucEscaped = UCLabelIconValue.new(window, rects[2][1], 
                                      rects[2][0], rects[2][2],
                                      Vocab::escaped_label, BESTIARY_CONFIG::ICON_ESCAPED, 0)
    @ucEscaped.cValue.align = 2
    @ucEscaped.active = active
    @ucEscaped.visible = visible
    
    @ucExp = UCLabelIconValue.new(window, rects[3][1], 
                                  rects[3][0], rects[3][2],
                                  Vocab::exp_label,BESTIARY_CONFIG::ICON_EXP, 0)
    @ucExp.cValue.align = 2
    @ucExp.active = active
    @ucExp.visible = visible
    
    @ucGold = UCLabelIconValue.new(window, rects[4][1], 
                                   rects[4][0], rects[4][2],
                                   Vocab::gold_label, BESTIARY_CONFIG::ICON_GOLD, 0)
    @ucGold.cValue.align = 2
    @ucGold.active = active
    @ucGold.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucEncounters.draw()
    @ucDefeated.draw()
    @ucEscaped.draw()
    @ucExp.draw()
    @ucGold.draw()
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
    rects[0] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,80,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[1] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,80,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[2] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,80,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    
    # Rects Adjustments
    
    # ucEncounters
    rects[0][1].x += rects[0][0].width
    rects[0][2].x = rects[0][1].x + rects[0][1].width
    rects[0][2].width = rect.width - rects[0][0].width - rects[0][1].width
    
    # ucDefeated
    rects[1][0].y += spacing
    rects[1][1].x += rects[1][0].width
    rects[1][1].y = rects[1][0].y
    rects[1][2].x = rects[1][1].x + rects[1][1].width
    rects[1][2].y = rects[1][0].y
    rects[1][2].width = rect.width - rects[1][0].width - rects[1][1].width
    
    # ucEscaped
    rects[2][0].y += spacing*2
    rects[2][1].x += rects[2][0].width
    rects[2][1].y = rects[2][0].y
    rects[2][2].x = rects[2][1].x + rects[2][1].width
    rects[2][2].y = rects[2][0].y
    rects[2][2].width = rect.width - rects[2][0].width - rects[2][1].width
    
    # ucExp
    rects[3][0].y += spacing*3
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].x = rects[3][1].x + rects[3][1].width
    rects[3][2].y = rects[3][0].y
    rects[3][2].width = rect.width - rects[3][0].width - rects[3][1].width
        
    # ucGold
    rects[4][0].y += spacing*4
    rects[4][1].x += rects[4][0].width
    rects[4][1].y = rects[4][0].y
    rects[4][2].x = rects[4][1].x + rects[4][1].width
    rects[4][2].y = rects[4][0].y
    rects[4][2].width = rect.width - rects[4][0].width - rects[4][1].width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCEnemyStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the enemy status in the bestiary
#==============================================================================

class UCEnemyStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icons list for the actives states of the enemy
  attr_reader :ucActStates
  # UCLabelIconValue for the HP stat of the enemy
  attr_reader :ucHpStat
  # UCBar for the HP stat gauge of the enemy
  attr_reader :cHpStatGauge
  # UCLabelIconValue for the MP stat of the enemy
  attr_reader :ucMpStat
  # UCBar for the MP stat gauge of the enemy
  attr_reader :cMpStatGauge
  # UCLabelIconValue for the ATK stat of the enemy
  attr_reader :ucAtkStat
  # UCLabelIconValue for the DEF stat of the enemy
  attr_reader :ucDefStat
  # UCLabelIconValue for the SPI stat of the enemy
  attr_reader :ucSpiStat
  # UCLabelIconValue for the AGI stat of the enemy
  attr_reader :ucAgiStat
  # UCLabelIconValue for the EVA stat of the enemy
  attr_reader :ucEvaStat
  # UCLabelIconValue for the HIT stat of the enemy
  attr_reader :ucHitStat
  # UCLabelIconValue for the CRI stat of the enemy
  attr_reader :ucCriStat
  # Enemy object
  attr_reader :enemy
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucActStates.visible = visible
    @ucHpStat.visible = visible
    @cHpStatGauge.visible = visible
    @ucMpStat.visible = visible
    @cMpStatGauge.visible = visible
    @ucAtkStat.visible = visible
    @ucDefStat.visible = visible
    @ucSpiStat.visible = visible
    @ucAgiStat.visible = visible
    @ucEvaStat.visible = visible
    @ucHitStat.visible = visible
    @ucCriStat.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucActStates.active = active
    @ucHpStat.active = active
    @cHpStatGauge.active = active
    @ucMpStat.active = active
    @cMpStatGauge.active = active
    @ucAtkStat.active = active
    @ucDefStat.active = active
    @ucSpiStat.active = active
    @ucAgiStat.active = active
    @ucEvaStat.active = active
    @ucHitStat.active = active
    @ucCriStat.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     enemy : enemy object
  #     rect : rectangle to position the controls for the enemy
  #     spacing : spacing between controls
  #     right_pad : right padding to add to the values
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, enemy, rect, spacing=24, right_pad=2,
                 active=true, visible=true)
    super(active, visible)
    @enemy = enemy
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing, right_pad)
    
    @ucActStates = UCLabelIconsSwitchableList.new(window, rects[0][0], rects[0][1], 
                           Vocab::active_status_label, [0], BESTIARY_CONFIG::ACT_STATES_MAX_ICONS, 
                           BESTIARY_CONFIG::ACT_STATES_ICONS_TIMEOUT)  
    @ucActStates.active = active
    @ucActStates.visible = visible
    
    @ucHpStat = UCLabelIconValue.new(window, rects[1][1], rects[1][0], rects[1][2], 
                                     Vocab::hp_label, BESTIARY_CONFIG::ICON_HP, 0)
    @ucHpStat.cValue.align = 2    
    @ucHpStat.active = active
    @ucHpStat.visible = visible
    @cHpStatGauge = UCBar.new(window, rects[2],
                              Color.hp_gauge_color1, Color.hp_gauge_color2, 
                              Color.gauge_back_color, 0, 0, 1, Color.gauge_border_color)
    @cHpStatGauge.active = active
    @cHpStatGauge.visible = visible
    
    @ucMpStat = UCLabelIconValue.new(window, rects[3][1], rects[3][0], rects[3][2],
                                     Vocab::mp_label, BESTIARY_CONFIG::ICON_MP, 0)
    @ucMpStat.cValue.align = 2
    @ucMpStat.active = active
    @ucMpStat.visible = visible
    @cMpStatGauge = UCBar.new(window, rects[4],
                              Color.mp_gauge_color1, Color.mp_gauge_color2, 
                              Color.gauge_back_color, 0, 0, 1, Color.gauge_border_color)                    
    @cMpStatGauge.active = active
    @cMpStatGauge.visible = visible
    
    @ucAtkStat = UCLabelIconValue.new(window, rects[5][1], rects[5][0], rects[5][2],
                                      Vocab::atk_label, BESTIARY_CONFIG::ICON_ATK, 0)
    @ucAtkStat.cValue.align = 2
    @ucAtkStat.active = active
    @ucAtkStat.visible = visible
    
    @ucDefStat = UCLabelIconValue.new(window, rects[6][1], rects[6][0], rects[6][2],
                                      Vocab::def_label, BESTIARY_CONFIG::ICON_DEF, 0)
    @ucDefStat.cValue.align = 2
    @ucDefStat.active = active
    @ucDefStat.visible = visible
    
    @ucSpiStat = UCLabelIconValue.new(window, rects[7][1], rects[7][0], rects[7][2],
                                      Vocab::spi_label, BESTIARY_CONFIG::ICON_SPI, 0)
    @ucSpiStat.cValue.align = 2
    @ucSpiStat.active = active
    @ucSpiStat.visible = visible
    
    @ucAgiStat = UCLabelIconValue.new(window, rects[8][1], rects[8][0], rects[8][2],
                                      Vocab::agi_label, BESTIARY_CONFIG::ICON_AGI, 0)
    @ucAgiStat.cValue.align = 2
    @ucAgiStat.active = active
    @ucAgiStat.visible = visible
    
    @ucEvaStat = UCLabelIconValue.new(window, rects[9][1], rects[9][0], rects[9][2],
                                      Vocab::eva_label, BESTIARY_CONFIG::ICON_EVA, 0)
    @ucEvaStat.cValue.align = 2
    @ucEvaStat.active = active
    @ucEvaStat.visible = visible
    
    @ucHitStat = UCLabelIconValue.new(window, rects[10][1], rects[10][0], rects[10][2],
                                      Vocab::hit_label, BESTIARY_CONFIG::ICON_HIT, 0)
    @ucHitStat.cValue.align = 2
    @ucHitStat.active = active
    @ucHitStat.visible = visible
    
    @ucCriStat = UCLabelIconValue.new(window, rects[11][1], rects[11][0], rects[11][2],
                                      Vocab::cri_label, BESTIARY_CONFIG::ICON_CRI, 0)
    @ucCriStat.cValue.align = 2
    @ucCriStat.active = active
    @ucCriStat.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucActStates.draw()
    @cHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
    @ucAtkStat.draw()
    @ucDefStat.draw()
    @ucSpiStat.draw()
    @ucAgiStat.draw()
    @ucEvaStat.draw()
    @ucHitStat.draw()
    @ucCriStat.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #     right_pad : right padding to add to the values
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing, right_pad)
    rects = []
    
    # Rects Initialization
    rects[0] = [Rect.new(rect.x,rect.y,90,24),
                Rect.new(rect.x,rect.y,100,24)]
    rects[1] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[2] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[5] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[6] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[7] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[8] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[9] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[10] = [Rect.new(rect.x,rect.y,24,24),
                 Rect.new(rect.x,rect.y,50,24),
                 Rect.new(rect.x,rect.y,rect.width,24)]
    rects[11] = [Rect.new(rect.x,rect.y,24,24),
                 Rect.new(rect.x,rect.y,50,24),
                 Rect.new(rect.x,rect.y,rect.width,24)]
    
    gauge_value_width = rect.width - 24 - 25 - right_pad
    stats_value_width = rect.width - 24 - 50 - right_pad
    gauge_y = 16
        
    # Rects Adjustments
    
    # ucActStates
    rects[0][1].x += rects[0][0].width
    
    # ucHpStat
    rects[1][0].y += spacing
    rects[1][1].x += rects[1][0].width
    rects[1][1].y = rects[1][0].y
    rects[1][2].x = rects[1][1].x + rects[1][1].width
    rects[1][2].y = rects[1][0].y
    rects[1][2].width = gauge_value_width
    
    # cHpStatGauge
    rects[2].y += rects[1][0].y+gauge_y
    rects[2].height = rects[1][0].height-gauge_y
    
    # ucMpStat
    rects[3][0].y += spacing*2
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].x = rects[3][1].x + rects[3][1].width
    rects[3][2].y = rects[3][0].y
    rects[3][2].width = gauge_value_width
    
    # cMpStatGauge
    rects[4].y += rects[3][0].y+gauge_y
    rects[4].height = rects[3][0].height-gauge_y
    
    # ucAtkStat
    rects[5][0].y += spacing*3
    rects[5][1].x += rects[5][0].width
    rects[5][1].y = rects[5][0].y
    rects[5][2].x = rects[5][1].x + rects[5][1].width
    rects[5][2].y = rects[5][0].y
    rects[5][2].width = stats_value_width
    
    # ucDefStat
    rects[6][0].y += spacing*4
    rects[6][1].x += rects[6][0].width
    rects[6][1].y = rects[6][0].y
    rects[6][2].x = rects[6][1].x + rects[6][1].width
    rects[6][2].y = rects[6][0].y
    rects[6][2].width = stats_value_width
    
    # ucSpiStat
    rects[7][0].y += spacing*5
    rects[7][1].x += rects[7][0].width
    rects[7][1].y = rects[7][0].y
    rects[7][2].x = rects[7][1].x + rects[7][1].width
    rects[7][2].y = rects[7][0].y
    rects[7][2].width = stats_value_width
    
    # ucAgiStat
    rects[8][0].y += spacing*6
    rects[8][1].x += rects[8][0].width
    rects[8][1].y = rects[8][0].y
    rects[8][2].x = rects[8][1].x + rects[8][1].width
    rects[8][2].y = rects[8][0].y
    rects[8][2].width = stats_value_width
    
    # ucEvaStat
    rects[9][0].y += spacing*7
    rects[9][1].x += rects[9][0].width
    rects[9][1].y = rects[9][0].y
    rects[9][2].x = rects[9][1].x + rects[9][1].width
    rects[9][2].y = rects[9][0].y
    rects[9][2].width = stats_value_width
    
    # ucHitStat
    rects[10][0].y += spacing*8
    rects[10][1].x += rects[10][0].width
    rects[10][1].y = rects[10][0].y
    rects[10][2].x = rects[10][1].x + rects[10][1].width
    rects[10][2].y = rects[10][0].y
    rects[10][2].width = stats_value_width
    
    # ucCriStat
    rects[11][0].y += spacing*9
    rects[11][1].x += rects[11][0].width
    rects[11][1].y = rects[11][0].y
    rects[11][2].x = rects[11][1].x + rects[11][1].width
    rects[11][2].y = rects[11][0].y
    rects[11][2].width = stats_value_width
    
    return rects
  end
  private :determine_rects
  
end

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

