MISSION_DATA = {

  1 => {
    :ID => 1,
    :Name => "ANCIENT CAVE Sounds",
    :Info => "Travel to the ANCIENT CAVE to see what is causing the odd sounds.",
    :Contact => "Dwayne",
    :map_id => nil,
    :Available_Switch => 66,
    :Chosen_Switch => 61,
    :Completed => 64,
    :Prerequisite => :M3
  },

  2 => {
    :ID => 2,
    :Name => "DARKWOOD FOREST Missing Kid",
    :Info => "Help find the lost kid in the DARKWOOD FOREST",
    :Contact => "Danny",
    :map_id => nil,
    :Available_Switch => 64,
    :Chosen_Switch => 62,
    :Completed => 65,
    :Prerequisite => :M1
  },

  3 => {
    :ID => 3,
    :Name => "TOTEM ISLAND Mystery",
    :Info => "Make your way to TOTEM ISLAND to help uncover the mysterious happenings there.",
    :Contact => "Shawn",
    :map_id => nil,
    :Available_Switch => 60,
    :Chosen_Switch => 63,
    :Completed => 66,
    :Prerequisite => nil
  }

}

# Folder that contains the files
ENC_FOLDER = "Graphics/Pictures/Encounters/"

# This is the name of a graphic in your Graphics/Pictures folder that changes the look of the UI
# If the graphic does not exist, you will get an error
WINDOWSKIN = "bg.png"

module Mission
  Obtained = 902

  def self.obtained?
    return $game_switches[Mission::Obtained]
  end

  def self.setup
    $game_switches[Mission::Obtained] = true
  end
end

def pbMissionStart
  Mission.setup
  pbMessage(_INTL("\\me[Key item get]\PN added MISSION INFO to the QOL Access!\\wtnp[75]"))
end

def pbMissionBoard
  Mission_Database.setup
  Mission_Database.display_available_missions
end

def pbChooseMission
  Mission_Database.setup
  id = Mission_Database.available_id
  list = []

  pbMessage(_INTL("Which will you choose?\\ch[34,#{id.length+2},#{id[0]}: North,#{id[1]}: West,#{id[2]}: South,Cancel]"))
  var = $game_variables[34]
  case var
  when 0
    Mission_Database.activate(id[0])
  when 1
    Mission_Database.activate(id[1])
  when 2
    Mission_Database.activate(id[2])
  else
    pbPlayCloseMenuSE
  end
end

def pbCompleteMission(mission_id)
  $game_switches[913] = false
  Mission_Database.complete(mission_id)
end


class Mission_Database
  attr_accessor :available
  attr_accessor :active
  attr_accessor :unavailable
  attr_accessor :completed

  def self.setup
    @active = []
    @available = []
    @unavailable = []
    @completed = []
  end

  def self.active_missions
    for key in MISSION_DATA.keys
      mission = MISSION_DATA[key]
      m = key.to_sym
      @active.push(m) if $game_switches[mission[:Chosen_Switch]] == true && $game_switches[mission[:Completed]] == false && !@completed.include?(mission[:Prerequisite])
    end
    return @active
  end

  def self.available_missions
    chosen = false
    for key in MISSION_DATA.keys
      mission = MISSION_DATA[key]
      m = key.to_sym
      chosen = true if $game_switches[mission[:Chosen_Switch]] == true
      @available.push(m) if $game_switches[mission[:Available_Switch]] == true
    end
    @available.uniq!
    return @available
  end

  def self.deactivate(mission_id)
    @unavailable.push(mission_id)
    @unavailable.uniq!
  end

  def self.activate(mission_id)
    for key in MISSION_DATA.keys
      mission = MISSION_DATA[key]
      m = key.to_sym
      @active.push(m)
      $game_switches[mission[:Chosen_Switch]] = true
      pbMessage(_INTL("\\me[Key item get]You have chosen #{mission[:Name]}!\\wtnp[75]"))
      $game_switches[913] = true
    end
  end

  def self.complete(mission_id)
    @active.clear
    for key in MISSION_DATA.keys
      mission = MISSION_DATA[key]
      m = key.to_sym
      $game_switches[mission[:Completed]] = true
      @completed.push(m)
    end
  end

  def self.display_available_missions
    MissionUI.new.pbStartMenu
  end

  def self.display_active_missions
    MissionUI.new.pbStartMenu2
  end

  def self.available_list
    m = []
    a = Mission_Database.available_missions
    for i in 1..a.length
      mission = MISSION_DATA[i]
      m.push(mis[:Name])
    end
    m.uniq!
    m.compact
    return m
  end

  def self.available_id
    m = []
    a = Mission_Database.available_missions
    for i in 1..a.length
      mission = MISSION_DATA[i]
      m.push(mission[:ID])
    end
    m.uniq!
    m.compact
    return m
  end
