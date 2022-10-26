begin
  module PBFieldEffects
    None        = 0   # None must be 0 (preset RMXP weather)
    EchoChamber        = 1   # Rain must be 1 (preset RMXP weather)
    Desert       = 2   # Storm must be 2 (preset RMXP weather)
    Lava        = 3   # Snow must be 3 (preset RMXP weather)
    ToxicFumes    = 4
    Wildfire   = 5
    Swamp   = 6
    City = 7
    Ruins         = 8
    Grassy = 9
    JetStream = 10

    def PBFieldEffects.maxValue; return 11; end
    def self.getName(id)
      id = getID(PBFieldEffects,id)
      names = [
         _INTL("None"),
         _INTL("Echo Chamber"),
         _INTL("Desert"),
         _INTL("Lava"),
         _INTL("Toxic Fumes"),
         _INTL("Wildfire"),
         _INTL("Swamp"),
         _INTL("City"),
         _INTL("Ruins"),
         _INTL("Garden"),
         _INTL("Jet Stream")
      ]
      return names[id]
    end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
  end
end

begin
  module PBFieldWeather
    None        = 0   # None must be 0 (preset RMXP weather)
    Rain        = 1   # Rain must be 1 (preset RMXP weather)
    Storm       = 2   # Storm must be 2 (preset RMXP weather)
    Snow        = 3   # Snow must be 3 (preset RMXP weather)
    Blizzard    = 4
    Sandstorm   = 5
    HeavyRain   = 6
    Sun = Sunny = 7
    Fog         = 8
    AcidRain    = 9

    def PBFieldWeather.maxValue; return 10; end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
  end
end

begin
  module PBWeather
    None        = 0
    Sun         = 1
    Rain        = 2
    Sandstorm   = 3
    Hail        = 4
    HarshSun    = 5
    HeavyRain   = 6
    StrongWinds = 7
    ShadowSky   = 8
    Fog         = 9
    AcidRain    = 10

    def self.animationName(weather)
      case weather
      when Sun;         return "Sun"
      when Rain;        return "Rain"
      when Sandstorm;   return "Sandstorm"
      when Hail;        return "Hail"
      when HarshSun;    return "HarshSun"
      when HeavyRain;   return "HeavyRain"
      when StrongWinds; return "StrongWinds"
      when ShadowSky;   return "ShadowSky"
      when Fog;         return "Fog"
      when AcidRain;    return "Rain"
      end
      return nil
    end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
  end
end

begin
  module PBEnvironment
    None        = 0
    Grass       = 1
    TallGrass   = 2
    MovingWater = 3
    StillWater  = 4
    Puddle      = 5
    Underwater  = 6
    Cave        = 7
    Rock        = 8
    Sand        = 9
    Forest      = 10
    ForestGrass = 11
    Snow        = 12
    Ice         = 13
    Volcano     = 14
    Graveyard   = 15
    Sky         = 16
    Space       = 17
    UltraSpace  = 18
    EchoChamber = 19
    Desert      = 20
    Lava        = 21
    ToxicFumes  = 22
    Wildfire    = 23
    Swamp       = 24
    City        = 25
    Ruins       = 26
    Grassy      = 27
    JetStream   = 28


    def self.maxValue; return 29; end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
  end
end

class Game_Screen
  attr_reader   :field_effects
  alias initialize_field initialize
  def initialize
    initialize_field
    @field_effects = PBFieldEffects::None
  end
  def field_effect(type)
    @field_effects = type
  end
end

class PokeBattle_ActiveField
  attr_accessor :defaultField
  attr_accessor :field_effects
  alias initialize_field initialize
  def initialize
    initialize_field
    @effects[PBEffects::EchoChamber] = 0
    default_field_effects = PBFieldEffects::None
    field_effects = PBFieldEffects::None
  end
end

module PBEffects
  EchoChamber = 113
  Singed = 114
end

class PokemonTemp
  def recordBattleRule(rule,var=nil)
    rules = self.battleRules
    case rule.to_s.downcase
    when "single", "1v1", "1v2", "2v1", "1v3", "3v1",
         "double", "2v2", "2v3", "3v2", "triple", "3v3"
      rules["size"] = rule.to_s.downcase
    when "canlose";                rules["canLose"]        = true
    when "cannotlose";             rules["canLose"]        = false
    when "canrun";                 rules["canRun"]         = true
    when "cannotrun";              rules["canRun"]         = false
    when "roamerflees";            rules["roamerFlees"]    = true
    when "noexp";                  rules["expGain"]        = false
    when "nomoney";                rules["moneyGain"]      = false
    when "switchstyle";            rules["switchStyle"]    = true
    when "setstyle";               rules["switchStyle"]    = false
    when "anims";                  rules["battleAnims"]    = true
    when "noanims";                rules["battleAnims"]    = false
    when "terrain";                rules["defaultTerrain"] = getID(PBBattleTerrains,var)
    when "weather";                rules["defaultWeather"] = getID(PBWeather,var)
    when "environment", "environ"; rules["environment"]    = getID(PBEnvironment,var)
    when "field";                  rules["defaultField"]   = getID(PBFieldEffects,var)
    when "backdrop", "battleback"; rules["backdrop"]       = var
    when "base";                   rules["base"]           = var
    when "outcome", "outcomevar";  rules["outcomeVar"]     = var
    when "nopartner";              rules["noPartner"]      = true
    else
      raise _INTL("Battle rule \"{1}\" does not exist.",rule)
    end
    case rules["defaultField"]
    when PBFieldEffects::None
      rules["backdrop"] = "general"
      $game_screen.field_effect(PBFieldEffects::None)
    when PBFieldEffects::EchoChamber
      rules["environment"] = PBEnvironment::EchoChamber
      rules["backdrop"] = "EchoChamber"
      $game_screen.field_effect(PBFieldEffects::EchoChamber)
    when PBFieldEffects::Desert
      rules["environment"] = PBEnvironment::Desert
      rules["backdrop"] = "Desert"
      $game_screen.field_effect(PBFieldEffects::Desert)
    when PBFieldEffects::Lava
      rules["environment"] = PBEnvironment::Lava
      rules["backdrop"] = "Lava"
      $game_screen.field_effect(PBFieldEffects::Lava)
    when PBFieldEffects::ToxicFumes
      rules["environment"] = PBEnvironment::ToxicFumes
      rules["backdrop"] = "ToxicFumes"
      $game_screen.field_effect(PBFieldEffects::ToxicFumes)
    when PBFieldEffects::Wildfire
      rules["environment"] = PBEnvironment::Wildfire
      rules["backdrop"] = "Wildfire"
      $game_screen.field_effect(PBFieldEffects::Wildfire)
    when PBFieldEffects::Swamp
      rules["environment"] = PBEnvironment::Swamp
      rules["backdrop"] = "Swamp"
      $game_screen.field_effect(PBFieldEffects::Swamp)
    when PBFieldEffects::City
      rules["environment"] = PBEnvironment::City
      rules["backdrop"] = "City"
      $game_screen.field_effect(PBFieldEffects::City)
    when PBFieldEffects::Ruins
      rules["environment"] = PBEnvironment::Ruins
      rules["backdrop"] = "Ruins"
      $game_screen.field_effect(PBFieldEffects::Ruins)
    when PBFieldEffects::Grassy
      rules["environment"] = PBEnvironment::Grassy
      rules["backdrop"] = "Grassy"
      $game_screen.field_effect(PBFieldEffects::Grassy)
    when PBFieldEffects::JetStream
      rules["environment"] = PBEnvironment::JetStream
      rules["backdrop"] = "JetStream"
      $game_screen.field_effect(PBFieldEffects::JetStream)
    end
    $field_effect_bg = rules["backdrop"]
  end
end

def setBattleRule(*args)
  r = nil
  for arg in args
    if r
      $PokemonTemp.recordBattleRule(r,arg)
      r = nil
    else
      case arg.downcase
      when "terrain", "weather", "environment", "environ", "backdrop",
           "battleback", "base", "outcome", "outcomevar", "field"
        r = arg
        next
      end
      $PokemonTemp.recordBattleRule(arg)
    end
  end
  raise _INTL("Argument {1} expected a variable after it but didn't have one.",r) if r
end

