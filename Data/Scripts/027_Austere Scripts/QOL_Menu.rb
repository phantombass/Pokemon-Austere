module Graphics
  class << Graphics
    alias time_changer_update update
  end

  def self.update
    time_changer_update
    if Input.trigger?(Input::V) && $game_temp.in_menu == false && $game_temp.message_window_showing == false && $qol_toggle
      pbQOLMenu
    end
    if Input.trigger?(Input::D) && $game_temp.in_menu == false && $game_temp.message_window_showing == false && $qol_toggle
      pbQuickSave
    end
  end
end

module Input
  class << Input
    alias time_changer_button_to_key buttonToKey
  end

  V = 52
  D = 53

  def self.buttonToKey(btn)
    return [0x56] if btn == Input::V
    return [0x44] if btn == Input::D
    time_changer_button_to_key(btn)
  end
end

def pbQuickSave
  save = pbConfirmMessage(_INTL("Would you like to save the game?"))
  if save
    pbSave
    pbMessage(_INTL("{1} saved the game!\\me[GUI save game]",$Trainer.name))
  else
    pbPlayCloseMenuSE
  end
end

def pbQOLMenu
  $qol_toggle = false
  commands = []
  commands.push("Infinite Repel")
  commands.push("Time Changer")
  commands.push("PC Box Link")
  commands.push("Town Map")
  commands.push("Mission Info") if Mission.obtained?
  commands.push("HM Catalogue") if HMCatalogue.obtained?
  commands.push("Cancel")
  cmd = commands.length
  var = 34
  choices = [var,cmd]
  for i in commands
    choices.push(i)
  end
  pbMessage(_INTL("Choose a function.\\ch[#{choices[0]},#{choices[1]},#{choices[2]},#{choices[3]},#{choices[4]},#{choices[5]},#{choices[6] if choices[6] != nil},#{choices[7] if choices[7] != nil},#{choices[8]}]"))
  case $game_variables[var]
  when 0
    pbInfiniteRepel
    $qol_toggle = true
  when 1
    pbTimeChanger
    $qol_toggle = true
  when 2
    pbPCBoxLink
    $qol_toggle = true
  when 3
    pbShowMap
    $qol_toggle = true
  when 4
    if choices.length > 7
      Mission_Database.display_active_missions
      $qol_toggle = true
    else
      pbPlayCloseMenuSE
      $qol_toggle = true
    end
  when 5
    if choices.length > 7
      pbHMCatalogue
      $qol_toggle = true
    else
      pbPlayCloseMenuSE
      $qol_toggle = true
    end
  else
    pbPlayCloseMenuSE
    $qol_toggle = true
  end
end
