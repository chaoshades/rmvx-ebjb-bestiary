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
