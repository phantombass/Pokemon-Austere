def pbPCBoxLink
  gym_maps = [112]
  pbPlayDecisionSE
  pbMessage("Which would you like to do?\\ch[34,4,Access PC,Heal: #{pbGet(36)},Cancel]")
  if $game_variables[34] == 0
    if !gym_maps.include?($game_map.map_id)
      pbFadeOutIn {
        scene = PokemonStorageScene.new
        screen = PokemonStorageScreen.new(scene,$PokemonStorage)
        screen.pbStartScreen(0)
      }
    else
      pbMessage(_INTL("You can't access the PC in here."))
    end
  elsif $game_variables[34] == 1
    if $game_variables[36] > 0
      pbHealAll
      pbMessage(_INTL("Your party was healed!"))
    else
      pbMessage(_INTL("You're out of free heals!"))
      pbMessage(_INTL("Recharge at the PMC!"))
    end
   end
 end
