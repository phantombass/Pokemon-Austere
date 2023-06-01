def deep_copy(obj)
  Marshal.load(Marshal.dump(obj))
end

def pbHashConverter(mod,hash)
  newhash = {}
  hash.each {|key, value|
      for i in value
          newhash[mod.const_get(i.to_sym)]=key
      end
  }
  return newhash
end

def pbHashForwardizer(hash) #one-stop shop for your hash debackwardsing needs!
  return if !hash.is_a?(Hash)
  newhash = {}
  hash.each {|key, value|
      for i in value
          newhash[i]=key
      end
  }
  return newhash
end

def arrayToConstant(mod,array)
  newarray = []
  for symbol in array
    const = mod.const_get(symbol.to_sym) rescue nil
    newarray.push(const) if const
  end
  return newarray
end

def hashToConstant(mod,hash)
  for key in hash.keys
    const = mod.const_get(hash[key].to_sym) rescue nil
    hash.merge!(key=>const) if const
  end
  return hash
end

def hashArrayToConstant(mod,hash)
  for key in hash.keys
    array = hash[key]
    newarray = arrayToConstant(mod,array)
    hash.merge!(key=>newarray) if !newarray.empty?
  end
  return hash
end

begin
  module PBFieldEffects
    None        = 0 
    EchoChamber        = 1 
    Desert       = 2 
    Lava        = 3
    ToxicFumes    = 4
    Wildfire   = 5
    Swamp   = 6
    City = 7
    Ruins         = 8
    Grassy = 9
    JetStream = 10
	Outage = 11
    Forest = 12
    Mountain = 13
    SnowMountain = 14
    Water = 15
    Underwater = 16
    Psychic = 17
    Misty = 18
    Electric = 19
    Digital = 20
    Space = 21
    Monsoon = 22
    Graveyard = 23
    Foundry = 24
    Machine = 25
    ShortOut = 26

    def PBFieldEffects.maxValue; return 27; end
    def self.getName(id)
      id = getID(PBFieldEffects,id)
      names = [-
         _INTL("None"),
         _INTL("Echo Chamber"),
         _INTL("Desert"),
         _INTL("Lava"),
         _INTL("Toxic Fumes"),
         _INTL("Wildfire"),
         _INTL("Swamp"),
         _INTL("City"),
         _INTL("Ruins"),
         _INTL("Grassy"),
         _INTL("Jet Stream"),
		     _INTL("Outage"),
         _INTL("Forest"),
         _INTL("Mountainside"),
         _INTL("Snowy Mountainside"),
         _INTL("Water"),
         _INTL("Underwater"),
         _INTL("Psychic"),
         _INTL("Misty"),
         _INTL("Electric"),
         _INTL("Digital"),
         _INTL("Space"),
         _INTL("Monsoon"),
         _INTL("Graveyard"),
         _INTL("Foundry")

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
	Outage 		= 29


    def self.maxValue; return 30; end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
  end
end

class Fields
  attr_accessor :short
  attr_accessor :recharge
  def initialize
    @short = false
    @recharge = false
  end
  def update
    @short = $game_screen.field_effects == PBFieldEffects::Machine
    @recharge = $game_screen.field_effects == PBFieldEffects::ShortOut
    field = $game_screen.field_effects
    fe = FIELD_EFFECTS[field]
    if field == PBFieldEffects::ShortOut
      fe[:field_change_conditions][PBFieldEffects::Machine] = true
      FIELD_EFFECTS[PBFieldEffects::Machine][:field_change_conditions][PBFieldEffects::ShortOut] = false
    end
    if field == PBFieldEffects::Machine
      fe[:field_change_conditions][PBFieldEffects::ShortOut] = true
      FIELD_EFFECTS[PBFieldEffects::ShortOut][:field_change_conditions][PBFieldEffects::Machine] = false
    end
  end
  def short?
    return @short
  end
  def recharge?
    return @recharge
  end
  pbCompileAllData(true) { |msg| pbSetWindowText(msg) } #This is here in case compiling fails at any point
  sound = []
  pulse = []
  moves = pbLoadMovesData
  for move in moves
    next if move == nil
    m = move[1].to_sym
    mv = PokeBattle_Move.pbFromPBMove(@battle,PBMove.new(getConst(PBMoves,m)))
    sound.push(m) if mv.flags[/k/]
    pulse.push(m) if mv.flags[/m/]
  end
  def self.ignite?
      return false if [PBWeather::Rain,PBWeather::AcidRain,PBWeather::HeavyRain].include?($weather)
      return true
  end
  ECHO_MOVES = arrayToConstant(PBMoves,[:FAKEOUT,:STOMP,:SMELLINGSALTS])
  LIGHT_MOVES = arrayToConstant(PBMoves,[:LIGHTOFRUIN,:DAZZLINGGLEAM,:MOONBLAST,:PRISMATICLASER,:PHOTONGEYSER,:AURORABEAM,:SIGNALBEAM,:MISTBALL,:LUSTERPURGE,:FLASHCANNON,:MIRRORSHOT])
  #Ember added for testing purposes only
  IGNITE_MOVES = arrayToConstant(PBMoves,[:FLAREBLITZ,:OVERHEAT,:FLAMEWHEEL,:BURNUP,:FLAMEBURST,:HEATWAVE,:LAVAPLUME,:MAGMASTORM,:ERUPTION])
  WIND_MOVES = arrayToConstant(PBMoves,[:HURRICANE,:OMINOUSWIND,:AIRCUTTER,:AIRSLASH,:SILVERWIND,:DEFOG,:TAILWIND,:DOLDRUMS,:GUST,:RAZORWIND])
  SWAMP_CHANGERS = arrayToConstant(PBMoves,[:STONEEDGE,:POWERGEM,:METEORBEAM,:ROCKSLIDE])
  QUAKE_MOVES = arrayToConstant(PBMoves,[:EARTHQUAKE,:STOMPINGTANTRUM,:BULLDOZE,:FISSURE])
  HEALING_MOVES = arrayToConstant(PBMoves,[:RECOVER,:MOONLIGHT,:MORNINGSUN,:SYNTHESIS,:ROOST,:SLACKOFF,:MILKDRINK,:SOFTBOILED,:HEALORDER,:LIFEDEW,:JUNGLEHEALING])
  SOUND_MOVES = arrayToConstant(PBMoves,sound)
  PULSE_MOVES = arrayToConstant(PBMoves,pulse)
  HAMMER_MOVES = arrayToConstant(PBMoves,[:HAMMERARM,:DRAGONHAMMER])
  CHARGE_MOVES = arrayToConstant(PBMoves,[:THUNDERWAVE,:ZINGZAP,:THUNDERPUNCH,:CHARGE,:DISCHARGE,:SHOCKWAVE,:CHARGEBEAM,:PARABOLICCHARGE,:THUNDERBOLT,:THUNDER,:WILDCHARGE,:VOLTTACKLE,:OVERDRIVE,:PLASMAFISTS])
  KICKING_MOVES = arrayToConstant(PBMoves,[:JUMPKICK,:HIGHJUMPKICK,:MEGAKICK,:TROPKICK,:DOUBLEKICK,:STOMP,:BLAZEKICK,:TRIPLEKICK,:LOWKICK,:ROLLINGKICK,:LOWSWEEP,:THUNDEROUSKICK,:HIGHHORSEPOWER])
  OUTAGE_MOVES = arrayToConstant(PBMoves,[:DISCHARGE,:OVERDRIVE,:ZAPCANNON,:PLASMAFISTS,:SHOCKWAVE])
  MACHINE_MOVES = arrayToConstant(PBMoves,[:ZINGZAP,:THUNDERPUNCH,:PARABOLICCHARGE,:THUNDERBOLT,:THUNDER,:WILDCHARGE,:VOLTTACKLE,:CHARGEBEAM])
end

$fields = Fields.new

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

class PokeBattle_Battler
	alias init_field pbInitEffects
	def pbInitEffects(*args)
		init_field(*args)
		@effects[PBEffects::Cinders] = 0
		@effects[PBEffects::Singed] = false
	end
  def field_update
    field = @battle.field.field_effects
    fe = FIELD_EFFECTS[field]
    if field == PBFieldEffects::ShortOut
      fe[:field_change_conditions][PBFieldEffects::Machine] = true
      FIELD_EFFECTS[PBFieldEffects::Machine][:field_change_conditions][PBFieldEffects::ShortOut] = false
    end
    if field == PBFieldEffects::Machine
      fe[:field_change_conditions][PBFieldEffects::ShortOut] = true
      FIELD_EFFECTS[PBFieldEffects::ShortOut][:field_change_conditions][PBFieldEffects::Machine] = false
    end
    if field == PBFieldEffects::Outage
      fe[:field_change_conditions][PBFieldEffects::City] = true
      FIELD_EFFECTS[PBFieldEffects::City][:field_change_conditions][PBFieldEffects::Outage] = false
    end
    if field == PBFieldEffects::City
      fe[:field_change_conditions][PBFieldEffects::Outage] = true
      FIELD_EFFECTS[PBFieldEffects::Outage][:field_change_conditions][PBFieldEffects::City] = false
    end
  end
  def pbUseMove(choice,specialUsage=false)
    # NOTE: This is intentionally determined before a multi-turn attack can
    #       set specialUsage to true.
    skipAccuracyCheck = (specialUsage && choice[2]!=@battle.struggle)
    # Start using the move
    pbBeginTurn(choice)
    # Force the use of certain moves if they're already being used
    if usingMultiTurnAttack?
      choice[2] = PokeBattle_Move.pbFromPBMove(@battle,PBMove.new(@currentMove))
      specialUsage = true
    elsif @effects[PBEffects::Encore]>0 && choice[1]>=0 &&
       @battle.pbCanShowCommands?(@index)
      idxEncoredMove = pbEncoredMoveIndex
      if idxEncoredMove>=0 && @battle.pbCanChooseMove?(@index,idxEncoredMove,false)
        if choice[1]!=idxEncoredMove   # Change move if battler was Encored mid-round
          choice[1] = idxEncoredMove
          choice[2] = @moves[idxEncoredMove]
          choice[3] = -1   # No target chosen
        end
      end
    end
    # Labels the move being used as "move"
    move = choice[2]
    return if !move || move.id==0   # if move was not chosen somehow
    # Try to use the move (inc. disobedience)
    @lastMoveFailed = false
    if !pbTryUseMove(choice,move,specialUsage,skipAccuracyCheck)
      @lastMoveUsed     = -1
      @lastMoveUsedType = -1
      if !specialUsage
        @lastRegularMoveUsed   = -1
        @lastRegularMoveTarget = -1
      end
      @battle.pbGainExp   # In case self is KO'd due to confusion
      pbCancelMoves
      pbEndTurn(choice)
      return
    end
    move = choice[2]   # In case disobedience changed the move to be used
    return if !move || move.id==0   # if move was not chosen somehow
    # Subtract PP
    if !specialUsage
      if !pbReducePP(move)
        @battle.pbDisplay(_INTL("{1}\nused {2}!",pbThis,move.name))
        @battle.pbDisplay(_INTL("But there was no PP left for the move!"))
        @lastMoveUsed          = -1
        @lastMoveUsedType      = -1
        @lastRegularMoveUsed   = -1
        @lastRegularMoveTarget = -1
        @lastMoveFailed        = true
        pbCancelMoves
        pbEndTurn(choice)
        return
      end
    end
    # Stance Change
    if isSpecies?(:AEGISLASH) && isConst?(@ability,PBAbilities,:STANCECHANGE)
      if move.damagingMove?
        pbChangeForm(1,_INTL("{1} changed to Blade Forme!",pbThis))
      elsif isConst?(move.id,PBMoves,:KINGSSHIELD)
        pbChangeForm(0,_INTL("{1} changed to Shield Forme!",pbThis))
      end
    end
    # Calculate the move's type during this usage
    move.calcType = move.pbCalcType(self)
    # Start effect of Mold Breaker
    @battle.moldBreaker = hasMoldBreaker?
    # Remember that user chose a two-turn move
    if move.pbIsChargingTurn?(self)
      # Beginning the use of a two-turn attack
      @effects[PBEffects::TwoTurnAttack] = move.id
      @currentMove = move.id
    else
      @effects[PBEffects::TwoTurnAttack] = 0   # Cancel use of two-turn attack
    end
    # Add to counters for moves which increase them when used in succession
    move.pbChangeUsageCounters(self,specialUsage)
    # Charge up Metronome item
    if hasActiveItem?(:METRONOME) && !move.callsAnotherMove?
      if @lastMoveUsed==move.id && !@lastMoveFailed
        @effects[PBEffects::Metronome] += 1
      else
        @effects[PBEffects::Metronome] = 0
      end
    end
    # Record move as having been used
    @lastMoveUsed     = move.id
    @lastMoveUsedType = move.calcType   # For Conversion 2
    if !specialUsage
      @lastRegularMoveUsed   = move.id   # For Disable, Encore, Instruct, Mimic, Mirror Move, Sketch, Spite
      @lastRegularMoveTarget = choice[3]   # For Instruct (remembering original target is fine)
      @movesUsed.push(move.id) if !@movesUsed.include?(move.id)   # For Last Resort
    end
    @battle.lastMoveUsed = move.id   # For Copycat
    @battle.lastMoveUser = @index   # For "self KO" battle clause to avoid draws
    @battle.successStates[@index].useState = 1   # Battle Arena - assume failure
    # Find the default user (self or Snatcher) and target(s)
    user = pbFindUser(choice,move)
    user = pbChangeUser(choice,move,user)
    targets = pbFindTargets(choice,move,user)
    targets = pbChangeTargets(move,user,targets)
    # Pressure
    if !specialUsage
      targets.each do |b|
        next unless b.opposes?(user) && b.hasActiveAbility?(:PRESSURE)
        PBDebug.log("[Ability triggered] #{b.pbThis}'s #{b.abilityName}")
        user.pbReducePP(move)
      end
      if PBTargets.targetsFoeSide?(move.pbTarget(user))
        @battle.eachOtherSideBattler(user) do |b|
          next unless b.hasActiveAbility?(:PRESSURE)
          PBDebug.log("[Ability triggered] #{b.pbThis}'s #{b.abilityName}")
          user.pbReducePP(move)
        end
      end
    end
    # Dazzling/Queenly Majesty make the move fail here
    @battle.pbPriority(true).each do |b|
      next if !b || !b.abilityActive?
      if BattleHandlers.triggerMoveBlockingAbility(b.ability,b,user,targets,move,@battle)
        @battle.pbDisplayBrief(_INTL("{1}\nused {2}!",user.pbThis,move.name))
        @battle.pbShowAbilitySplash(b)
        @battle.pbDisplay(_INTL("{1} cannot use {2}!",user.pbThis,move.name))
        @battle.pbHideAbilitySplash(b)
        user.lastMoveFailed = true
        pbCancelMoves
        pbEndTurn(choice)
        return
      end
    end
    # "X used Y!" message
    # Can be different for Bide, Fling, Focus Punch and Future Sight
    # NOTE: This intentionally passes self rather than user. The user is always
    #       self except if Snatched, but this message should state the original
    #       user (self) even if the move is Snatched.
    move.pbDisplayUseMessage(self)
    # Snatch's message (user is the new user, self is the original user)
    if move.snatched
      @lastMoveFailed = true   # Intentionally applies to self, not user
      @battle.pbDisplay(_INTL("{1} snatched {2}'s move!",user.pbThis,pbThis(true)))
    end
    # "But it failed!" checks
    if move.pbMoveFailed?(user,targets)
      PBDebug.log(sprintf("[Move failed] In function code %s's def pbMoveFailed?",move.function))
      user.lastMoveFailed = true
      pbCancelMoves
      pbEndTurn(choice)
      return
    end
    # Perform set-up actions and display messages
    # Messages include Magnitude's number and Pledge moves' "it's a combo!"
    move.pbOnStartUse(user,targets)
    # Self-thawing due to the move
    if user.status==PBStatuses::FROZEN && move.thawsUser?
      user.pbCureStatus(false)
      @battle.pbDisplay(_INTL("{1} melted the ice!",user.pbThis))
    end
    # Powder
    if user.effects[PBEffects::Powder] && isConst?(move.calcType,PBTypes,:FIRE)
      @battle.pbCommonAnimation("Powder",user)
      @battle.pbDisplay(_INTL("When the flame touched the powder on the Pokémon, it exploded!"))
      user.lastMoveFailed = true
      w = @battle.pbWeather
      if w!=PBWeather::Rain && w!=PBWeather::HeavyRain && user.takesIndirectDamage?
        oldHP = user.hp
        user.pbReduceHP((user.totalhp/4.0).round,false)
        user.pbFaint if user.fainted?
        @battle.pbGainExp   # In case user is KO'd by this
        user.pbItemHPHealCheck
        if user.pbAbilitiesOnDamageTaken(oldHP)
          user.pbEffectsOnSwitchIn(true)
        end
      end
      pbCancelMoves
      pbEndTurn(choice)
      return
    end
    # Primordial Sea, Desolate Land
    if move.damagingMove?
      case @battle.pbWeather
      when PBWeather::HeavyRain
        if isConst?(move.calcType,PBTypes,:FIRE)
          @battle.pbDisplay(_INTL("The Fire-type attack fizzled out in the heavy rain!"))
          user.lastMoveFailed = true
          pbCancelMoves
          pbEndTurn(choice)
          return
        end
      when PBWeather::HarshSun
        if isConst?(move.calcType,PBTypes,:WATER)
          @battle.pbDisplay(_INTL("The Water-type attack evaporated in the harsh sunlight!"))
          user.lastMoveFailed = true
          pbCancelMoves
          pbEndTurn(choice)
          return
        end
      end
    end
    # Protean / Libero
    if user.hasActiveAbility?(:PROTEAN) || user.hasActiveAbility?(:LIBERO) && !move.callsAnotherMove? && !move.snatched
      if user.pbHasOtherType?(move.calcType) && !PBTypes.isPseudoType?(move.calcType)
        @battle.pbShowAbilitySplash(user)
        user.pbChangeTypes(move.calcType)
        typeName = PBTypes.getName(move.calcType)
        @battle.pbDisplay(_INTL("{1} transformed into the {2} type!",user.pbThis,typeName))
        @battle.pbHideAbilitySplash(user)
        # NOTE: The GF games say that if Curse is used by a non-Ghost-type
        #       Pokémon which becomes Ghost-type because of Protean / Libero,
        #       it should target and curse itself. I think this is silly, so
        #       I'm making it choose a random opponent to curse instead.
        if move.function=="10D" && targets.length==0   # Curse
          choice[3] = -1
          targets = pbFindTargets(choice,move,user)
        end
      end
    end
    # Redirect Dragon Darts first hit if necessary
    if move.function=="17C" && @battle.pbSideSize(targets[0].index)>1
      targets=pbChangeTargets(move,user,targets,0)
    end
    #---------------------------------------------------------------------------
    magicCoater  = -1
    magicBouncer = -1
    if targets.length==0 && !PBTargets.noTargets?(move.pbTarget(user)) &&
       !move.worksWithNoTargets?
      # def pbFindTargets should have found a target(s), but it didn't because
      # they were all fainted
      # All target types except: None, User, UserSide, FoeSide, BothSides
      @battle.pbDisplay(_INTL("But there was no target..."))
      user.lastMoveFailed = true
    else   # We have targets, or move doesn't use targets
      # Reset whole damage state, perform various success checks (not accuracy)
      user.initialHP = user.hp
      targets.each do |b|
        b.damageState.reset
        b.damageState.initialHP = b.hp
        if !pbSuccessCheckAgainstTarget(move,user,b)
          b.damageState.unaffected = true
        end
      end
      # Magic Coat/Magic Bounce checks (for moves which don't target Pokémon)
      if targets.length==0 && move.canMagicCoat?
        @battle.pbPriority(true).each do |b|
          next if b.fainted? || !b.opposes?(user)
          next if b.semiInvulnerable?
          if b.effects[PBEffects::MagicCoat]
            magicCoater = b.index
            b.effects[PBEffects::MagicCoat] = false
            break
          elsif b.hasActiveAbility?(:MAGICBOUNCE) && !@battle.moldBreaker &&
             !b.effects[PBEffects::MagicBounce]
            magicBouncer = b.index
            b.effects[PBEffects::MagicBounce] = true
            break
          end
        end
      end
      # Get the number of hits
      numHits = move.pbNumHits(user,targets)
      # Process each hit in turn
      realNumHits = 0
      for i in 0...numHits
        break if magicCoater>=0 || magicBouncer>=0
        success = pbProcessMoveHit(move,user,targets,i,skipAccuracyCheck)
        if !success
          if i==0 && targets.length>0
            hasFailed = false
            targets.each do |t|
              next if t.damageState.protected
              hasFailed = t.damageState.unaffected
              break if !t.damageState.unaffected
            end
            user.lastMoveFailed = hasFailed
          end
          break
        end
        realNumHits += 1
        break if user.fainted?
        break if user.status==PBStatuses::SLEEP || user.status==PBStatuses::FROZEN
        # NOTE: If a multi-hit move becomes disabled partway through doing those
        #       hits (e.g. by Cursed Body), the rest of the hits continue as
        #       normal.
        # All targets are fainted
        # Don't stop using the move if Dragon Darts could still hit something
        break if !targets.any? { |t| !t.fainted? } unless move.function=="17C" && realNumHits<numHits && !@battle.pbAllFainted?(user.idxOpposingSide)
      end
      # Battle Arena only - attack is successful
      @battle.successStates[user.index].useState = 2
      if targets.length>0
        @battle.successStates[user.index].typeMod = 0
        targets.each do |b|
          next if b.damageState.unaffected
          @battle.successStates[user.index].typeMod += b.damageState.typeMod
        end
      end
      # Effectiveness message for multi-hit moves
      # NOTE: No move is both multi-hit and multi-target, and the messages below
      #       aren't quite right for such a hypothetical move.
      if numHits>1
        if move.damagingMove?
          targets.each do |b|
            next if b.damageState.unaffected || b.damageState.substitute
            move.pbEffectivenessMessage(user,b,targets.length)
          end
        end
        if realNumHits==1
          @battle.pbDisplay(_INTL("Hit 1 time!"))
        elsif realNumHits>1
          @battle.pbDisplay(_INTL("Hit {1} times!",realNumHits))
        end
      end
      # Magic Coat's bouncing back (move has targets)
      targets.each do |b|
        next if b.fainted?
        next if !b.damageState.magicCoat && !b.damageState.magicBounce
        @battle.pbShowAbilitySplash(b) if b.damageState.magicBounce
        @battle.pbDisplay(_INTL("{1} bounced the {2} back!",b.pbThis,move.name))
        @battle.pbHideAbilitySplash(b) if b.damageState.magicBounce
        newChoice = choice.clone
        newChoice[3] = user.index
        newTargets = pbFindTargets(newChoice,move,b)
        newTargets = pbChangeTargets(move,b,newTargets)
        success = pbProcessMoveHit(move,b,newTargets,0,false)
        b.lastMoveFailed = true if !success
        targets.each { |otherB| otherB.pbFaint if otherB && otherB.fainted? }
        user.pbFaint if user.fainted?
      end
      # Magic Coat's bouncing back (move has no targets)
      if magicCoater>=0 || magicBouncer>=0
        mc = @battle.battlers[(magicCoater>=0) ? magicCoater : magicBouncer]
        if !mc.fainted?
          user.lastMoveFailed = true
          @battle.pbShowAbilitySplash(mc) if magicBouncer>=0
          @battle.pbDisplay(_INTL("{1} bounced the {2} back!",mc.pbThis,move.name))
          @battle.pbHideAbilitySplash(mc) if magicBouncer>=0
          success = pbProcessMoveHit(move,mc,[],0,false)
          mc.lastMoveFailed = true if !success
          targets.each { |b| b.pbFaint if b && b.fainted? }
          user.pbFaint if user.fainted?
        end
      end
      # Move-specific effects after all hits
      targets.each { |b| move.pbEffectAfterAllHits(user,b) }
      # Faint if 0 HP
      targets.each { |b| b.pbFaint if b && b.fainted? }
      user.pbFaint if user.fainted?
      # External/general effects after all hits. Eject Button, Shell Bell, etc.
      pbEffectsAfterMove(user,targets,move,realNumHits)
    end
    # End effect of Mold Breaker
    @battle.moldBreaker = false
    # Gain Exp
    @battle.pbGainExp
    # Battle Arena only - update skills
    @battle.eachBattler { |b| @battle.successStates[b.index].updateSkill }
    # Shadow Pokémon triggering Hyper Mode
    pbHyperMode if @battle.choices[@index][0]!=:None   # Not if self is replaced
    # End of move usage
    pbEndTurn(choice)
    # Instruct
    @battle.eachBattler do |b|
      next if !b.effects[PBEffects::Instruct]
      b.effects[PBEffects::Instruct] = false
      idxMove = -1
      b.eachMoveWithIndex { |m,i| idxMove = i if m.id==b.lastMoveUsed }
      next if idxMove<0
      oldLastRoundMoved = b.lastRoundMoved
      @battle.pbDisplay(_INTL("{1} used the move instructed by {2}!",b.pbThis,user.pbThis(true)))
      PBDebug.logonerr{
        b.effects[PBEffects::Instructed] = true
        b.pbUseMoveSimple(b.lastMoveUsed,b.lastRegularMoveTarget,idxMove,false)
        b.effects[PBEffects::Instructed] = false
      }
      b.lastRoundMoved = oldLastRoundMoved
      @battle.pbJudge
      return if @battle.decision>0
    end
    # Dancer
    if !@effects[PBEffects::Dancer] && !user.lastMoveFailed && realNumHits>0 &&
       !move.snatched && magicCoater<0 && @battle.pbCheckGlobalAbility(:DANCER) &&
       move.danceMove?
      dancers = []
      @battle.pbPriority(true).each do |b|
        dancers.push(b) if b.index!=user.index && b.hasActiveAbility?(:DANCER)
      end
      while dancers.length>0
        nextUser = dancers.pop
        oldLastRoundMoved = nextUser.lastRoundMoved
        # NOTE: Petal Dance being used because of Dancer shouldn't lock the
        #       Dancer into using that move, and shouldn't contribute to its
        #       turn counter if it's already locked into Petal Dance.
        oldOutrage = nextUser.effects[PBEffects::Outrage]
        nextUser.effects[PBEffects::Outrage] += 1 if nextUser.effects[PBEffects::Outrage]>0
        oldCurrentMove = nextUser.currentMove
        preTarget = choice[3]
        preTarget = user.index if nextUser.opposes?(user) || !nextUser.opposes?(preTarget)
        @battle.pbShowAbilitySplash(nextUser,true)
        @battle.pbHideAbilitySplash(nextUser)
        if !PokeBattle_SceneConstants::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} kept the dance going with {2}!",
             nextUser.pbThis,nextUser.abilityName))
        end
        PBDebug.logonerr{
          nextUser.effects[PBEffects::Dancer] = true
          nextUser.pbUseMoveSimple(move.id,preTarget)
          nextUser.effects[PBEffects::Dancer] = false
        }
        nextUser.lastRoundMoved = oldLastRoundMoved
        nextUser.effects[PBEffects::Outrage] = oldOutrage
        nextUser.currentMove = oldCurrentMove
        @battle.pbJudge
        return if @battle.decision>0
      end
    end
    @battle.eachBattler do |b|
      next if battle.field.effects[PBEffects::TrickRoom] == 0
      next if !b.pbCanLowerStatStage?(PBStats::SPEED,b)
      next if !b.hasActiveItem?(:ROOMSERVICE)
      b.pbLowerStatStageByCause(PBStats::SPEED,1,b,b.itemName)
      b.pbConsumeItem
    end
    field_update
  end
