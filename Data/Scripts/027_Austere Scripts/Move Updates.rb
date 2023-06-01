#===============================================================================
# Entry hazard. Lays spikes on the opposing side (max. 3 layers). (Spikes)
#===============================================================================
class PokeBattle_Move_103 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::Spikes]>=3
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if @battle.field.field_effects == PBFieldEffects::JetStream
      @battle.pbDisplay(_INTL("The Jet Stream prevents the hazards!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::Spikes] += 1
    @battle.pbDisplay(_INTL("Spikes were scattered all around {1}'s feet!",
       user.pbOpposingTeam(true)))
  end
end



#===============================================================================
# Entry hazard. Lays poison spikes on the opposing side (max. 2 layers).
# (Toxic Spikes)
#===============================================================================
class PokeBattle_Move_104 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::ToxicSpikes]>=2
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if @battle.field.field_effects == PBFieldEffects::JetStream
      @battle.pbDisplay(_INTL("The Jet Stream prevents the hazards!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::ToxicSpikes] += 1
    @battle.pbDisplay(_INTL("Poison spikes were scattered all around {1}'s feet!",
       user.pbOpposingTeam(true)))
  end
end



#===============================================================================
# Entry hazard. Lays stealth rocks on the opposing side. (Stealth Rock)
#===============================================================================
class PokeBattle_Move_105 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::StealthRock]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if @battle.field.field_effects == PBFieldEffects::JetStream
      @battle.pbDisplay(_INTL("The Jet Stream prevents the hazards!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::StealthRock] = true
    @battle.pbDisplay(_INTL("Pointed stones float in the air around {1}!",
       user.pbOpposingTeam(true)))
  end
end

#===============================================================================
# Entry hazard. Lays stealth rocks on the opposing side. (Sticky Web)
#===============================================================================
class PokeBattle_Move_153 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::StickyWeb]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if @battle.field.field_effects == PBFieldEffects::JetStream
      @battle.pbDisplay(_INTL("The Jet Stream prevents the hazards!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::StickyWeb] = true
    user.pbOpposingSide.effects[PBEffects::StickyWebUser] = user.index
    @battle.pbDisplay(_INTL("A sticky web has been laid out beneath {1}'s feet!",
       user.pbOpposingTeam(true)))
  end
end

class PokeBattle_Move_500 < PokeBattle_BurnMove
  def pbFailsAgainstTarget?(user,target)
    return false if damagingMove?
    return !target.pbCanBurn?(user,true,self)
  end

  def pbEffectAgainstTarget(user,target)
    return if damagingMove?
    target.pbBurn(user)
  end

  def pbAdditionalEffect(user,target)
    return if target.damageState.substitute
    target.pbBurn(user) if target.pbCanBurn?(user,false,self)
  end
end

class PokeBattle_Move_18C < PokeBattle_Move
  def priority
    ret = super
    ret += 1 if @battle.field.field_effects == PBFieldEffects::Grassy
    return ret
  end
end

class PokeBattle_Move_18D < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if [PBFieldEffects::Electric,PBFieldEffects::Machine,PBFieldEffects::Digital].include?(@battle.field.field_effects)
    return baseDmg
  end
end

BattleHandlers::TerrainStatBoostItem.add(:ELECTRICSEED,
  proc { |item,battler,battle|
    next false if ![PBFieldEffects::Electric,PBFieldEffects::Machine,PBFieldEffects::Digital].include?(battle.field.field_effects)
    next false if !battler.pbCanRaiseStatStage?(PBStats::DEFENSE,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::DEFENSE,1,battler,itemName)
  }
)

BattleHandlers::TerrainStatBoostItem.add(:GRASSYSEED,
  proc { |item,battler,battle|
    next false if battle.field.field_effects!=PBFieldEffects::Grassy
    next false if !battler.pbCanRaiseStatStage?(PBStats::DEFENSE,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::DEFENSE,1,battler,itemName)
  }
)

BattleHandlers::TerrainStatBoostItem.add(:MISTYSEED,
  proc { |item,battler,battle|
    next false if battle.field.field_effects!=PBFieldEffects::Misty
    next false if !battler.pbCanRaiseStatStage?(PBStats::SPDEF,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::SPDEF,1,battler,itemName)
  }
)

BattleHandlers::TerrainStatBoostItem.add(:PSYCHICSEED,
  proc { |item,battler,battle|
    next false if battle.field.field_effects!=PBFieldEffects::Psychic
    next false if !battler.pbCanRaiseStatStage?(PBStats::SPDEF,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::SPDEF,1,battler,itemName)
  }
)