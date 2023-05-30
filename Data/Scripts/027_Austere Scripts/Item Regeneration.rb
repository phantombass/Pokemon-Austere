class PokeBattle_Battle
  def pbStartBattleCore
    # Set up the battlers on each side
    pbAustereClauses if Level_Scaling.gym_leader?
    $qol_toggle = false
    fe =FIELD_EFFECTS[@field.field_effects]
    @field.field_effects = $game_screen.field_effects
    $field_effect_bg = backdrop
    sendOuts = pbSetUpSides
    olditems = []
    pbParty(0).each_with_index do |pkmn,i|
      item = getID(PBItems,pkmn.item)
      olditems.push(item)
    end
    $olditems = olditems
    # Create all the sprites and play the battle intro animation
    @scene.pbStartBattle(self)
    # Show trainers on both sides sending out Pokémon
    pbStartBattleSendOut(sendOuts)
    # Weather announcement
    pbCommonAnimation(PBWeather.animationName(@field.weather))
    case @field.weather
    when PBWeather::Sun;         pbDisplay(_INTL("The sunlight is\nstrong."))
    when PBWeather::Rain;        pbDisplay(_INTL("It is\nraining."))
    when PBWeather::Sandstorm;   pbDisplay(_INTL("A SANDSTORM\nrages."))
    when PBWeather::Hail;        pbDisplay(_INTL("Hail is\nfalling."))
    when PBWeather::HarshSun;    pbDisplay(_INTL("The sunlight is\nextremely harsh."))
    when PBWeather::HeavyRain;   pbDisplay(_INTL("It is raining\nheavily."))
    when PBWeather::StrongWinds; pbDisplay(_INTL("The wind is strong."))
    when PBWeather::ShadowSky;   pbDisplay(_INTL("The sky is shadowy."))
    when PBWeather::Fog;         pbDisplay(_INTL("The fog is deep..."))
    end
    # Terrain announcement
    pbCommonAnimation(PBBattleTerrains.animationName(@field.terrain))
    case @field.terrain
    when PBBattleTerrains::Electric
      pbDisplay(_INTL("An electric current runs across the battlefield!"))
    when PBBattleTerrains::Grassy
      pbDisplay(_INTL("Grass is covering the battlefield!"))
    when PBBattleTerrains::Misty
      pbDisplay(_INTL("Mist swirls about the battlefield!"))
    when PBBattleTerrains::Psychic
      pbDisplay(_INTL("The battlefield is weird!"))
    end
    msg = fe[:intro_message]
    pbDisplay(_INTL(msg)) if msg != nil
    # Abilities upon entering battle
    pbOnActiveAll
    # Main battle loop
    pbBattleLoop
  end

  def pbEndOfBattle
    oldDecision = @decision
    @decision = 4 if @decision==1 && wildBattle? && @caughtPokemon.length>0
    case oldDecision
    ##### WIN #####
    when 1
      PBDebug.log("")
      PBDebug.log("***Player won***")
      if trainerBattle?
        @scene.pbTrainerBattleSuccess
        case @opponent.length
        when 1
          pbDisplayPaused(_INTL("{1}\nwas defeated!",@opponent[0].fullname))
        when 2
          pbDisplayPaused(_INTL("{1} and {2}\nwere defeated!",@opponent[0].fullname,
             @opponent[1].fullname))
        when 3
          pbDisplayPaused(_INTL("{1}, {2} and {3}\nwere defeated!",@opponent[0].fullname,
             @opponent[1].fullname,@opponent[2].fullname))
        end
        @opponent.each_with_index do |_t,i|
          @scene.pbShowOpponent(i)
          msg = (@endSpeeches[i] && @endSpeeches[i]!="") ? @endSpeeches[i] : "..."
          pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/,pbPlayer.name))
        end
      end
      # Gain money from winning a trainer battle, and from Pay Day
      pbGainMoney if @decision!=4
      # Hide remaining trainer
      @scene.pbShowOpponent(@opponent.length) if trainerBattle? && @caughtPokemon.length>0
    ##### LOSE, DRAW #####
    when 2, 5
      PBDebug.log("")
      PBDebug.log("***Player lost***") if @decision==2
      PBDebug.log("***Player drew with opponent***") if @decision==5
      if @internalBattle
        pbDisplayPaused(_INTL("{1} is out of useable POKéMON!",$Trainer.name))
        if trainerBattle?
          case @opponent.length
          when 1
            pbDisplayPaused(_INTL("You lost against {1}!",@opponent[0].fullname))
          when 2
            pbDisplayPaused(_INTL("You lost against {1} and {2}!",
               @opponent[0].fullname,@opponent[1].fullname))
          when 3
            pbDisplayPaused(_INTL("You lost against {1}, {2} and {3}!",
               @opponent[0].fullname,@opponent[1].fullname,@opponent[2].fullname))
          end
        end
        # Lose money from losing a battle
        pbLoseMoney
        pbDisplayPaused(_INTL("{1} whited out!",$Trainer.name)) if !@canLose
      elsif @decision==2
        if @opponent
          @opponent.each_with_index do |_t,i|
            @scene.pbShowOpponent(i)
            msg = (@endSpeechesWin[i] && @endSpeechesWin[i]!="") ? @endSpeechesWin[i] : "..."
            pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/,pbPlayer.name))
          end
        end
      end
    ##### CAUGHT WILD POKÉMON #####
    when 4
      @scene.pbWildBattleSuccess if !GAIN_EXP_FOR_CAPTURE
    end
    # Register captured Pokémon in the Pokédex, and store them
    pbRecordAndStoreCaughtPokemon
    # Collect Pay Day money in a wild battle that ended in a capture
    pbGainMoney if @decision==4
    # Pass on Pokérus within the party
    if @internalBattle
      infected = []
      $Trainer.party.each_with_index do |pkmn,i|
        infected.push(i) if pkmn.pokerusStage==1
      end
      infected.each do |idxParty|
        strain = $Trainer.party[idxParty].pokerusStrain
        if idxParty>0 && $Trainer.party[idxParty-1].pokerusStage==0
          $Trainer.party[idxParty-1].givePokerus(strain) if rand(3)==0   # 33%
        end
        if idxParty<$Trainer.party.length-1 && $Trainer.party[idxParty+1].pokerusStage==0
          $Trainer.party[idxParty+1].givePokerus(strain) if rand(3)==0   # 33%
        end
      end
    end
    # Clean up battle stuff
    @scene.pbEndBattle(@decision)
    @battlers.each do |b|
      next if !b
      pbCancelChoice(b.index)   # Restore unused items to Bag
      BattleHandlers.triggerAbilityOnSwitchOut(b.ability,b,true) if b.abilityActive?
    end
    pbParty(0).each_with_index do |pkmn,i|
      next if !pkmn
      @peer.pbOnLeavingBattle(self,pkmn,@usedInBattle[0][i],true)   # Reset form
      if @opponent
        pkmn.setItem($olditems[i])
      else
        pkmn.setItem(@initialItems[0][i])
      end
    end
    Level_Scaling.boss_battle = false
    Level_Scaling.gym_leader = false
    $qol_toggle = true
    return @decision
  end
end