end

module PBEffects
  EchoChamber = 200
  Singed = 201
  Cinders = 202
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
	  rules["backdrop"] = FIELD_EFFECTS[rules["defaultField"]][:field_gfx]
	  $game_screen.field_effect(rules["defaultField"])
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
    battle.defaultField = @battle.field.field_effects
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
  def pbOnActiveAll
    fe = FIELD_EFFECTS[@field.field_effects]
    # Neutralizing Gas activates before anything. 
  pbPriorityNeutralizingGas
    # Weather-inducing abilities, Trace, Imposter, etc.
    pbCalculatePriority(true)
    pbPriority(true).each { |b| b.pbEffectsOnSwitchIn(true) }
    pbCalculatePriority
    # Check forms are correct
    eachBattler { |b| b.pbCheckForm }
  end
  
  def pbOnActiveOne(battler)
    return false if battler.fainted?
    fe = FIELD_EFFECTS[@field.field_effects]
    # Introduce Shadow Pokémon
    if battler.opposes? && battler.shadowPokemon?
      pbCommonAnimation("Shadow",battler)
      pbDisplay(_INTL("Oh!\nA Shadow Pokémon!"))
    end
    # Record money-doubling effect of Amulet Coin/Luck Incense
    if !battler.opposes? && (isConst?(battler.item,PBItems,:AMULETCOIN) ||
                             isConst?(battler.item,PBItems,:LUCKINCENSE))
      @field.effects[PBEffects::AmuletCoin] = true
    end
    # Update battlers' participants (who will gain Exp/EVs when a battler faints)
    eachBattler { |b| b.pbUpdateParticipants }
  # Healing Wish / Lunar Dance
  pbActivateHealingWish(battler)
    # Entry hazards
    # Stealth Rock
    if battler.pbOwnSide.effects[PBEffects::StealthRock] && battler.takesIndirectDamage? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      aType = getConst(PBTypes,:ROCK) || 0
      bTypes = battler.pbTypes(true)
      eff = PBTypes.getCombinedEffectiveness(aType,bTypes[0],bTypes[1],bTypes[2])
      if !PBTypes.ineffective?(eff)
        eff = eff.to_f/PBTypeEffectiveness::NORMAL_EFFECTIVE
        oldHP = battler.hp
        battler.pbReduceHP(battler.totalhp*eff/8,false)
        pbDisplay(_INTL("Pointed stones dug into {1}!",battler.pbThis))
        battler.pbItemHPHealCheck
        if battler.pbAbilitiesOnDamageTaken(oldHP)   # Switched out
          return pbOnActiveOne(battler)   # For replacement battler
        end
      end
    end
    # Spikes
    if battler.pbOwnSide.effects[PBEffects::Spikes]>0 && battler.takesIndirectDamage? &&
       !battler.airborne? && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      spikesDiv = [8,6,4][battler.pbOwnSide.effects[PBEffects::Spikes]-1]
      oldHP = battler.hp
      battler.pbReduceHP(battler.totalhp/spikesDiv,false)
      pbDisplay(_INTL("{1} is hurt by the spikes!",battler.pbThis))
      battler.pbItemHPHealCheck
      if battler.pbAbilitiesOnDamageTaken(oldHP)   # Switched out
        return pbOnActiveOne(battler)   # For replacement battler
      end
    end
    # Toxic Spikes
    if battler.pbOwnSide.effects[PBEffects::ToxicSpikes]>0 && !battler.fainted? &&
       !battler.airborne?
      if battler.pbHasType?(:POISON)
        battler.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
        pbDisplay(_INTL("{1} absorbed the poison spikes!",battler.pbThis))
      elsif battler.pbCanPoison?(nil,false) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
        if battler.pbOwnSide.effects[PBEffects::ToxicSpikes]==2
          battler.pbPoison(nil,_INTL("{1} was badly poisoned by the poison spikes!",battler.pbThis),true)
        else
          battler.pbPoison(nil,_INTL("{1} was poisoned by the poison spikes!",battler.pbThis))
        end
      end
    end
    # Sticky Web
    if battler.pbOwnSide.effects[PBEffects::StickyWeb] && !battler.fainted? &&
       !battler.airborne? && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      pbDisplay(_INTL("{1} was caught in a sticky web!",battler.pbThis))
      if battler.pbCanLowerStatStage?(PBStats::SPEED)
      stickyuser = (battler.pbOwnSide.effects[PBEffects::StickyWebUser] > -1 ? 
      battlers[battler.pbOwnSide.effects[PBEffects::StickyWebUser]] : nil)
        battler.pbLowerStatStage(PBStats::SPEED,1,stickyuser)
        battler.pbItemStatRestoreCheck
      end
    end
    # Battler faints if it is knocked out because of an entry hazard above
    if battler.fainted?
      battler.pbFaint
      pbGainExp
      pbJudge
      return false
    end
    battler.pbCheckForm
    for key in fe[:ability_effects].keys
        if battler.hasActiveAbility?(key)
          pbShowAbilitySplash(battler)
          battler.pbRaiseStatStage(fe[:ability_effects][key][0],fe[:ability_effects][key][1],battler)
          pbHideAbilitySplash(battler)
        end
      end
    return true
  end
  
  def pbEORFieldDamage(battler)
    return if battler.fainted?
    amt = -1
    if battler.effects[PBEffects::Cinders] > 0 && battler.affectedByCinders?
      pbDisplay(_INTL("{1} is hurt by the cinders!", battler.pbThis))
      amt = battler.totalhp / 16
      battler.effects[PBEffects::Cinders] -= 1
    end
    case battler.effectiveField
    when PBFieldEffects::Lava
      if battler.takesLavaDamage?
        pbDisplay(_INTL("{1} is hurt by the lava!", battler.pbThis))
        amt = battler.totalhp / 16
      end
    when PBFieldEffects::ToxicFumes
      if battler.affectedByFumes?
        fumes_rand = rand(100)
        if fumes_rand > 85
          pbDisplay(_INTL("{1} became confused by the toxic fumes!", battler.pbThis))
          battler.pbConfuse
        end
      end
    end
    return if amt < 0
    @scene.pbDamageAnimation(battler)
    battler.pbReduceHP(amt, false)
    battler.pbItemHPHealCheck
    battler.pbFaint if battler.fainted?
    $effect_flag = {}
  end
  def pbEndOfRoundPhase
    PBDebug.log("")
    PBDebug.log("[End of round]")
    $test_trigger = false
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
    fe = FIELD_EFFECTS[@field.field_effects]
    if @field.field_effects == PBFieldEffects::Grassy && battler.affectedByTerrain? && battler.canHeal?
      PBDebug.log("[Lingering effect] Grassy Terrain heals #{battler.pbThis(true)}")
      battler.pbRecoverHP(battler.totalhp / 16)
      pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
    end
    if [PBFieldEffects::Electric,PBFieldEffects::Machine,PBFieldEffects::Digital].include?(@field.field_effects)
      if battler.hasActiveAbility?(:VOLTABSORB)
        battler.pbRecoverHP(battler.totalhp / 16)
        pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
      end
    end
  end

  def defaultField=(value)
    @field.defaultField  = value
    @field.field_effects         = value
  end

  def pbStartFieldEffect(user, newField)
    return if @field.field_effects == newField
	@field.field_effects = newField
  	msg = FIELD_EFFECTS[newField][:intro_message]
  	bg = FIELD_EFFECTS[newField][:field_gfx]
  	pbDisplay(_INTL(msg))
  	$field_effect_bg = bg
	 pbHideAbilitySplash(user) if user
  	@scene.pbRefreshEverything
    # Check for abilities/items that trigger upon the terrain changing