def pbPrepareBattle(battle)
  battleRules = $PokemonTemp.battleRules
  # The size of the battle, i.e. how many Pokémon on each side (default: "single")
  battle.setBattleMode(battleRules["size"]) if !battleRules["size"].nil?
  # Whether the game won't black out even if the player loses (default: false)
  battle.canLose = battleRules["canLose"] if !battleRules["canLose"].nil?
  # Whether the player can choose to run from the battle (default: true)
  battle.canRun = battleRules["canRun"] if !battleRules["canRun"].nil?
  # Whether wild Pokémon always try to run from battle (default: nil)
  battle.rules["alwaysflee"] = battleRules["roamerFlees"]
  # Whether Pokémon gain Exp/EVs from defeating/catching a Pokémon (default: true)
  battle.expGain = battleRules["expGain"] if !battleRules["expGain"].nil?
  # Whether the player gains/loses money at the end of the battle (default: true)
  battle.moneyGain = battleRules["moneyGain"] if !battleRules["moneyGain"].nil?
  # Whether the player is able to switch when an opponent's Pokémon faints
  battle.switchStyle = ($PokemonSystem.battlestyle==0)
  battle.switchStyle = battleRules["switchStyle"] if !battleRules["switchStyle"].nil?
  # Whether battle animations are shown
  battle.showAnims = ($PokemonSystem.battlescene==0)
  battle.showAnims = battleRules["battleAnims"] if !battleRules["battleAnims"].nil?
  # Terrain
  if battleRules["defaultTerrain"].nil?
    if WEATHER_SETS_TERRAIN
      case $game_screen.weather_type
      when PBFieldWeather::Storm
        battle.defaultTerrain = PBBattleTerrains::Electric
      when PBFieldWeather::Fog
        battle.defaultTerrain = PBBattleTerrains::Misty
      end
    else
      battle.defaultTerrain = battleRules["defaultTerrain"]
    end
  end
  # Weather
  if battleRules["defaultWeather"].nil?
    case $game_screen.weather_type
    when PBFieldWeather::Rain, PBFieldWeather::HeavyRain, PBFieldWeather::Storm
      battle.defaultWeather = PBWeather::Rain
    when PBFieldWeather::Snow, PBFieldWeather::Blizzard
      battle.defaultWeather = PBWeather::Hail
    when PBFieldWeather::Sandstorm
      battle.defaultWeather = PBWeather::Sandstorm
    when PBFieldWeather::Sun
      battle.defaultWeather = PBWeather::Sun
    when PBFieldWeather::Fog
      battle.defaultWeather = PBWeather::Fog if FOG_IN_BATTLES
    end
  else
    battle.defaultWeather = battleRules["defaultWeather"]
  end
  if battleRules["defaultField"].nil?
    case @battle.field.field_effects
    when PBFieldEffects::EchoChamber
      battle.defaultField = PBFieldEffects::EchoChamber
    when PBFieldEffects::Desert
      battle.defaultField = PBFieldEffects::Desert
    when PBFieldEffects::Lava
      battle.defaultField = PBFieldEffects::Lava
    when PBFieldEffects::ToxicFumes
      battle.defaultField = PBFieldEffects::ToxicFumes
    when PBFieldEffects::Wildfire
      battle.defaultField = PBFieldEffects::Wildfire
    when PBFieldEffects::Swamp
      battle.defaultField = PBFieldEffects::Swamp
    when PBFieldEffects::City
      battle.defaultField = PBFieldEffects::City
    when PBFieldEffects::Ruins
      battle.defaultField = PBFieldEffects::Ruins
    when PBFieldEffects::Grassy
      battle.defaultField = PBFieldEffects::Grassy
    when PBFieldEffects::JetStream
      battle.defaultField = PBFieldEffects::JetStream
    end
  else
    battle.defaultField = battleRules["defaultField"]
  end
  # Environment
  if battleRules["environment"].nil?
    battle.environment = pbGetEnvironment
  else
    battle.environment = battleRules["environment"]
  end
  # Backdrop graphic filename
  if !battleRules["backdrop"].nil?
    backdrop = battleRules["backdrop"]
  elsif $field_effect_bg != nil
    backdrop = $field_effect_bg
  elsif $PokemonGlobal.nextBattleBack
    backdrop = $PokemonGlobal.nextBattleBack
  #elsif $PokemonGlobal.surfing
    #backdrop = "water"   # This applies wherever you are, including in caves
  else
    back = pbGetMetadata($game_map.map_id,MetadataBattleBack)
    backdrop = back if back && back!=""
  end
  backdrop = "general" if !backdrop
  battle.backdrop = backdrop
  # Choose a name for bases depending on environment
  if battleRules["base"].nil?
    case battle.environment
    when PBEnvironment::Grass, PBEnvironment::TallGrass,
         PBEnvironment::ForestGrass;                            base = "grass"
#    when PBEnvironment::Rock;                                   base = "rock"
    when PBEnvironment::Sand;                                   base = "sand"
    when PBEnvironment::MovingWater, PBEnvironment::StillWater; base = "water"
    when PBEnvironment::Puddle;                                 base = "puddle"
    when PBEnvironment::Ice;                                    base = "ice"
    end
  else
    base = battleRules["base"]
  end
  battle.backdropBase = base if base
  # Time of day
  if pbGetMetadata($game_map.map_id,MetadataEnvironment)==PBEnvironment::Cave
    battle.time = 2   # This makes Dusk Balls work properly in caves
  elsif TIME_SHADING
    timeNow = pbGetTimeNow
    if PBDayNight.isNight?(timeNow);      battle.time = 2
    elsif PBDayNight.isEvening?(timeNow); battle.time = 1
    else;                                 battle.time = 0
    end
  end
end