end

class MissionUI
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @index = 0
    @active = []
    @available = []
    @mapid = $game_map.map_id
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def get_available_missions
    @available = Mission_Database.available_missions
    if @available != [] && @available != nil
      @num = @available.compact.length
      @type = (0...@available.length).reject {|i| @available[i].nil? }
      @first = @available.index(@available.find { |i| !i.nil? } || false)
      @aray = @available[@type[@index]]
      @id = @aray[:ID]
      @name = @aray[:Name]
      @info = @aray[:Info]
    end
  end

  def get_active_missions
    @active = Mission_Database.active_missions
    if @active != [] && @active != nil
      @num_active = @active.compact.length
      @type_active = (0...@active.length).reject {|i| @active[i].nil? }
      @first_active = @active.index(@active.find { |i| !i.nil? } || false)
      @bray = @active[@type_active[@index]]
      @active_name = @bray[:Name]
      @active_info = @bray[:Info]
    end
  end

  def pbStartMenu
    get_available_missions
    if !File.file?(ENC_FOLDER + WINDOWSKIN)
      raise _INTL("You are missing the graphic for this UI. Make sure the image is in your Graphics/Pictures folder and that it is named appropriately.")
    end
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(ENC_FOLDER + WINDOWSKIN)
    @sprites["background"].x = 0
    @sprites["background"].y = 0
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].width = 320
    @sprites["locwindow"].height = 288
    @sprites["locwindow"].x = (Graphics.width - @sprites["locwindow"].width)/2
    @sprites["locwindow"].y = (Graphics.height - @sprites["locwindow"].height)/2
    #@sprites["locwindow"].windowskin = nil

    if @available == [] || !@available
      loctext = sprintf("<ac>No missions available!</ac>")
      loctext += _INTL("-----------------------------")
      @sprites["locwindow"].setText(loctext)
      waitForExit
    else
      loctext = _INTL("<ac>{1}</ac>", @name)
      loctext += _INTL("<ac>Mission {1} of {2}</ac>", @id,@num)
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", @info)
      @sprites["locwindow"].setText(loctext)
      @sprites["rightarrow"] = AnimatedSprite.new(ENC_FOLDER + "next_right",2,10,22,6,@viewport)
      @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
      @sprites["rightarrow"].y = 226
      @sprites["rightarrow"].visible = false
      @sprites["rightarrow"].play
      @sprites["leftarrow"] = AnimatedSprite.new(ENC_FOLDER + "next_left",2,10,22,6,@viewport)
      @sprites["leftarrow"].x = 0
      @sprites["leftarrow"].y = 226
      @sprites["leftarrow"].visible = false
      @sprites["leftarrow"].play
      main1
    end
  end

  def pbStartMenu2
    get_active_missions
    if !File.file?(ENC_FOLDER + WINDOWSKIN)
      raise _INTL("You are missing the graphic for this UI. Make sure the image is in your Graphics/Pictures folder and that it is named appropriately.")
    end
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(ENC_FOLDER + WINDOWSKIN)
    @sprites["background"].x = 0
    @sprites["background"].y = 0
    @sprites["locwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["locwindow"].viewport = @viewport
    @sprites["locwindow"].width = 320
    @sprites["locwindow"].height = 288
    @sprites["locwindow"].x = (Graphics.width - @sprites["locwindow"].width)/2
    @sprites["locwindow"].y = (Graphics.height - @sprites["locwindow"].height)/2
    #@sprites["locwindow"].windowskin = nil

    if @active == [] || !@active
      loctext = sprintf("<ac>No missions active!</ac>")
      loctext += _INTL("-----------------------------")
      @sprites["locwindow"].setText(loctext)
      waitForExit
    else
      loctext = _INTL("<ac>{1}</ac>", @active_name)
      #loctext += _INTL("<ac>{1}:</ac>", $game_map.name)
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", @active_info)
      @sprites["locwindow"].setText(loctext)
      @sprites["rightarrow"] = AnimatedSprite.new(ENC_FOLDER + "next_right",2,10,22,6,@viewport)
      @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
      @sprites["rightarrow"].y = 226
      @sprites["rightarrow"].visible = false
      @sprites["rightarrow"].play
      @sprites["leftarrow"] = AnimatedSprite.new(ENC_FOLDER + "next_left",2,10,22,6,@viewport)
      @sprites["leftarrow"].x = 0
      @sprites["leftarrow"].y = 226
      @sprites["leftarrow"].visible = false
      @sprites["leftarrow"].play
      waitForExit
    end
  end

  def main1
    loop do
      Graphics.update
      Input.update
      pbUpdate
        if @first == @type[@index] && @num >1 # If first page and there are more pages
          @sprites["leftarrow"].visible=false
          @sprites["rightarrow"].visible=true
        elsif @index == @type.length-1 && @num >1 # If last page and there is more than one page
          @sprites["leftarrow"].visible=true
          @sprites["rightarrow"].visible=false
        end
        if Input.trigger?(Input::RIGHT) && @num >1 && @index< @num-1
          pbPlayCursorSE
          @index += 1
          pbUpdate # Dispose sprites
          main2
          @sprites["leftarrow"].visible=true
          @sprites["rightarrow"].visible=true
        elsif Input.trigger?(Input::LEFT) && @num >1 && @index !=0
          pbPlayCursorSE
          @index -= 1
          pbUpdate # Dispose sprites
          main2
          @sprites["leftarrow"].visible=true
          @sprites["rightarrow"].visible=true
        elsif Input.trigger?(Input::C) || Input.trigger?(Input::B)
          pbPlayCloseMenuSE
          break
        end
      end
    dispose
  end

  def main2
    get_available_missions
    if !@available
      loctext = sprintf("<ac>No missions active!</ac>")
      loctext += _INTL("-----------------------------")
      @sprites["locwindow"].setText(loctext)
      waitForExit
    else
      loctext = _INTL("<ac>{1}</ac>", @name)
      loctext += _INTL("<ac>Mission {1} of {2}</ac>", @id,@num)
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", @info)
    end
    @sprites["locwindow"].setText(loctext)
  end

  def main3
    loop do
      Graphics.update
      Input.update
      pbUpdate
        if @first_active == @type_active[@index] && @num_active >1 # If first page and there are more pages
          @sprites["leftarrow"].visible=false
          @sprites["rightarrow"].visible=true
        elsif @index == @type_active.length-1 && @num_active >1 # If last page and there is more than one page
          @sprites["leftarrow"].visible=true
          @sprites["rightarrow"].visible=false
        end
        if Input.trigger?(Input::RIGHT) && @num_active >1 && @index< @num_active-1
          pbPlayCursorSE
          @index += 1
          pbShift # Dispose sprites
          main4
          @sprites["leftarrow"].visible=true
          @sprites["rightarrow"].visible=true
        elsif Input.trigger?(Input::LEFT) && @num_active >1 && @index !=0
          pbPlayCursorSE
          @index -= 1
          pbShift # Dispose sprites
          main4
          @sprites["leftarrow"].visible=true
          @sprites["rightarrow"].visible=true
        elsif Input.trigger?(Input::C) || Input.trigger?(Input::B)
          pbPlayCloseMenuSE
          break
        end
      end
    dispose
  end

  def main4
    get_active_missions
    if !@active
      loctext = sprintf("<ac>No missions active!</ac>")
      loctext += _INTL("-----------------------------")
      @sprites["locwindow"].setText(loctext)
      waitForExit
    else
      loctext = _INTL("<ac>{1}</ac>", @active_name)
      #loctext += _INTL("<ac>{1}:</ac>", $game_map.name)
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", @active_info)
    end
    @sprites["locwindow"].setText(loctext)
  end

  def waitForExit
    loop do
      Graphics.update
      Input.update
      if Input.trigger?(Input::C) || Input.trigger?(Input::B)
        pbPlayCloseMenuSE
		    Input.update
        break
      end
    end
    dispose
  end

  def dispose
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end