#    allBattlers.each { |b| b.pbAbilityOnTerrainChange }
#    allBattlers.each { |b| b.pbItemTerrainStatBoostCheck }
  end

  def pbEORField(battler)
	$effect_flag = {}
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
  def can_singe?
	 return false if pbHasType?(:FIRE) || hasActiveAbility?([:FLASHFIRE,:WATERBUBBLE,:WATERVEIL,:FLAMEBODY,:HEATPROOF,:THICKFAT,:MAGMAARMOR])
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
  def affectedBySpore?
    if pbHasType?(:GRASS) || hasActiveAbility?(:OVERCOAT) || hasActiveItem?(:SAFETYGOGGLES)
      return false
    else
      return true
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
  def pbAdditionalEffectChance(user,target,effectChance=0)
    return 0 if target.hasActiveAbility?(:SHIELDDUST) && !@battle.moldBreaker
    ret = (effectChance>0) ? effectChance : @addlEffect
    if NEWEST_BATTLE_MECHANICS || @function!="0A4"   # Secret Power
      ret *= 2 if user.hasActiveAbility?(:SERENEGRACE) ||
                  user.pbOwnSide.effects[PBEffects::Rainbow]>0
    end
	  fe_info = FIELD_EFFECTS[@battle.field.field_effects]
    ret = 100 if @battle.field.field_effects == PBFieldEffects::Desert && @function == "500"
    ret = 100 if $DEBUG && Input.press?(Input::CTRL)
    return ret
  end

  def pbAccuracyCheck(user,target)
    # "Always hit" effects and "always hit" accuracy
    fe = FIELD_EFFECTS[@battle.field.field_effects]
    return true if target.effects[PBEffects::Telekinesis]>0
    return true if target.effects[PBEffects::Minimize] && tramplesMinimize?(1)
    baseAcc = pbBaseAccuracy(user,target)
    for key in fe[:move_accuracy_change].keys
      if (fe[:move_accuracy_change][key].is_a?(Array) && fe[:move_accuracy_change][key].include?(self.id)) || fe[:move_accuracy_change][key] == self.id
        baseAcc = key
      end
    end
    return true if baseAcc==0
    # Calculate all multiplier effects
    modifiers = []
    modifiers[BASE_ACC]  = baseAcc
    modifiers[ACC_STAGE] = user.stages[PBStats::ACCURACY]
    modifiers[EVA_STAGE] = target.stages[PBStats::EVASION]
    modifiers[ACC_MULT]  = 1.0
    modifiers[EVA_MULT]  = 1.0
    pbCalcAccuracyModifiers(user,target,modifiers)
    # Check if move can't miss
    return true if modifiers[BASE_ACC]==0
    # Calculation
    accStage = [[modifiers[ACC_STAGE],-6].max,6].min + 6
    evaStage = [[modifiers[EVA_STAGE],-6].max,6].min + 6
    stageMul = [3,3,3,3,3,3, 3, 4,5,6,7,8,9]
    stageDiv = [9,8,7,6,5,4, 3, 3,3,3,3,3,3]
    accuracy = 100.0 * stageMul[accStage] / stageDiv[accStage]
    evasion  = 100.0 * stageMul[evaStage] / stageDiv[evaStage]
    accuracy = (accuracy * modifiers[ACC_MULT]).round
    evasion  = (evasion  * modifiers[EVA_MULT]).round
    evasion = 1 if evasion<1
    # Calculation/Blunder Policy
    ret = @battle.pbRandom(100) < modifiers[BASE_ACC] * accuracy / evasion
    user.effects[PBEffects::BlunderPolicy]=true if !ret
    return ret
  end

  def pbCalcType(user)
    @powerBoost = false
    $orig_grass = false
    $orig_water = false
    $orig_flying = false
    $orig_type_ice = false
    ret = pbBaseType(user)
	fe = FIELD_EFFECTS[@battle.field.field_effects]
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
	#New Field Effect Modifier Method
	if fe[:type_type_change].keys != nil
		for type_mod in fe[:type_type_change].keys
			if isConst?(ret,PBTypes,type_mod)
				ret = getConst(PBTypes,fe[:type_type_change][type_mod])
				for message in fe[:type_change_message].keys
					if fe[:type_change_message][message].include?(type_mod)
						msg = message
					end
				end
				@battle.pbDisplay(_INTL(msg))
				@powerBoost = false
			end
		end
	end
    return ret
  end
  def pbCalcTypeModSingle(moveType,defType,user,target)
    ret = PBTypes.getEffectiveness(moveType,defType)
    # Ring Target
    if target.hasActiveItem?(:RINGTARGET)
      ret = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE if PBTypes.ineffective?(moveType,defType)
    end
    # Foresight
    if user.hasActiveAbility?(:SCRAPPY) || target.effects[PBEffects::Foresight]
      ret = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE if isConst?(defType,PBTypes,:GHOST) &&
                                                         PBTypes.ineffective?(moveType,defType)
    end
    # Miracle Eye
    if target.effects[PBEffects::MiracleEye]
      ret = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE if isConst?(defType,PBTypes,:DARK) &&
                                                         PBTypes.ineffective?(moveType,defType)
    end
    # Delta Stream's weather
    if @battle.pbWeather==PBWeather::StrongWinds
      ret = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE if isConst?(defType,PBTypes,:FLYING) &&
                                                         PBTypes.superEffective?(moveType,defType)
    end
    # Grounded Flying-type Pokémon become susceptible to Ground moves
    if !target.airborne?
      ret = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE if isConst?(defType,PBTypes,:FLYING) &&
                                                         isConst?(moveType,PBTypes,:GROUND)
    end
    if target.effects[PBEffects::TarShot] && isConst?(moveType,PBTypes,:FIRE)
      ret = PBTypeEffectiveness::SUPER_EFFECTIVE_ONE if PBTypes.normalEffective?(moveType,target.type1,target.type2)
      ret = PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE if PBTypes.notVeryEffective?(moveType,target.type1,target.type2)
    end
    fe = FIELD_EFFECTS[@battle.field.field_effects]
    for key in fe[:move_type_mod].keys
      if fe[:move_type_mod][key].include?(self.id)
        newEff = PBTypes.getEffectiveness(getConst(PBTypes,key),defType)
        ret *= newEff.to_f/PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE
      end
    end
    for i in fe[:type_type_mod].keys
      if fe[:type_type_mod][i].include?(moveType)
        typeEff = PBTypes.getEffectiveness(getConst(PBTypes,i),defType)
        ret *= typeEff.to_f/PBTypeEffectiveness::NORMAL_EFFECTIVE_ONE
      end
    end
    return ret
  end
  def field_update
    field = @battle.field.field_effects
    fe = FIELD_EFFECTS[field]
    if field == PBFieldEffects::ShortOut
      fe[:field_change_conditions][PBFieldEffects::Machine] = true
      FIELD_EFFECTS[PBFieldEffects::Machine][:field_change_conditions][PBFieldEffects::ShortOut] = false
    end
    if field == PBFieldEffects::Machine
      fe[:field_change_conditions][PBFieldEffects::ShortOut] = true
      FIELD_EFFECTS[PBFieldEffects::ShortOut][:field_change_conditions][PBFieldEffects::Machine] = false
    end
    if field == PBFieldEffects::Outage
      fe[:field_change_conditions][PBFieldEffects::City] = true
      FIELD_EFFECTS[PBFieldEffects::City][:field_change_conditions][PBFieldEffects::Outage] = false
    end
    if field == PBFieldEffects::City
      fe[:field_change_conditions][PBFieldEffects::Outage] = true
      FIELD_EFFECTS[PBFieldEffects::Outage][:field_change_conditions][PBFieldEffects::City] = false
    end
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
	 #Field Effect Changing
   fe = FIELD_EFFECTS[@battle.field.field_effects]
	 if fe[:field_changers] != nil
		 priority = @battle.pbPriority(true)
		 cmsg = nil
		 for fc in fe[:field_changers].keys
			if @battle.field.field_effects != PBFieldEffects::None
				if fe[:field_changers][fc].include?(self.id) && (fe[:field_change_conditions][fc] == true)
					for message in fe[:change_message].keys
						cmsg = message if fe[:change_message][message].include?(self.id)
					end
          if $test_trigger == false
  					@battle.pbDisplay(_INTL(cmsg)) if cmsg != nil
            @battle.field.field_effects = fc
  					fe = FIELD_EFFECTS[@battle.field.field_effects]
  					$field_effect_bg = fe[:field_gfx]
  					@battle.scene.pbRefreshEverything
  					priority.each do |pkmn|
  						if pkmn.hasActiveAbility?([fe[:abilities]])
  							for key in fe[:ability_effects].keys
  								if pkmn.ability != fc
  									abil = nil
  								else
  									abil = fe[:ability_effects][pkmn.ability]
  								end
  								if pkmn.ability == fc && abil.is_a?(Array)
  									trigger = true
  								end
  							end
  							BattleHandlers.triggerAbilityOnSwitchIn(fc,pkmn,@battle) if trigger
  							pkmn.pbRaiseStatStage(abil[0],abil[1],user) if abil != nil && !trigger
  						end
  					end
          end
				end
			end
			end
	  end
 #Field Effect Type Boosts
	 trigger = false
	 if fe[:type_damage_change] != nil
    mesg = false
     msg = nil
		 for key in fe[:type_damage_change].keys
			 if @battle.field.field_effects != PBFieldEffects::None
				if fe[:type_damage_change][key].is_a?(Array)
					for j in fe[:type_damage_change][key]
						multipliers[FINAL_DMG_MULT] *= key if j == type
						mesg = true if j == type
					end
				elsif type == getConst(PBTypes,fe[:type_damage_change][key])
					multipliers[FINAL_DMG_MULT] *= key
					mesg = true
				end
				if mesg == true
					for key in fe[:type_messages].keys
						if fe[:type_messages][key].is_a?(Array)
								msg = key if fe[:type_messages][key].include?(type)
						else
							msg = key if getConst(PBTypes,fe[:type_messages][key]) == type
						end
					end
					@battle.pbDisplay(_INTL(msg)) if $test_trigger == false
				end
			 end
		 end
	 end
	 #Field Effect Specific Move Boost
	 if fe[:move_damage_boost] != nil
    mesg = false
    msg = nil
		 for dmg in fe[:move_damage_boost].keys
			 if @battle.field.field_effects != PBFieldEffects::None
					if fe[:move_damage_boost][dmg].include?(self.id)
						multipliers[FINAL_DMG_MULT] *= dmg 
						mesg = true
					end
				if mesg == true
					for mess in fe[:move_messages].keys
            next if !fe[:move_messages][mess].include?(self.id)
            if fe[:move_messages][mess].include?(self.id)
              msg = mess
            end
            @battle.pbDisplay(_INTL(msg)) if $test_trigger == false
					end
				end
			 end
		 end
	 end

	#Field Effect Defensive Modifiers
	 if fe[:defensive_modifiers] != nil
		priority = @battle.pbPriority(true)
		msg = nil
		for d in fe[:defensive_modifiers].keys
			if fe[:defensive_modifiers][d][1] == "fullhp"
				multipliers[FINAL_DMG_MULT] /= d
			elsif fe[:defensive_modifiers][d][1] == "physical"
				multipliers[DEF_MULT] *= d if physicalMove?
			elsif fe[:defensive_modifiers][d][1] == "special"
				multipliers[DEF_MULT] *= d if specialMove?
			elsif fe[:defensive_modifiers][d][1] == nil
				multipliers[DEF_MULT] *= d
			end
		end
	end
	#Additional Effects of Field Effects
	 if fe[:side_effects] != nil
		priority = @battle.pbPriority(true)
		msg = nil
    f = fe[:side_effects].keys
		for eff in fe[:side_effects].keys
			if (fe[:side_effects][eff].is_a?(Array) && fe[:side_effects][eff].include?(self.id)) || (!fe[:side_effects][eff].is_a?(Array) && type == getConst(PBTypes,fe[:side_effects][eff]))
        case eff
        when "sand"
          if @battle.field.weather != PBWeather::Sandstorm
              @battle.field.weather = PBWeather::Sandstorm
              @battle.field.weatherDuration = user.hasActiveItem?(:SMOOTHROCK) ? 8 : 5
            @battle.pbDisplay(_INTL("The wind kicked up sand!")) if $test_trigger == false
          end
        when "cinders"
          priority = @battle.pbPriority(true)
          priority.each do |target|
            target.effects[PBEffects::Cinders] = 3 if target.effects[PBEffects::Cinders] == 0 && target.affectedByCinders?
          end
          @battle.pbDisplay(_INTL("The wind kicked up cinders!")) if $test_trigger == false
        
        when "outage"
          priority = @battle.pbPriority(true)
          priority.each do |pkmn|
            pkmn.pbLowerStatStage(PBStats::ACCURACY,1,user) if !pkmn.pbHasType?(:ELECTRIC)
          end
        
        when "sound_confuse"
          priority = @battle.pbPriority(true)
          priority.each do |pkmn|
             next if pkmn.hasActiveAbility?(:SOUNDPROOF)
             confuse = rand(100)
             if confuse > 85
				 @battle.pbDisplay(_INTL("The noise of the city was too much for {1}!",pkmn.name))
				 pkmn.pbConfuse if pkmn.pbCanConfuse?
             end
           end
  		 when "disturb"
    			dist = rand(10)
    			if user.pbCanFreeze?(user,true) && dist > 7
    				user.pbFreeze
    				@battle.pbDisplay(_INTL("The spirits awoke and chilled {1} to the bone!",user.name))
    			end
       end
     end
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