class PokeBattle_Battle
  def pbEORFieldDamage(battler)
    return if battler.fainted?
    amt = -1
    if $cinders > 0 && battler.affectedByCinders?
      pbDisplay(_INTL("{1} is hurt by the cinders!", battler.pbThis))
      amt = battler.totalhp / 16
      $cinders -= 1
    end
    case battler.effectiveField
    when PBFieldEffects::Lava
      return if !battler.takesLavaDamage?
      pbDisplay(_INTL("{1} is hurt by the lava!", battler.pbThis))
      amt = battler.totalhp / 16
    when PBFieldEffects::ToxicFumes
      return if !battler.affectedByFumes?
      fumes_rand = rand(100)
      if fumes_rand > 85
        pbDisplay(_INTL("{1} became confused by the toxic fumes!", battler.pbThis))
        battler.pbConfuse
      end
    end
    return if amt < 0
    @scene.pbDamageAnimation(battler)
    battler.pbReduceHP(amt, false)
    battler.pbItemHPHealCheck
    battler.pbFaint if battler.fainted?
  end
  def pbEndOfRoundPhase
    PBDebug.log("")
    PBDebug.log("[End of round]")
    @endOfRound = true
    @scene.pbBeginEndOfRoundPhase
    pbCalculatePriority           # recalculate speeds
    priority = pbPriority(true)   # in order of fastest -> slowest speeds only
    # Weather
    pbEORWeather(priority)
    # Future Sight/Doom Desire
    @positions.each_with_index do |pos,idxPos|
      next if !pos || pos.effects[PBEffects::FutureSightCounter]==0
      pos.effects[PBEffects::FutureSightCounter] -= 1
      next if pos.effects[PBEffects::FutureSightCounter]>0
      next if !@battlers[idxPos] || @battlers[idxPos].fainted?   # No target
      moveUser = nil
      eachBattler do |b|
        next if b.opposes?(pos.effects[PBEffects::FutureSightUserIndex])
        next if b.pokemonIndex!=pos.effects[PBEffects::FutureSightUserPartyIndex]
        moveUser = b
        break
      end
      next if moveUser && moveUser.index==idxPos   # Target is the user
      if !moveUser   # User isn't in battle, get it from the party
        party = pbParty(pos.effects[PBEffects::FutureSightUserIndex])
        pkmn = party[pos.effects[PBEffects::FutureSightUserPartyIndex]]
        if pkmn && pkmn.able?
          moveUser = PokeBattle_Battler.new(self,pos.effects[PBEffects::FutureSightUserIndex])
          moveUser.pbInitDummyPokemon(pkmn,pos.effects[PBEffects::FutureSightUserPartyIndex])
        end
      end
      next if !moveUser   # User is fainted
      move = pos.effects[PBEffects::FutureSightMove]
      pbDisplay(_INTL("{1} took the {2} attack!",@battlers[idxPos].pbThis,PBMoves.getName(move)))
      # NOTE: Future Sight failing against the target here doesn't count towards
      #       Stomping Tantrum.
      userLastMoveFailed = moveUser.lastMoveFailed
      @futureSight = true
      moveUser.pbUseMoveSimple(move,idxPos)
      @futureSight = false
      moveUser.lastMoveFailed = userLastMoveFailed
      @battlers[idxPos].pbFaint if @battlers[idxPos].fainted?
      pos.effects[PBEffects::FutureSightCounter]        = 0
      pos.effects[PBEffects::FutureSightMove]           = 0
      pos.effects[PBEffects::FutureSightUserIndex]      = -1
      pos.effects[PBEffects::FutureSightUserPartyIndex] = -1
    end
    # Wish
    @positions.each_with_index do |pos,idxPos|
      next if !pos || pos.effects[PBEffects::Wish]==0
      pos.effects[PBEffects::Wish] -= 1
      next if pos.effects[PBEffects::Wish]>0
      next if !@battlers[idxPos] || !@battlers[idxPos].canHeal?
      wishMaker = pbThisEx(idxPos,pos.effects[PBEffects::WishMaker])
      @battlers[idxPos].pbRecoverHP(pos.effects[PBEffects::WishAmount])
      pbDisplay(_INTL("{1}'s wish came true!",wishMaker))
    end
    # Sea of Fire damage (Fire Pledge + Grass Pledge combination)
    curWeather = pbWeather
    for side in 0...2
      next if sides[side].effects[PBEffects::SeaOfFire]==0
      next if curWeather==PBWeather::Rain || curWeather==PBWeather::HeavyRain
      @battle.pbCommonAnimation("SeaOfFire") if side==0
      @battle.pbCommonAnimation("SeaOfFireOpp") if side==1
      priority.each do |b|
        next if b.opposes?(side)
        next if !b.takesIndirectDamage? || b.pbHasType?(:FIRE)
        oldHP = b.hp
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/8,false)
        pbDisplay(_INTL("{1} is hurt by the sea of fire!",b.pbThis))
        b.pbItemHPHealCheck
        b.pbAbilitiesOnDamageTaken(oldHP)
        b.pbFaint if b.fainted?
      end
    end
    # Status-curing effects/abilities and HP-healing items
    priority.each do |b|
      next if b.fainted?
      # Grassy Terrain (healing)
      pbEORTerrainHealing(b)
      pbEORField(b)
      # Healer, Hydration, Shed Skin
      BattleHandlers.triggerEORHealingAbility(b.ability,b,self) if b.abilityActive?
      # Black Sludge, Leftovers
      BattleHandlers.triggerEORHealingItem(b.item,b,self) if b.itemActive?
      pbEORFieldDamage(b)
    end
    # Aqua Ring
    priority.each do |b|
      next if !b.effects[PBEffects::AquaRing]
      next if !b.canHeal?
      hpGain = b.totalhp/16
      hpGain = (hpGain*1.3).floor if b.hasActiveItem?(:BIGROOT)
      b.pbRecoverHP(hpGain)
      pbDisplay(_INTL("Aqua Ring restored {1}'s HP!",b.pbThis(true)))
    end
    # Ingrain
    priority.each do |b|
      next if !b.effects[PBEffects::Ingrain]
      next if !b.canHeal?
      hpGain = b.totalhp/16
      hpGain = (hpGain*1.3).floor if b.hasActiveItem?(:BIGROOT)
      b.pbRecoverHP(hpGain)
      pbDisplay(_INTL("{1} absorbed nutrients with its roots!",b.pbThis))
    end
    # Leech Seed
    priority.each do |b|
      next if b.effects[PBEffects::LeechSeed]<0
      next if !b.takesIndirectDamage?
      recipient = @battlers[b.effects[PBEffects::LeechSeed]]
      next if !recipient || recipient.fainted?
      oldHP = b.hp
      oldHPRecipient = recipient.hp
      pbCommonAnimation("LeechSeed",recipient,b)
      hpLoss = b.pbReduceHP(b.totalhp/8)
      recipient.pbRecoverHPFromDrain(hpLoss,b,
         _INTL("{1}'s health is sapped by Leech Seed!",b.pbThis))
      recipient.pbAbilitiesOnDamageTaken(oldHPRecipient) if recipient.hp<oldHPRecipient
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
      recipient.pbFaint if recipient.fainted?
    end
    # Damage from Hyper Mode (Shadow Pokémon)
    priority.each do |b|
      next if !b.inHyperMode? || @choices[b.index][0]!=:UseMove
      hpLoss = (NEWEST_BATTLE_MECHANICS) ? b.totalhp/16 : b.totalhp/8
      @scene.pbDamageAnimation(b)
      b.pbReduceHP(hpLoss,false)
      pbDisplay(_INTL("The Hyper Mode attack hurts {1}!",b.pbThis(true)))
      b.pbFaint if b.fainted?
    end
    # Damage from poisoning
    priority.each do |b|
      next if b.fainted?
      next if b.status!=PBStatuses::POISON
      if b.statusCount>0
        b.effects[PBEffects::Toxic] += 1
        b.effects[PBEffects::Toxic] = 15 if b.effects[PBEffects::Toxic]>15
      end
      if b.hasActiveAbility?(:POISONHEAL)
        if b.canHeal?
          pbCommonAnimation("Poison",b)
          pbShowAbilitySplash(b)
          b.pbRecoverHP(b.totalhp/8)
          if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
            pbDisplay(_INTL("{1}'s HP was restored.",b.pbThis))
          else
            pbDisplay(_INTL("{1}'s {2} restored its HP.",b.pbThis,b.abilityName))
          end
          pbHideAbilitySplash(b)
        end
      elsif b.takesIndirectDamage?
        oldHP = b.hp
        dmg = (b.statusCount==0) ? b.totalhp/8 : b.totalhp*b.effects[PBEffects::Toxic]/16
        b.pbContinueStatus { b.pbReduceHP(dmg,false) }
        b.pbItemHPHealCheck
        b.pbAbilitiesOnDamageTaken(oldHP)
        b.pbFaint if b.fainted?
      end
    end
    # Damage from burn
    priority.each do |b|
      next if b.status!=PBStatuses::BURN || !b.takesIndirectDamage?
      oldHP = b.hp
      dmg = (NEWEST_BATTLE_MECHANICS) ? b.totalhp/16 : b.totalhp/8
      dmg = (dmg/2.0).round if b.hasActiveAbility?(:HEATPROOF)
      b.pbContinueStatus { b.pbReduceHP(dmg,false) }
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
    end
    # Damage from sleep (Nightmare)
    priority.each do |b|
      b.effects[PBEffects::Nightmare] = false if !b.asleep?
      next if !b.effects[PBEffects::Nightmare] || !b.takesIndirectDamage?
      oldHP = b.hp
      b.pbReduceHP(b.totalhp/4)
      pbDisplay(_INTL("{1} is locked in a nightmare!",b.pbThis))
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
    end
    # Curse
    priority.each do |b|
      next if !b.effects[PBEffects::Curse] || !b.takesIndirectDamage?
      oldHP = b.hp
      b.pbReduceHP(b.totalhp/4)
      pbDisplay(_INTL("{1} is afflicted by the curse!",b.pbThis))
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
    end
    # Octolock
    priority.each do |b|
      next if !b.effects[PBEffects::Octolock]
	  octouser = @battlers[b.effects[PBEffects::OctolockUser]]
      if b.pbCanLowerStatStage?(PBStats::DEFENSE,octouser,self)
        b.pbLowerStatStage(PBStats::DEFENSE,1,octouser,true,false,true)
      end
      if b.pbCanLowerStatStage?(PBStats::SPDEF,octouser,self)
        b.pbLowerStatStage(PBStats::SPDEF,1,octouser,true,false,true)
      end
    end
    # Trapping attacks (Bind/Clamp/Fire Spin/Magma Storm/Sand Tomb/Whirlpool/Wrap)
    priority.each do |b|
      next if b.fainted? || b.effects[PBEffects::Trapping]==0
      b.effects[PBEffects::Trapping] -= 1
      moveName = PBMoves.getName(b.effects[PBEffects::TrappingMove])
      if b.effects[PBEffects::Trapping]==0
        pbDisplay(_INTL("{1} was freed from {2}!",b.pbThis,moveName))
      else
        trappingMove = b.effects[PBEffects::TrappingMove]
        if isConst?(trappingMove,PBMoves,:BIND);           pbCommonAnimation("Bind",b)
        elsif isConst?(trappingMove,PBMoves,:CLAMP);       pbCommonAnimation("Clamp",b)
        elsif isConst?(trappingMove,PBMoves,:FIRESPIN);    pbCommonAnimation("FireSpin",b)
        elsif isConst?(trappingMove,PBMoves,:MAGMASTORM);  pbCommonAnimation("MagmaStorm",b)
        elsif isConst?(trappingMove,PBMoves,:SANDTOMB);    pbCommonAnimation("SandTomb",b)
        elsif isConst?(trappingMove,PBMoves,:WRAP);        pbCommonAnimation("Wrap",b)
        elsif isConst?(trappingMove,PBMoves,:INFESTATION); pbCommonAnimation("Infestation",b)
        elsif isConst?(trappingMove,PBMoves,:SNAPTRAP); pbCommonAnimation("SnapTrap",b)
        elsif isConst?(trappingMove,PBMoves,:THUNDERCAGE); pbCommonAnimation("ThunderCage",b)
        else;                                              pbCommonAnimation("Wrap",b)
        end
        if b.takesIndirectDamage?
          hpLoss = (NEWEST_BATTLE_MECHANICS) ? b.totalhp/8 : b.totalhp/16
          if @battlers[b.effects[PBEffects::TrappingUser]].hasActiveItem?(:BINDINGBAND)
            hpLoss = (NEWEST_BATTLE_MECHANICS) ? b.totalhp/6 : b.totalhp/8
          end
          @scene.pbDamageAnimation(b)
          b.pbReduceHP(hpLoss,false)
          pbDisplay(_INTL("{1} is hurt by {2}!",b.pbThis,moveName))
          b.pbItemHPHealCheck
          # NOTE: No need to call pbAbilitiesOnDamageTaken as b can't switch out.
          b.pbFaint if b.fainted?
        end
      end
    end
    # Taunt
    pbEORCountDownBattlerEffect(priority,PBEffects::Taunt) { |battler|
      pbDisplay(_INTL("{1}'s taunt wore off!",battler.pbThis))
    }
    # Encore
    priority.each do |b|
      next if b.fainted? || b.effects[PBEffects::Encore]==0
      idxEncoreMove = b.pbEncoredMoveIndex
      if idxEncoreMove>=0
        b.effects[PBEffects::Encore] -= 1
        if b.effects[PBEffects::Encore]==0 || b.moves[idxEncoreMove].pp==0
          b.effects[PBEffects::Encore] = 0
          pbDisplay(_INTL("{1}'s encore ended!",b.pbThis))
        end
      else
        PBDebug.log("[End of effect] #{b.pbThis}'s encore ended (encored move no longer known)")
        b.effects[PBEffects::Encore]     = 0
        b.effects[PBEffects::EncoreMove] = 0
      end
    end
    # Disable/Cursed Body
    pbEORCountDownBattlerEffect(priority,PBEffects::Disable) { |battler|
      battler.effects[PBEffects::DisableMove] = 0
      pbDisplay(_INTL("{1} is no longer disabled!",battler.pbThis))
    }
    # Magnet Rise
    pbEORCountDownBattlerEffect(priority,PBEffects::MagnetRise) { |battler|
      pbDisplay(_INTL("{1}'s electromagnetism wore off!",battler.pbThis))
    }
    # Telekinesis
    pbEORCountDownBattlerEffect(priority,PBEffects::Telekinesis) { |battler|
      pbDisplay(_INTL("{1} was freed from the telekinesis!",battler.pbThis))
    }
    # Heal Block
    pbEORCountDownBattlerEffect(priority,PBEffects::HealBlock) { |battler|
      pbDisplay(_INTL("{1}'s Heal Block wore off!",battler.pbThis))
    }
    # Embargo
    pbEORCountDownBattlerEffect(priority,PBEffects::Embargo) { |battler|
      pbDisplay(_INTL("{1} can use items again!",battler.pbThis))
      battler.pbItemTerrainStatBoostCheck
    }
    # Yawn
    pbEORCountDownBattlerEffect(priority,PBEffects::Yawn) { |battler|
      if battler.pbCanSleepYawn?
        PBDebug.log("[Lingering effect] #{battler.pbThis} fell asleep because of Yawn")
        battler.pbSleep
      end
    }
    # Perish Song
    perishSongUsers = []
    priority.each do |b|
      next if b.fainted? || b.effects[PBEffects::PerishSong]==0
      b.effects[PBEffects::PerishSong] -= 1
      pbDisplay(_INTL("{1}'s perish count fell to {2}!",b.pbThis,b.effects[PBEffects::PerishSong]))
      if b.effects[PBEffects::PerishSong]==0
        perishSongUsers.push(b.effects[PBEffects::PerishSongUser])
        b.pbReduceHP(b.hp)
      end
      b.pbItemHPHealCheck
      b.pbFaint if b.fainted?
    end
    if perishSongUsers.length>0
      # If all remaining Pokemon fainted by a Perish Song triggered by a single side
      if (perishSongUsers.find_all { |idxBattler| opposes?(idxBattler) }.length==perishSongUsers.length) ||
         (perishSongUsers.find_all { |idxBattler| !opposes?(idxBattler) }.length==perishSongUsers.length)
        pbJudgeCheckpoint(@battlers[perishSongUsers[0]])
      end
    end
    # Check for end of battle
    if @decision>0
      pbGainExp
      return
    end
    for side in 0...2
      # Reflect
      pbEORCountDownSideEffect(side,PBEffects::Reflect,
         _INTL("{1}'s Reflect wore off!",@battlers[side].pbTeam))
      # Light Screen
      pbEORCountDownSideEffect(side,PBEffects::LightScreen,
         _INTL("{1}'s Light Screen wore off!",@battlers[side].pbTeam))
      # Safeguard
      pbEORCountDownSideEffect(side,PBEffects::Safeguard,
         _INTL("{1} is no longer protected by Safeguard!",@battlers[side].pbTeam))
      # Mist
      pbEORCountDownSideEffect(side,PBEffects::Mist,
         _INTL("{1} is no longer protected by mist!",@battlers[side].pbTeam))
      # Tailwind
      pbEORCountDownSideEffect(side,PBEffects::Tailwind,
         _INTL("{1}'s Tailwind petered out!",@battlers[side].pbTeam))
      # Lucky Chant
      pbEORCountDownSideEffect(side,PBEffects::LuckyChant,
         _INTL("{1}'s Lucky Chant wore off!",@battlers[side].pbTeam))
      # Pledge Rainbow
      pbEORCountDownSideEffect(side,PBEffects::Rainbow,
         _INTL("The rainbow on {1}'s side disappeared!",@battlers[side].pbTeam(true)))
      # Pledge Sea of Fire
      pbEORCountDownSideEffect(side,PBEffects::SeaOfFire,
         _INTL("The sea of fire around {1} disappeared!",@battlers[side].pbTeam(true)))
      # Pledge Swamp
      pbEORCountDownSideEffect(side,PBEffects::Swamp,
         _INTL("The swamp around {1} disappeared!",@battlers[side].pbTeam(true)))
      # Aurora Veil
      pbEORCountDownSideEffect(side,PBEffects::AuroraVeil,
         _INTL("{1}'s Aurora Veil wore off!",@battlers[side].pbTeam(true)))
    end
    # Trick Room
    pbEORCountDownFieldEffect(PBEffects::TrickRoom,
       _INTL("The twisted dimensions returned to normal!"))
    # Gravity
    pbEORCountDownFieldEffect(PBEffects::Gravity,
       _INTL("Gravity returned to normal!"))
    # Water Sport
    pbEORCountDownFieldEffect(PBEffects::WaterSportField,
       _INTL("The effects of Water Sport have faded."))
    # Mud Sport
    pbEORCountDownFieldEffect(PBEffects::MudSportField,
       _INTL("The effects of Mud Sport have faded."))
    # Wonder Room
    pbEORCountDownFieldEffect(PBEffects::WonderRoom,
       _INTL("Wonder Room wore off, and Defense and Sp. Def stats returned to normal!"))
    # Magic Room
    pbEORCountDownFieldEffect(PBEffects::MagicRoom,
       _INTL("Magic Room wore off, and held items' effects returned to normal!"))
    # End of terrains
    pbEORTerrain
    priority.each do |b|
      next if b.fainted?
      # Hyper Mode (Shadow Pokémon)
      if b.inHyperMode?
        if pbRandom(100)<10
          b.pokemon.hypermode = false
          b.pokemon.adjustHeart(-50)
          pbDisplay(_INTL("{1} came to its senses!",b.pbThis))
        else
          pbDisplay(_INTL("{1} is in Hyper Mode!",b.pbThis))
        end
      end
      # Uproar
      if b.effects[PBEffects::Uproar]>0
        b.effects[PBEffects::Uproar] -= 1
        if b.effects[PBEffects::Uproar]==0
          pbDisplay(_INTL("{1} calmed down.",b.pbThis))
        else
          pbDisplay(_INTL("{1} is making an uproar!",b.pbThis))
        end
      end
      # Slow Start's end message
      if b.effects[PBEffects::SlowStart]>0
        b.effects[PBEffects::SlowStart] -= 1
        if b.effects[PBEffects::SlowStart]==0
          pbDisplay(_INTL("{1} finally got its act together!",b.pbThis))
        end
      end
      # Bad Dreams, Moody, Speed Boost
      BattleHandlers.triggerEOREffectAbility(b.ability,b,self) if b.abilityActive?
      # Flame Orb, Sticky Barb, Toxic Orb
      BattleHandlers.triggerEOREffectItem(b.item,b,self) if b.itemActive?
      # Harvest, Pickup
      BattleHandlers.triggerEORGainItemAbility(b.ability,b,self) if b.abilityActive?
    end
    pbGainExp
    return if @decision>0
    # Form checks
    priority.each { |b| b.pbCheckForm(true) }
    # Switch Pokémon in if possible
    pbEORSwitch
    return if @decision>0
    # In battles with at least one side of size 3+, move battlers around if none
    # are near to any foes
    pbEORShiftDistantBattlers
    # Try to make Trace work, check for end of primordial weather
    priority.each { |b| b.pbContinualAbilityChecks }
    # Reset/count down battler-specific effects (no messages)
    eachBattler do |b|
      b.effects[PBEffects::BanefulBunker]    = false
      b.effects[PBEffects::Charge]           -= 1 if b.effects[PBEffects::Charge]>0
      b.effects[PBEffects::Counter]          = -1
      b.effects[PBEffects::CounterTarget]    = -1
      b.effects[PBEffects::Electrify]        = false
      b.effects[PBEffects::Endure]           = false
      b.effects[PBEffects::FirstPledge]      = 0
      b.effects[PBEffects::Flinch]           = false
      b.effects[PBEffects::FocusPunch]       = false
      b.effects[PBEffects::FollowMe]         = 0
      b.effects[PBEffects::HelpingHand]      = false
      b.effects[PBEffects::HyperBeam]        -= 1 if b.effects[PBEffects::HyperBeam]>0
      b.effects[PBEffects::KingsShield]      = false
      b.effects[PBEffects::LaserFocus]       -= 1 if b.effects[PBEffects::LaserFocus]>0
      if b.effects[PBEffects::LockOn]>0   # Also Mind Reader
        b.effects[PBEffects::LockOn]         -= 1
        b.effects[PBEffects::LockOnPos]      = -1 if b.effects[PBEffects::LockOn]==0
      end
      b.effects[PBEffects::MagicBounce]      = false
      b.effects[PBEffects::MagicCoat]        = false
      b.effects[PBEffects::MirrorCoat]       = -1
      b.effects[PBEffects::MirrorCoatTarget] = -1
      b.effects[PBEffects::Powder]           = false
      b.effects[PBEffects::Prankster]        = false
      b.effects[PBEffects::PriorityAbility]  = false
      b.effects[PBEffects::PriorityItem]     = false
      b.effects[PBEffects::Protect]          = false
      b.effects[PBEffects::RagePowder]       = false
      b.effects[PBEffects::Roost]            = false
      b.effects[PBEffects::Snatch]           = 0
      b.effects[PBEffects::SpikyShield]      = false
      b.effects[PBEffects::Spotlight]        = 0
      b.effects[PBEffects::ThroatChop]       -= 1 if b.effects[PBEffects::ThroatChop]>0
      b.effects[PBEffects::BurningJealousy]          = false
      b.effects[PBEffects::LashOut]          = false
      b.effects[PBEffects::Obstruct]         = false
      b.lastHPLost                           = 0
      b.lastHPLostFromFoe                    = 0
      b.tookDamage                           = false
      b.tookPhysicalHit                      = false
      b.lastRoundMoveFailed                  = b.lastMoveFailed
      b.lastAttacker.clear
      b.lastFoeAttacker.clear
    end
    # Reset/count down side-specific effects (no messages)
    for side in 0...2
      @sides[side].effects[PBEffects::CraftyShield]         = false
      if !@sides[side].effects[PBEffects::EchoedVoiceUsed]
        @sides[side].effects[PBEffects::EchoedVoiceCounter] = 0
      end
      @sides[side].effects[PBEffects::EchoedVoiceUsed]      = false
      @sides[side].effects[PBEffects::MatBlock]             = false
      @sides[side].effects[PBEffects::QuickGuard]           = false
      @sides[side].effects[PBEffects::Round]                = false
      @sides[side].effects[PBEffects::WideGuard]            = false
    end
    # Reset/count down field-specific effects (no messages)
    @field.effects[PBEffects::IonDeluge]   = false
    @field.effects[PBEffects::FairyLock]   -= 1 if @field.effects[PBEffects::FairyLock]>0
    @field.effects[PBEffects::FusionBolt]  = false
    @field.effects[PBEffects::FusionFlare] = false

	# Neutralizing Gas
	pbCheckNeutralizingGas

    @endOfRound = false
  end

  def pbEORTerrainHealing(battler)
    return if battler.fainted?
    # Grassy Terrain (healing)
    if @field.terrain == PBFieldEffects::Grassy && battler.affectedByTerrain? && battler.canHeal?
      PBDebug.log("[Lingering effect] Grassy Terrain heals #{battler.pbThis(true)}")
      battler.pbRecoverHP(battler.totalhp / 16)
      pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
    end
  end

  def defaultField=(value)
    @field.defaultField  = value
    @field.field_effects         = value
  end

  def pbStartFieldEffect(user, newField)
    return if @field.field_effects == newField
    @field.field_effects = newField
    pbHideAbilitySplash(user) if user
    case @field.field_effects
    when PBFieldEffects::EchoChamber
      pbDisplay(_INTL("A dull echo hums."))
    when PBFieldEffects::Desert
      pbDisplay(_INTL("Sand...it gets everywhere..."))
    when PBFieldEffects::Lava
      pbDisplay(_INTL("Hot lava flows around the battlefield."))
    when PBFieldEffects::ToxicFumes
      pbDisplay(_INTL("Poisonous gases fill the area."))
    when PBFieldEffects::Wildfire
      pbDisplay(_INTL("The field is ablaze."))
    when PBFieldEffects::Swamp
      pbDisplay(_INTL("The field is swampy."))
    when PBFieldEffects::City
      $field_effect_bg = "City"
      @scene.pbRefreshEverything
      pbDisplay(_INTL("The city hums with activity."))
    when PBFieldEffects::Ruins
      pbDisplay(_INTL("There's an odd feeling in these ruins..."))
    when PBFieldEffects::Grassy
      $field_effect_bg = "Grassy"
      @scene.pbRefreshEverything
      pbDisplay(_INTL("Grass covers the field."))
    when PBFieldEffects::JetStream
      pbDisplay(_INTL("A strong wind blows through."))
      $field_effect_bg = "JetStream"
      @scene.pbRefreshEverything
    end
    # Check for abilities/items that trigger upon the terrain changing
