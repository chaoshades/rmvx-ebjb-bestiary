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
