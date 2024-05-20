#===================================
# Level Cap Scripts
#===================================

class Game_System
  attr_accessor :level_cap
  alias initialize_cap initialize
  def initialize
    initialize_cap
    @level_cap          = 0
    write_version
  end
  def level_cap
    return @level_cap
  end
end

class PokemonSystem
  attr_accessor :level_caps
  alias initialize_cap initialize
  def initialize
    initialize_cap
    @level_caps          = 0
  end
  def level_caps;  return @level_caps || 0;    end
end

LEVEL_CAP = [9,15,20,25,30]

def pbLevelCapToggle
  $PokemonSystem.level_caps == 1 ? $PokemonSystem.level_caps = 0 : $PokemonSystem.level_caps = 1
end

module Level_Cap
  def self.update
    $game_system.level_cap += 1
    $game_system.level_cap = LEVEL_CAP.size-1 if $game_system.level_cap >= LEVEL_CAP.size
  end
end

class PokeBattle_Battle
  def pbGainExpOne(idxParty,defeatedBattler,numPartic,expShare,expAll,showMessages=true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
    growthRate = pkmn.growthrate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp>=PBExperience.pbGetMaxExperience(growthRate)
      pkmn.calcStats   # To ensure new EVs still have an effect
      return
    end
    isPartic    = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty)
    level = defeatedBattler.level
    level_cap = $PokemonSystem.level_caps != 1 ? LEVEL_CAP[$game_system.level_cap] : MAXIMUM_LEVEL
    if $PokemonSystem.level_caps != 1
      level_cap_gap = PBExperience.pbGetExpInternal(level_cap,growthRate) - pkmn.exp
    end
    # Main Exp calculation
    exp = 0
    a = level*defeatedBattler.pokemon.baseExp
    if expShare.length>0 && (isPartic || hasExpShare)
      if numPartic==0   # No participants, all Exp goes to Exp Share holders
        exp = a/(SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a/(2*numPartic) if isPartic
        exp += a/(2*expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        exp = (isPartic) ? a : a/2
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      exp = a/(SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      exp = a/2
    end
    return if exp<=0
    # Pokémon gain more Exp from trainer battles
    exp = (exp*1.5).floor if trainerBattle?
    # Scale the gained Exp based on the gainer's level (or not)
    if SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = (2*level+10.0)/(pkmn.level+level+10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
      if pkmn.level >= level_cap
        exp /= 250
      end
      if $PokemonSystem.level_caps != 1
        if exp >= level_cap_gap
          exp = level_cap_gap + 1
        end
      end
    else
      if $PokemonSystem.level_caps != 1
        if a <= level_cap_gap
          exp = a
        else
          exp /= 7
        end
      end
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.trainerID!=pbPlayer.id ||
                 (pkmn.language!=0 && pkmn.language!=pbPlayer.language))
    if isOutsider
      if pkmn.language!=0 && pkmn.language!=pbPlayer.language
        exp = (exp*1.7).floor
      else
        exp = (exp*1.5).floor
      end
    end
    # Modify Exp gain based on pkmn's held item
    i = BattleHandlers.triggerExpGainModifierItem(pkmn.item,pkmn,exp)
    if i<0
      i = BattleHandlers.triggerExpGainModifierItem(@initialItems[0][idxParty],pkmn,exp)
    end
    exp = (exp*1.5).floor if hasConst?(PBItems,:EXPCHARM) && $PokemonBag.pbHasItem?(:EXPCHARM) # EXP Charm Code
    exp = i if i>=0
    # Make sure Exp doesn't exceed the maximum
    expFinal = PBExperience.pbAddExperience(pkmn.exp,exp,growthRate)
    expGained = expFinal-pkmn.exp
    return if expGained<=0
    # "Exp gained" message
    if showMessages
      if isOutsider
        pbDisplayPaused(_INTL("{1} gained a boosted {2} EXP. Points!",pkmn.name,expGained))
      else
        pbDisplayPaused(_INTL("{1} gained\n{2} EXP. Points!",pkmn.name,expGained))
      end
    end
    curLevel = pkmn.level
    newLevel = PBExperience.pbGetLevelFromExperience(expFinal,growthRate)
    if newLevel<curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise RuntimeError.new(
         _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
         pkmn.name,debugInfo))
    end
    # Give Exp
    if pkmn.shadowPokemon?
      pkmn.exp += expGained
      return
    end
    tempExp1 = pkmn.exp
    battler = pbFindBattler(idxParty)
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = PBExperience.pbGetStartExperience(curLevel,growthRate)
      levelMaxExp = PBExperience.pbGetStartExperience(curLevel+1,growthRate)
      tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
      @scene.pbEXPBar(battler,levelMinExp,levelMaxExp,tempExp1,tempExp2)
      tempExp1 = tempExp2
      curLevel += 1
      if curLevel>newLevel
        # Gained all the Exp now, end the animation
        pkmn.calcStats
        battler.pbUpdate(false) if battler
        @scene.pbRefreshOne(battler.index) if battler
        break
      end
      # Levelled up
      pbCommonAnimation("LevelUp",battler) if battler
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
      if battler && battler.pokemon
        battler.pokemon.changeHappiness("levelup")
      end
      pkmn.calcStats
      battler.pbUpdate(false) if battler
      @scene.pbRefreshOne(battler.index) if battler
      pbDisplayPaused(_INTL("{1} grew to\nlevel {2}!",pkmn.name,curLevel))
      @scene.pbLevelUp(pkmn,battler,oldTotalHP,oldAttack,oldDefense,
                                    oldSpAtk,oldSpDef,oldSpeed)
      # Learn all moves learned at this level
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(idxParty,m[1]) if m[0]==curLevel }
    end
  end
  def pbGainEVsOne(idxParty,defeatedBattler)
    if !DISABLE_EVS
      pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
      evYield = defeatedBattler.pokemon.evYield
      # Num of effort points pkmn already has
      evTotal = 0
      PBStats.eachStat { |s| evTotal += pkmn.ev[s] }
      # Modify EV yield based on pkmn's held item
      if !BattleHandlers.triggerEVGainModifierItem(pkmn.item,pkmn,evYield)
        BattleHandlers.triggerEVGainModifierItem(@initialItems[0][idxParty],pkmn,evYield)
      end
      # Double EV gain because of Pokérus
      if pkmn.pokerusStage>=1   # Infected or cured
        evYield.collect! { |a| a*2 }
      end
      # Gain EVs for each stat in turn
      PBStats.eachStat do |s|
        evGain = evYield[s]
        # Can't exceed overall limit
        if evTotal+evGain>PokeBattle_Pokemon::EV_LIMIT
          evGain = PokeBattle_Pokemon::EV_LIMIT-evTotal
        end
        # Can't exceed individual stat limit
        if pkmn.ev[s]+evGain>PokeBattle_Pokemon::EV_STAT_LIMIT
          evGain = PokeBattle_Pokemon::EV_STAT_LIMIT-pkmn.ev[s]
        end
        # Add EV gain
        pkmn.ev[s] += evGain
        evTotal += evGain
      end
    end
  end
end

class PokemonPauseMenu_Scene
  def pbStartScene
    levelCap = LEVEL_CAP[$game_system.level_cap]
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].visible = false
    @sprites["cmdwindow"].viewport = @viewport
    @sprites["infowindow"] = Window_UnformattedTextPokemon.newWithSize("",0,0,32,32,@viewport)
    @sprites["infowindow"].visible = false
    @sprites["helpwindow"] = Window_UnformattedTextPokemon.newWithSize("",0,0,32,32,@viewport)
    @sprites["helpwindow"].visible = false
    if $PokemonSystem.level_caps != 1
      @sprites["levelcapwindow"] =Window_UnformattedTextPokemon.newWithSize("Level Cap: #{levelCap}",0,0,146,88,@viewport)
      @sprites["levelcapwindow"].visible = true
    end
    @infostate = false
    @helpstate = false
    pbSEPlay("GUI menu open")
  end
  def pbShowLevelCap
    @sprites["levelcapwindow"].visible = true
  end

  def pbHideLevelCap
    @sprites["levelcapwindow"].visible = false if $game_switches[LEVEL_CAP_SWITCH] == true
  end
end

PluginManager.register({
		:name    => "Level Cap Main",
		:version => "1.0",
		:link    => "None",
		:credits => ["Phantombass"]
})