#    allBattlers.each { |b| b.pbAbilityOnTerrainChange }
#    allBattlers.each { |b| b.pbItemTerrainStatBoostCheck }
  end

  def pbEORField(battler)
    return if battler.fainted?
    if @field.field_effects == :Ruins && battler.affectedByRuins? && battler.canHeal?
      PBDebug.log("[Lingering effect] Ruins field heals #{battler.pbThis(true)}")
      battler.pbRecoverHP(battler.totalhp / 16)
      pbDisplay(_INTL("{1}'s HP was restored by the power of the Ruins.", battler.pbThis))
    end
    if @field.field_effects == :Grassy && battler.affectedByGrass? && battler.canHeal?
      PBDebug.log("[Lingering effect] Grassy field heals #{battler.pbThis(true)}")
      battler.pbRecoverHP(battler.totalhp / 16)
      pbDisplay(_INTL("{1}'s HP was restored by the Grassy field.", battler.pbThis))
    end
    if @field.field_effects == :Swamp && battler.affectedBySwamp? && battler.canHeal? && battler.pbHasType?([:POISON,:WATER,:GRASS])
      PBDebug.log("[Lingering effect] Swamp field heals #{battler.pbThis(true)}")
      battler.pbRecoverHP(battler.totalhp / 16)
      pbDisplay(_INTL("{1}'s HP was restored by the Swamp.", battler.pbThis))
    end
  end
