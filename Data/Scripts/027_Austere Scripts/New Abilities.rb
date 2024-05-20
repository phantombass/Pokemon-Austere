#Medusoid
BattleHandlers::AbilityOnSwitchIn.add(:MEDUSOID,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    battle.eachOtherSideBattler(battler.index) do |b|
      next if !b.near?(battler)
      b.pbLowerSpeedStatStageMedusoid(battler)
      b.pbItemOnIntimidatedCheck
    end
    battle.pbHideAbilitySplash(battler)
  }
)

def pbLowerSpeedStatStageMedusoid(user)
  return false if fainted?
  # NOTE: Substitute intentially blocks Intimidate even if self has Contrary.
  if @effects[PBEffects::Substitute]>0
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      @battle.pbDisplay(_INTL("{1} is protected by its substitute!",pbThis))
    else
      @battle.pbDisplay(_INTL("{1}'s substitute protected it from {2}'s {3}!",
         pbThis,user.pbThis(true),user.abilityName))
    end
    return false
  end
  # NOTE: These checks exist to ensure appropriate messages are shown if
  #       Intimidate is blocked somehow (i.e. the messages should mention the
  #       Intimidate ability by name).
  if !hasActiveAbility?(:CONTRARY)
    if pbOwnSide.effects[PBEffects::Mist]>0
      @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by MIST!",
         pbThis,user.pbThis(true),user.abilityName))
      return false
    end
    if abilityActive?
      if BattleHandlers.triggerStatLossImmunityAbility(@ability,self,PBStats::SPEED,@battle,false) ||
         BattleHandlers.triggerStatLossImmunityAbilityNonIgnorable(@ability,self,PBStats::SPEED,@battle,false)
        @battle.pbShowAbilitySplash(self) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1}'s {2} prevented {3}'s {4} from working!",
           pbThis,abilityName,user.pbThis(true),user.abilityName))
        @battle.pbHideAbilitySplash(self) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        return false
      end
    end
    eachAlly do |b|
      next if !b.abilityActive?
      if BattleHandlers.triggerStatLossImmunityAllyAbility(b.ability,b,self,PBStats::SPEED,@battle,false)
        @battle.pbShowAbilitySplash(b) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by {4}'s {5}!",
           pbThis,user.pbThis(true),user.abilityName,b.pbThis(true),b.abilityName))
        @battle.pbHideAbilitySplash(b) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        return false
      end
    end
  end
  return false if !pbCanLowerStatStage?(PBStats::SPEED,user)
  if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
    if pbLowerStatStageByAbility(PBStats::SPEED,1,user,false)
      pbRaiseStatStageByAbility(PBStats::SPEED,1,self) if hasActiveAbility?(:RATTLED)
      return true
    else
      return false
    end
  else
    if pbLowerStatStageByCause(PBStats::SPEED,1,user,user.abilityName)
      pbLowerStatStageByCause(PBStats::SPEED,1,self,self.abilityName) if hasActiveAbility?(:RATTLED)
      return true
    else
      return false
    end
  end
end

#Mind Games
BattleHandlers::AbilityOnSwitchIn.add(:MINDGAMES,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    battle.eachOtherSideBattler(battler.index) do |b|
      next if !b.near?(battler)
      b.pbLowerSpAtkStatStageMindGames(battler)
      b.pbItemOnIntimidatedCheck
    end
    battle.pbHideAbilitySplash(battler)
  }
)

def pbLowerSpAtkStatStageMindGames(user)
  return false if fainted?
  # NOTE: Substitute intentially blocks Intimidate even if self has Contrary.
  if @effects[PBEffects::Substitute]>0
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      @battle.pbDisplay(_INTL("{1} is protected by its substitute!",pbThis))
    else
      @battle.pbDisplay(_INTL("{1}'s substitute protected it from {2}'s {3}!",
         pbThis,user.pbThis(true),user.abilityName))
    end
    return false
  end
  # NOTE: These checks exist to ensure appropriate messages are shown if
  #       Intimidate is blocked somehow (i.e. the messages should mention the
  #       Intimidate ability by name).
  if !hasActiveAbility?(:CONTRARY)
    if pbOwnSide.effects[PBEffects::Mist]>0
      @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by MIST!",
         pbThis,user.pbThis(true),user.abilityName))
      return false
    end
    if abilityActive?
      if BattleHandlers.triggerStatLossImmunityAbility(@ability,self,PBStats::SPATK,@battle,false) ||
         BattleHandlers.triggerStatLossImmunityAbilityNonIgnorable(@ability,self,PBStats::SPATK,@battle,false)
        @battle.pbShowAbilitySplash(self) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1}'s {2} prevented {3}'s {4} from working!",
           pbThis,abilityName,user.pbThis(true),user.abilityName))
        @battle.pbHideAbilitySplash(self) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        return false
      end
    end
    eachAlly do |b|
      next if !b.abilityActive?
      if BattleHandlers.triggerStatLossImmunityAllyAbility(b.ability,b,self,PBStats::SPATK,@battle,false)
        @battle.pbShowAbilitySplash(b) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by {4}'s {5}!",
           pbThis,user.pbThis(true),user.abilityName,b.pbThis(true),b.abilityName))
        @battle.pbHideAbilitySplash(b) if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        return false
      end
    end
  end
  return false if !pbCanLowerStatStage?(PBStats::SPATK,user)
  if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
    if pbLowerStatStageByAbility(PBStats::SPATK,1,user,false)
      pbRaiseStatStageByAbility(PBStats::SPEED,1,self) if hasActiveAbility?(:RATTLED)
      return true
    else
      return false
    end
  else
    if pbLowerStatStageByCause(PBStats::SPATK,1,user,user.abilityName)
      pbLowerStatStageByCause(PBStats::SPEED,1,self,self.abilityName) if hasActiveAbility?(:RATTLED)
      return true
    else
      return false
    end
  end
end

BattleHandlers::TargetAbilityOnHit.add(:ICEBODY,
  proc { |ability,user,target,move,battle|
    next if !move.pbContactMove?(user)
    next if user.frozen? || battle.pbRandom(100)>=30
    battle.pbShowAbilitySplash(target)
    if user.pbCanFreeze?(target,PokeBattle_SceneConstants::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(PokeBattle_SceneConstants::USE_ABILITY_SPLASH)
      msg = nil
      if !PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} gave {3} frostbite!",target.pbThis,target.abilityName,user.pbThis(true))
      end
      user.pbFreeze(target,msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SHARPNESS,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.5 if Fields::SLICING_MOVES.include?(move.id)
  }
)

BattleHandlers::DamageCalcUserAbility.add(:GAVELPOWER,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.5 if Fields::HAMMER_MOVES.include?(move.id)
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TIGHTFOCUS,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.3 if Fields::BEAM_MOVES.include?(move.id)
  }
)

BattleHandlers::DamageCalcUserAbility.add(:STEPMASTER,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.3 if Fields::KICKING_MOVES.include?(move.id)
  }
)