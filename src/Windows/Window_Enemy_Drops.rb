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