end

class PokeBattle_Battler
  def effectiveField
    ret = @battle.field.field_effects
    return ret
  end
  def takesLavaDamage?
    return false if !takesIndirectDamage?
    return false if pbHasType?(:WATER) || pbHasType?(:FIRE) || pbHasType?(:FLYING) || pbHasType?(:GROUND) || pbHasType?(:DRAGON)
    return false if hasActiveAbility?([:LEVITATE, :FLASHFIRE, :FLAMEBODY, :MAGMAARMOR, :HEATPROOF, :THICKFAT])
    return false if airborne?
    return true
  end
  def affectedByFumes?
    return false if pbHasType?(:POISON) || pbHasType?(:DARK) || pbHasType?(:PSYCHIC) || pbHasType?(:STEEL)
    return false if hasActiveAbility?([:OVERCOAT, :IMMUNITY, :OWNTEMPO, :TOXICBOOST, :POISONHEAL, :INNERFOCUS, :COMPOUNDEYES, :FILTER])
    return false if hasActiveItem?(:SAFETYGOGGLES)
    return true
  end
  def affectedByCinders?
    return false if !takesIndirectDamage?
    return false if pbHasType?(:FIRE) || pbHasType?(:WATER)
    return false if hasActiveAbility?([:OVERCOAT, :FLASHFIRE, :FLAMEBODY, :MAGMAARMOR, :HEATPROOF, :THICKFAT])
    return false if hasActiveItem?([:SAFETYGOGGLES, :UTILITYUMBRELLA])
    return true
  end
  def affectedBySwamp?
    return false if hasActiveAbility?([:LEVITATE, :SHIELDDUST])
    return false if hasActiveItem?([:HEAVYDUTYBOOTS])
    return false if airborne?
    return true
  end
  def affectedByRuins?
    if pbHasType?(:FIRE) || pbHasType?(:WATER) || pbHasType?(:GRASS) || pbHasType?(:GHOST) || pbHasType?(:DRAGON)
      return true
    else
      return false
    end
  end
  def affectedByGrass?
    if affectedByTerrain?
      return true
    else
      return false
    end
  end
  def affectedByJetStream?
    if pbHasType?(:FLYING) || pbHasType?(:DRAGON) || pbHasType?(:BUG)
      return true
    else
      return false
    end
  end
