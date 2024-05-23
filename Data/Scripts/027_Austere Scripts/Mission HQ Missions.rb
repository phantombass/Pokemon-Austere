MISSION_DATA = {
  1 => {
    :ID => 1,
    :Location => "TOTEM ISLAND",
    :Name => "Mysterious Happenings",
    :Info => "Make your way to TOTEM ISLAND to help uncover the mysterious happenings there.",
    :Contact => "CASSANDRA",
    :map_id => nil,
    :Available_Switch => 60,
    :Chosen_Switch => 63,
    :Completed => 66,
    :Prerequisite => nil
  },

  2 => {
    :ID => 2,
    :Location => "ANCIENT CAVE",
    :Name => "Weird Sounds",
    :Info => "Travel to the ANCIENT CAVE to see what is causing the odd sounds.",
    :Contact => "REGGIE",
    :map_id => nil,
    :Available_Switch => 66,
    :Chosen_Switch => 61,
    :Completed => 64,
    :Prerequisite => 1
  },

  3 => {
    :ID => 3,
    :Location => "DARKWOOD FOREST",
    :Name => "Missing Kid",
    :Info => "Help find the lost kid in the DARKWOOD FOREST",
    :Contact => "DANNY",
    :map_id => nil,
    :Available_Switch => 64,
    :Chosen_Switch => 62,
    :Completed => 65,
    :Prerequisite => 2
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
  for i in id
    loc = MISSION_DATA[i][:Location]
    list.push(loc)
  end
  pbMessage(_INTL("Which location will you choose?\\ch[34,#{list.length+2},#{list},Cancel]"))
  var = $game_variables[34]
  if var == (list.length+1 || list.length+2  || -1)
    pbPlayCloseMenuSE
  else
    Mission_Database.activate(id[var])
  end
end

def pbCompleteMission(mission_id)
  Mission_Database.complete(mission_id)
end

def pbMakeMissionAvailable(mission_id)
  Mission_Database.make_available(mission_id)
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
      @active.push(key) if $game_switches[mission[:Chosen_Switch]] == true && $game_switches[mission[:Completed]] == false && !@completed.include?(mission[:Prerequisite])
    end
    return @active
  end

  def self.available_missions
    chosen = false
    for key in MISSION_DATA.keys
      mission = MISSION_DATA[key]
      chosen = $game_switches[mission[:Chosen_Switch]]
      @available.push(key) if $game_switches[mission[:Available_Switch]] == true && chosen == false
    end
    @available.uniq!
    return @available
  end

  def self.deactivate(mission_id)
    @unavailable.push(mission_id)
    @unavailable.uniq!
  end

  def self.activate(mission_id)
    $game_switches[913] = true
    mission = MISSION_DATA[mission_id]
    @active.push(mission_id)
    $game_switches[mission[:Chosen_Switch]] = true
    pbMessage(_INTL("\\me[Key item get]You have chosen #{mission[:Location]} : #{mission[:Name]}!\\wtnp[75]"))
    @available = []
  end

  def self.complete(mission_id)
    mission = MISSION_DATA[mission_id]
    $game_switches[mission[:Completed]] = true
    @completed.push(mission_id)
    @active = []
  end

  def self.make_available(mission_id)
    mission = MISSION_DATA[mission_id]
    prereq = MISSION_DATA[mission[:Prerequisite]]
    if $game_switches[prereq[:Completed]] || mission_id == 1
      $game_switches[913] = false
      $game_switches[mission[:Available_Switch]] = true
      self.refresh_available
    end
  end

  def self.refresh_available
    chosen = false
    for key in MISSION_DATA.keys
      mission = MISSION_DATA[key]
      chosen = $game_switches[mission[:Chosen_Switch]]
      @available.push(key) if $game_switches[mission[:Available_Switch]] && chosen == false
    end
    @available.uniq!
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
    for i in a
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
    for i in a
      mission = MISSION_DATA[i]
      m.push(mission[:ID])
    end
    m.uniq!
    m.compact
    return m
  end
end

class MissionUI
  attr_accessor :active
  attr_accessor :available

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
    mission_info = {}
    @available = Mission_Database.available_missions
    if @available != nil || !@available != []
      for i in @available
        mission = MISSION_DATA[i]
        @id = mission[:ID]
        @location = mission[:Location]
        @name = mission[:Name]
        @info = mission[:Info]
        @num = @available.compact.length
      end
    end
    mission_info[:id] = @id
    mission_info[:location] = @location
    mission_info[:name] = @name
    mission_info[:info] = @info
    mission_info[:num] = @num
    return mission_info
  end

  def get_active_missions
    mission_info = {}
    @active = Mission_Database.active_missions
    if @active != [] && @active != nil
      for i in @active
        mission = MISSION_DATA[i]
        @id = mission[:ID]
        @location = mission[:Location]
        @name = mission[:Name]
        @info = mission[:Info]
        @num = @available.compact.length
      end
    end
    mission_info[:id] = @id
    mission_info[:location] = @location
    mission_info[:name] = @name
    mission_info[:info] = @info
    mission_info[:num] = @num
    return mission_info
  end

  def pbStartMenu
    m = get_available_missions
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

    if m[:id].nil?
      loctext = sprintf("<ac>No missions available!</ac>")
      loctext += _INTL("-----------------------------")
      @sprites["locwindow"].setText(loctext)
      waitForExit
    else
      loctext = _INTL("<ac>{1}</ac>", m[:name])
      loctext += _INTL("<ac>Mission {1}</ac>", m[:id])
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", m[:info])
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
      main2
    end
  end

  def pbStartMenu2
    m = get_active_missions
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

    if m[:id].nil?
      loctext = sprintf("<ac>No missions active!</ac>")
      loctext += _INTL("-----------------------------")
      @sprites["locwindow"].setText(loctext)
      waitForExit
    else
      loctext = _INTL("<ac>{1}</ac>", m[:name])
      loctext += _INTL("<ac>Mission {1}</ac>", m[:id])
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", m[:info])
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
      main4
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
    m = get_available_missions
    if m[:id].nil?
      loctext = sprintf("<ac>No missions available!</ac>")
      loctext += _INTL("-----------------------------")
    else
      loctext = _INTL("<ac>{1} : {2}</ac>", m[:location],m[:name])
      #loctext += _INTL("<ac>Mission {1}</ac>", m[:id])
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", m[:info])
    end
    @sprites["locwindow"].setText(loctext)
    waitForExit
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
    m = get_active_missions
    if m[:id].nil?
      loctext = sprintf("<ac>No missions active!</ac>")
      loctext += _INTL("-----------------------------")
    else
      loctext = _INTL("<ac>{1} : {2}</ac>", m[:location],m[:name])
      #loctext += _INTL("<ac>Mission {1}</ac>", m[:id])
      loctext += _INTL("-----------------------------")
      loctext += _INTL("<ac>{1}</ac>", m[:info])
      #loctext += _INTL("<ac>{1}:</ac>", $game_map.name)
      loctext += _INTL("-----------------------------")
    end
    @sprites["locwindow"].setText(loctext)
    waitForExit
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