end

class PokeBattle_Move
  def pbCalcType(user)
    @powerBoost = false
    $orig_grass = false
    $orig_water = false
    $orig_flying = false
    $orig_type_ice = false
    ret = pbBaseType(user)
    return ret if !ret || ret<0
    if hasConst?(PBTypes,:ELECTRIC)
      if @battle.field.effects[PBEffects::IonDeluge] && isConst?(ret,PBTypes,:NORMAL)
        ret = getConst(PBTypes,:ELECTRIC)
        @powerBoost = false
      end
      if user.effects[PBEffects::Electrify]
        ret = getConst(PBTypes,:ELECTRIC)
        @powerBoost = false
      end
    end
    if getConst(PBTypes,:WATER)
      if @battle.field.field_effects == PBFieldEffects::Lava && isConst?(ret,PBTypes,:ICE)
        @battle.field.field_effects = PBFieldEffects::None
        ret = getConst(PBTypes,:WATER)
        $orig_type_ice = true
        @powerBoost = false
      end
    end
    if getConst(PBTypes,:POISON)
      if @battle.field.field_effects == PBFieldEffects::ToxicFumes && isConst?(ret,PBTypes,:WATER)
        ret = getConst(PBTypes,:POISON)
        $orig_water = true
        @powerBoost = false
      end
    end
    if getConst(PBTypes,:FIRE)
      if @battle.field.field_effects == PBFieldEffects::Wildfire && isConst?(ret,PBTypes,:GRASS)
        ret = getConst(PBTypes,:FIRE)
        $orig_flying = false
        $orig_grass = true
        @powerBoost = false
      end
      if @battle.field.field_effects == PBFieldEffects::Wildfire && isConst?(ret,PBTypes,:FLYING) && specialMove?
        ret = getConst(PBTypes,:FIRE)
        $orig_grass = false
        $orig_flying = true
        @powerBoost = false
      end
    end
    return ret
  end
  def pbCalcDamageMultipliers(user,target,numTargets,type,baseDmg,multipliers)
   # Global abilities
   if (@battle.pbCheckGlobalAbility(:DARKAURA) && isConst?(type,PBTypes,:DARK)) ||
      (@battle.pbCheckGlobalAbility(:FAIRYAURA) && isConst?(type,PBTypes,:FAIRY))
     if @battle.pbCheckGlobalAbility(:AURABREAK)
       multipliers[BASE_DMG_MULT] *= 2/3.0
     else
       multipliers[BASE_DMG_MULT] *= 4/3.0
     end
   end
   # Ability effects that alter damage
   if user.abilityActive?
     BattleHandlers.triggerDamageCalcUserAbility(user.ability,
        user,target,self,multipliers,baseDmg,type)
   end
   if !@battle.moldBreaker
     # NOTE: It's odd that the user's Mold Breaker prevents its partner's
     #       beneficial abilities (i.e. Flower Gift boosting Atk), but that's
     #       how it works.
     user.eachAlly do |b|
       next if !b.abilityActive?
       BattleHandlers.triggerDamageCalcUserAllyAbility(b.ability,
          user,target,self,multipliers,baseDmg,type)
     end
     if target.abilityActive?
       BattleHandlers.triggerDamageCalcTargetAbility(target.ability,
          user,target,self,multipliers,baseDmg,type) if !@battle.moldBreaker
       BattleHandlers.triggerDamageCalcTargetAbilityNonIgnorable(target.ability,
          user,target,self,multipliers,baseDmg,type)
     end
     target.eachAlly do |b|
       next if !b.abilityActive?
       BattleHandlers.triggerDamageCalcTargetAllyAbility(b.ability,
          user,target,self,multipliers,baseDmg,type)
     end
   end
   # Item effects that alter damage
   if user.itemActive?
     BattleHandlers.triggerDamageCalcUserItem(user.item,
        user,target,self,multipliers,baseDmg,type)
   end
   if target.itemActive?
     BattleHandlers.triggerDamageCalcTargetItem(target.item,
        user,target,self,multipliers,baseDmg,type)
   end
   # Parental Bond's second attack
   if user.effects[PBEffects::ParentalBond]==1
     multipliers[BASE_DMG_MULT] /= 4
   end
   if user.effects[PBEffects::EchoChamber]==1
     multipliers[BASE_DMG_MULT] /= 4
   end
   # Other
   if user.effects[PBEffects::MeFirst]
     multipliers[BASE_DMG_MULT] *= 1.5
   end
   if user.effects[PBEffects::HelpingHand] && !self.is_a?(PokeBattle_Confusion)
     multipliers[BASE_DMG_MULT] *= 1.5
   end
   if user.effects[PBEffects::Charge]>0 && isConst?(type,PBTypes,:ELECTRIC)
     multipliers[BASE_DMG_MULT] *= 2
   end
   if $orig_type_ice
     @battle.pbDisplay(_INTL("The lava melted the ice!"))
     $field_effect_bg = "rocky"
     @battle.scene.pbRefreshEverything
     @battle.pbDisplay(_INTL("The melted ice cooled the lava!"))
     multipliers[FINAL_DMG_MULT] *= 0.8
     $orig_type_ice = false
   end
   # Mud Sport
   if isConst?(type,PBTypes,:ELECTRIC)
     @battle.eachBattler do |b|
       next if !b.effects[PBEffects::MudSport]
       multipliers[BASE_DMG_MULT] /= 3
       break
     end
     if @battle.field.effects[PBEffects::MudSportField]>0
       multipliers[BASE_DMG_MULT] /= 3
     end
   end
   # Tar Shot
   if target.effects[PBEffects::TarShot] && isConst?(type,PBTypes,:FIRE)
     multipliers[BASE_DMG_MULT] *= 2
   end
   # Water Sport
   if isConst?(type,PBTypes,:FIRE)
     @battle.eachBattler do |b|
       next if !b.effects[PBEffects::WaterSport]
       multipliers[BASE_DMG_MULT] /= 3
       break
     end
     if @battle.field.effects[PBEffects::WaterSportField]>0
       multipliers[BASE_DMG_MULT] /= 3
     end
   end
   # Terrain moves
   if user.affectedByTerrain?
     case @battle.field.terrain
     when PBBattleTerrains::Electric
       if isConst?(type,PBTypes,:ELECTRIC)
         multipliers[BASE_DMG_MULT] = (multipliers[BASE_DMG_MULT]*1.3).round
       end
     when PBBattleTerrains::Grassy
       if isConst?(type,PBTypes,:GRASS)
         multipliers[BASE_DMG_MULT] = (multipliers[BASE_DMG_MULT]*1.3).round
       end
     when PBBattleTerrains::Psychic
       if isConst?(type,PBTypes,:PSYCHIC)
         multipliers[BASE_DMG_MULT] = (multipliers[BASE_DMG_MULT]*1.3).round
       end
     end
   end
   if @battle.field.terrain==PBBattleTerrains::Misty && target.affectedByTerrain? &&
      isConst?(type,PBTypes,:DRAGON)
     multipliers[BASE_DMG_MULT] /= 2
   end
   # Badge multipliers
   if @battle.internalBattle
     if user.pbOwnedByPlayer?
       if physicalMove? && @battle.pbPlayer.numbadges>=NUM_BADGES_BOOST_ATTACK
         multipliers[ATK_MULT] *= 1.1
       elsif specialMove? && @battle.pbPlayer.numbadges>=NUM_BADGES_BOOST_SPATK
         multipliers[ATK_MULT] *= 1.1
       end
     end
     if target.pbOwnedByPlayer?
       if physicalMove? && @battle.pbPlayer.numbadges>=NUM_BADGES_BOOST_DEFENSE
         multipliers[DEF_MULT] *= 1.1
       elsif specialMove? && @battle.pbPlayer.numbadges>=NUM_BADGES_BOOST_SPDEF
         multipliers[DEF_MULT] *= 1.1
       end
     end
   end
   # Multi-targeting attacks
   if numTargets>1
     multipliers[FINAL_DMG_MULT] *= 0.75
   end
   # Weather
   if !target.hasUtilityUmbrella?
     case @battle.pbWeather
     when PBWeather::Sun, PBWeather::HarshSun
       if isConst?(type,PBTypes,:FIRE)
         multipliers[FINAL_DMG_MULT] = (multipliers[FINAL_DMG_MULT]*1.5).round
       elsif isConst?(type,PBTypes,:WATER)
         multipliers[FINAL_DMG_MULT] /= 2
       end
     when PBWeather::Rain, PBWeather::HeavyRain
       if isConst?(type,PBTypes,:FIRE)
         multipliers[FINAL_DMG_MULT] /= 2
       elsif isConst?(type,PBTypes,:WATER)
         multipliers[FINAL_DMG_MULT] = (multipliers[FINAL_DMG_MULT]*1.5).round
       end
   end
   end
 if @battle.pbWeather == PBWeather::Sandstorm
   if target.pbHasType?(:ROCK) && specialMove? && @function!="122"   # Psyshock
     multipliers[DEF_MULT] *= 1.5
   end
 end
 case @battle.field.field_effects
 when PBFieldEffects::Desert
   case type
   when isConst?(type,PBTypes,:FIRE), isConst?(type,PBTypes,:GROUND)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The desert strengthened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:WATER), getConst(PBTypes,:GRASS)
     multipliers[FINAL_DMG_MULT] *= 0.8
     @battle.pbDisplay(_INTL("The desert weakened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:FLYING)
     if user.effectiveWeather != :Sandstorm
       @battle.field.weather = :Sandstorm
       @battle.field.weatherDuration = user.hasActiveItem?(:SMOOTHROCK) ? 8 : 5
       @battle.pbDisplay(_INTL("The winds kicked up a Sandstorm!")) if $test_trigger == false
     end
   end
 when PBFieldEffects::Lava
   case type
   when getConst(PBTypes,:FIRE)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The lava strengthened the attack!")) if $test_trigger == false
   end
 when PBFieldEffects::ToxicFumes
   case type
   when getConst(PBTypes,:FIRE)
     multipliers[FINAL_DMG_MULT] *= 1.2
     if @battle.pbWeather == PBWeather::Rain
       @battle.pbDisplay(_INTL("The fumes strengthened the attack!")) if $test_trigger == false
     else
       @battle.pbDisplay(_INTL("The fumes strengthened the attack!")) if $test_trigger == false
       @battle.pbDisplay(_INTL("The field caught fire!")) if $test_trigger == false
       $field_effect_bg = "Wildfire"
       @battle.scene.pbRefreshEverything
       @battle.field.field_effects = PBFieldEffects::Wildfire
       @battle.pbDisplay(_INTL("The field is ablaze.")) if $test_trigger == false
     end
   when getConst(PBTypes,:POISON)
     multipliers[FINAL_DMG_MULT] *= 1.2
     if $orig_water == false
       @battle.pbDisplay(_INTL("The fumes strengthened the attack!")) if $test_trigger == false
     else
       @battle.pbDisplay(_INTL("The fumes corroded and strengthened the attack!")) if $test_trigger == false
     end
     $orig_water = false
   end
 when PBFieldEffects::Wildfire
   case type
   when getConst(PBTypes,:FIRE)
     multipliers[FINAL_DMG_MULT] *= 1.2
     if $orig_grass == false && $orig_flying == false
       @battle.pbDisplay(_INTL("The wildfire strengthened the attack!")) if $test_trigger == false
     elsif $orig_grass == true
       @battle.pbDisplay(_INTL("The plants caught fire and strengthened the attack!")) if $test_trigger == false
       $orig_grass = false
     elsif $orig_flying == true
       @battle.pbDisplay(_INTL("The winds kicked up cinders!")) if $test_trigger == false
       if $cinders == 0
         $cinders = 3
       end
       $orig_flying = false
     end
   when getConst(PBTypes,:WATER)
     multipliers[FINAL_DMG_MULT] *= 0.8
     @battle.pbDisplay(_INTL("The wildfire weakened the attack!")) if $test_trigger == false
   end
 when PBFieldEffects::Swamp
   case type
   when getConst(PBTypes,:ROCK)
     multipliers[FINAL_DMG_MULT] *= 0.8
     @battle.pbDisplay(_INTL("The swamp weakened the attack!")) if $test_trigger == false
     if self.baseDamage >= 80
       @battle.pbDisplay(_INTL("The swamp filled with rocks!")) if $test_trigger == false
       $field_effect_bg = "Rubble"
       @battle.scene.pbRefreshEverything
       @battle.field.field_effects = PBFieldEffects::None
     end
   when getConst(PBTypes,:FIRE),getConst(PBTypes,:FIGHTING)
     multipliers[FINAL_DMG_MULT] *= 0.8
     @battle.pbDisplay(_INTL("The swamp weakened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:POISON),getConst(PBTypes,:WATER),getConst(PBTypes,:GRASS)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The swamp strengthened the attack!")) if $test_trigger == false
   end
 when PBFieldEffects::City
   case type
   when getConst(PBTypes,:NORMAL),getConst(PBTypes,:POISON)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The city strengthened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:FIRE)
     if self.baseDamage >= 70 && specialMove? && @battle.pbWeather != PBWeather::Rain && @battle.pbWeather != PBWeather::HeavyRain && @battle.pbWeather != PBWeather::AcidRain
       @battle.pbDisplay(_INTL("The city caught fire!")) if $test_trigger == false
       $field_effect_bg = "Wildfire"
       @battle.field.field_effects = PBFieldEffects::Wildfire
       @battle.scene.pbRefreshEverything
       @battle.pbDisplay(_INTL("The field is ablaze.")) if $test_trigger == false
     end
   when getConst(PBTypes,:GROUND)
     if name == "Bulldoze" || name == "Earthquake" || name == "Stomping Tantrum"
       @battle.pbDisplay(_INTL("The city came crashing down!")) if $test_trigger == false
       $field_effect_bg = "Rubble"
       @battle.scene.pbRefreshEverything
       @battle.field.field_effects = PBFieldEffects::None
       user.pbOwnSide.effects[PBEffects::StealthRock] = true if user.pbOwnSide.effects[PBEffects::StealthRock] == false
       target.pbOwnSide.effects[PBEffects::StealthRock] = true if target.pbOwnSide.effects[PBEffects::StealthRock] == false
       @battle.pbDisplay(_INTL("City rubble and rocks are scattered across each side!")) if $test_trigger == false
     end
   when getConst(PBTypes,:ELECTRIC)
     if $outage == false
       multipliers[FINAL_DMG_MULT] *= 1.2
       @battle.pbDisplay(_INTL("The attack drew power from the city!")) if $test_trigger == false
       $field_effect_bg = "City_Night"
       @battle.scene.pbRefreshEverything
       @battle.pbDisplay(_INTL("Power outage!")) if $test_trigger == false
       user.eachOpposing do |pkmn|
         pkmn.pbLowerStatStage(PBStats::ACCURACY,1,user) if !pkmn.pbHasType?(:ELECTRIC)
       end
       $outage = true
     end
   when getConst(PBTypes,:DARK),getConst(PBTypes,:GHOST)
     if $outage == true
       multipliers[FINAL_DMG_MULT] *= 1.2
       if type == :DARK
         @battle.pbDisplay(_INTL("The city's darkness powered the attack!")) if $test_trigger == false
       else
         @battle.pbDisplay(_INTL("The shadows powered the attack!")) if $test_trigger == false
       end
     end
   end
   if soundMove?
     @battle.allBattlers.each do |pkmn|
       confuse = rand(100)
       if confuse > 85
         @battle.pbDisplay(_INTL("The noise of the city was too much for {1}!",pkmn.name))
         pkmn.pbConfuse if pkmn.pbCanConfuse?
       end
     end
   end
 when PBFieldEffects::Ruins
   case type
   when getConst(PBTypes,:FIRE), getConst(PBTypes,:WATER), getConst(PBTypes,:GRASS)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The ruins strengthened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:DRAGON)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The ruins strengthened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:GHOST)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The ruins strengthened the attack!")) if $test_trigger == false
   end
   if target.pbHasType?(:GHOST) && target.hp == target.totalhp
     multipliers[FINAL_DMG_MULT] /= 2
   end
 when PBFieldEffects::Grassy
   if target.pbHasType?(:BUG)
     multipliers[DEF_MULT] *= 1.2
   end
   case type
   when getConst(PBTypes,:FAIRY),getConst(PBTypes,:BUG),getConst(PBTypes,:GRASS)
     multipliers[FINAL_DMG_MULT] *= 1.2
     @battle.pbDisplay(_INTL("The grass strengthened the attack!")) if $test_trigger == false
   when getConst(PBTypes,:FIRE)
     if @battle.pbWeather != PBWeather::Rain && @battle.pbWeather != PBWeather::HeavyRain && @battle.pbWeather != PBWeather::AcidRain
       @battle.pbDisplay(_INTL("The grass caught fire!")) if $test_trigger == false
       $field_effect_bg = "Wildfire"
       $orig_grass = false
       $orig_flying = false
       @battle.field.field_effects = PBFieldEffects::Wildfire
       @battle.scene.pbRefreshEverything
       @battle.pbDisplay(_INTL("The field is ablaze.")) if $test_trigger == false
     end
   when getConst(PBTypes,:FLYING)
     if @battle.pbWeather != PBWeather::Rain && @battle.pbWeather != PBWeather::HeavyRain && @battle.pbWeather != PBWeather::AcidRain
       @battle.pbDisplay(_INTL("The attack kicked up spores!")) if $test_trigger == false
       spore = rand(10)
       spore2 = rand(10)
       if user.status == PBStatuses::NONE
         case spore
         when 0
           user.status = PBStatuses::PARALYSIS
           @battle.pbDisplay(_INTL("{1} was paralyzed!",user.pbThis))
         when 3
           user.status = PBStatuses::POISON
           @battle.pbDisplay(_INTL("{1} was poisoned!",user.pbThis))
         when 6
           user.status = PBStatuses::SLEEP
           @battle.pbDisplay(_INTL("{1} fell asleep!",user.pbThis))
         when 1,2,4,5,7,8,9
           @battle.pbDisplay(_INTL("The spores had no effect on {1}!",user.pbThis)) if $test_trigger == false
         end
       else
         @battle.pbDisplay(_INTL("But {1} was already statused.",user.pbThis)) if $test_trigger == false
       end
       if target.status == PBStatuses::NONE
         case spore2
         when 0
           target.status = PBStatuses::PARALYSIS
           @battle.pbDisplay(_INTL("{1} was paralyzed!",target.pbThis))
         when 3
           target.status = PBStatuses::POISON
           @battle.pbDisplay(_INTL("{1} was poisoned!",target.pbThis))
         when 6
           target.status = PBStatuses::SLEEP
           @battle.pbDisplay(_INTL("{1} fell asleep!",target.pbThis))
         when 1,2,4,5,7,8,9
           @battle.pbDisplay(_INTL("The spores had no effect on {1}!",target.pbThis)) if $test_trigger == false
         end
       else
         @battle.pbDisplay(_INTL("But {1} was already statused.",target.pbThis)) if $test_trigger == false
       end
     end
   end
 when PBFieldEffects::JetStream
   if target.affectedByJetStream?
     multipliers[DEF_MULT] *= 1.2 if physicalMove?
   end
   case type
   when getConst(PBTypes,:FIRE),getConst(PBTypes,:ELECTRIC),getConst(PBTypes,:ICE),getConst(PBTypes,:ROCK)
     multipliers[FINAL_DMG_MULT] *= 0.8
     @battle.pbDisplay(_INTL("The Jet Stream weakened the attack.")) if $test_trigger == false
   end
 end
   # Critical hits
   if target.damageState.critical
     if NEWEST_BATTLE_MECHANICS
       multipliers[FINAL_DMG_MULT] *= 1.5
     else
       multipliers[FINAL_DMG_MULT] *= 2
     end
   end
   # Random variance
   if !self.is_a?(PokeBattle_Confusion)
     random = 85+@battle.pbRandom(16)
     multipliers[FINAL_DMG_MULT] *= random/100.0
   end
   # STAB
   if type>=0 && user.pbHasType?(type)
     if user.hasActiveAbility?(:ADAPTABILITY)
       multipliers[FINAL_DMG_MULT] *= 2
     else
       multipliers[FINAL_DMG_MULT] *= 1.5
     end
   end
   # Recalculate the type modifier for Dragon Darts else it does 1 damage on its
   # second hit on a different target
   if self.function=="17C" && @battle.pbSideSize(target.index)>1
     typeMod = self.pbCalcTypeMod(self.calcType,user,target)
     target.damageState.typeMod = typeMod
   end
   # Type effectiveness
   multipliers[FINAL_DMG_MULT] *= target.damageState.typeMod.to_f/PBTypeEffectiveness::NORMAL_EFFECTIVE
   # Burn
   if user.status==PBStatuses::BURN && physicalMove? && damageReducedByBurn? &&
      !user.hasActiveAbility?(:GUTS)
     multipliers[FINAL_DMG_MULT] /= 2
   end
   # Aurora Veil, Reflect, Light Screen
   if !ignoresReflect? && !target.damageState.critical &&
      !user.hasActiveAbility?(:INFILTRATOR)
     if target.pbOwnSide.effects[PBEffects::AuroraVeil]>0
       if @battle.pbSideBattlerCount(target)>1
         multipliers[FINAL_DMG_MULT] *= 2/3.0
       else
         multipliers[FINAL_DMG_MULT] /= 2
       end
     elsif target.pbOwnSide.effects[PBEffects::Reflect]>0 && physicalMove?
       if @battle.pbSideBattlerCount(target)>1
         multipliers[FINAL_DMG_MULT] *= 2/3.0
       else
         multipliers[FINAL_DMG_MULT] /= 2
       end
     elsif target.pbOwnSide.effects[PBEffects::LightScreen]>0 && specialMove?
       if @battle.pbSideBattlerCount(target)>1
         multipliers[FINAL_DMG_MULT] *= 2/3.0
       else
         multipliers[FINAL_DMG_MULT] /= 2
       end
     end
   end
   # Minimize
   if target.effects[PBEffects::Minimize] && tramplesMinimize?(2)
     multipliers[FINAL_DMG_MULT] *= 2
   end
   # Move-specific base damage modifiers
   multipliers[BASE_DMG_MULT] = pbBaseDamageMultiplier(multipliers[BASE_DMG_MULT],user,target)
   # Move-specific final damage modifiers
   multipliers[FINAL_DMG_MULT] = pbModifyDamage(multipliers[FINAL_DMG_MULT],user,target)
 end
end

class PokeBattle_Scene
  def pbEndBattle(_result)
    @abortable = false
    pbShowWindow(BLANK)
    # Fade out all sprites
    pbBGMFade(1.0)
    pbFadeOutAndHide(@sprites)
    @viewport.dispose
    pbDisposeSprites
  end
  def pbRefreshEverything
    pbCreateBackdropSprites
    @battle.battlers.each_with_index do |battler, i|
      next if !battler
      pbChangePokemon(i, @sprites["pokemon_#{i}"].pkmn)
      @sprites["dataBox_#{i}"].initializeDataBoxGraphic(@battle.pbSideSize(i))
      @sprites["dataBox_#{i}"].refresh
    end
  end
  def pbCreateBackdropSprites
    case @battle.time
    when 1; time = "eve"
    when 2; time = "night"
    end
    time = nil
    # Put everything together into backdrop, bases and message bar filenames
    @battle.backdrop = $field_effect_bg if $field_effect_bg != nil
    @battle.backdropBase = $field_effect_bg if $field_effect_bg != nil
    backdropFilename = @battle.backdrop
    baseFilename = @battle.backdrop
    baseFilename = sprintf("%s_%s",baseFilename,@battle.backdropBase) if @battle.backdropBase
    messageFilename = @battle.backdrop
    if time
      trialName = sprintf("%s_%s",backdropFilename,time)
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/"+trialName+"_bg"))
        backdropFilename = trialName
      end
      trialName = sprintf("%s_%s",baseFilename,time)
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/"+trialName+"_base0"))
        baseFilename = trialName
      end
      trialName = sprintf("%s_%s",messageFilename,time)
      if pbResolveBitmap(sprintf("Graphics/Battlebacks/"+trialName+"_message"))
        messageFilename = trialName
      end
    end
    if !pbResolveBitmap(sprintf("Graphics/Battlebacks/"+baseFilename+"_base0")) &&
       @battle.backdropBase
      baseFilename = @battle.backdropBase
      if time
        trialName = sprintf("%s_%s",baseFilename,time)
        if pbResolveBitmap(sprintf("Graphics/Battlebacks/"+trialName+"_base0"))
          baseFilename = trialName
        end
      end
    end
    # Finalise filenames
    battleBG   = "Graphics/Battlebacks/"+backdropFilename+"_bg"
    playerBase = "Graphics/Battlebacks/"+baseFilename+"_base0"
    enemyBase  = "Graphics/Battlebacks/"+baseFilename+"_base1"
    messageBG  = "Graphics/Battlebacks/"+messageFilename+"_message"
    # Apply graphics
    bg = pbAddSprite("battle_bg",0,0,battleBG,@viewport)
    bg.z = 0
    bg = pbAddSprite("battle_bg2",-Graphics.width,0,battleBG,@viewport)
    bg.z      = 0
    bg.mirror = true
    for side in 0...2
      baseX, baseY = PokeBattle_SceneConstants.pbBattlerPosition(side)
      base = pbAddSprite("base_#{side}",baseX,baseY,
         (side==0) ? playerBase : enemyBase,@viewport)
      base.z    = 1
      if base.bitmap
        base.ox = base.bitmap.width/2
        base.oy = (side==0) ? base.bitmap.height : base.bitmap.height/2
      end
    end
    cmdBarBG = pbAddSprite("cmdBar_bg",0,Graphics.height-96,messageBG,@viewport)
    cmdBarBG.z = 180
  end
end
