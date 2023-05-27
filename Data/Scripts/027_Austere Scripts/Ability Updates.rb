BattleHandlers::AbilityOnSwitchIn.add(:GRASSYSURGE,
  proc { |ability,battler,battle|
    next if battle.field.field_effects==PBFieldEffects::Grassy
    battle.pbShowAbilitySplash(battler)
    battle.pbStartFieldEffect(battler,PBFieldEffects::Grassy)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:GRASSPELT,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if user.battle.field.field_effects==PBFieldEffects::Grassy
      mults[DEF_MULT] *= 1.5
    end
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:SAPSIPPER,
  proc { |ability,battler,battle|
    next if battle.field.field_effects != PBFieldEffects::Grassy
    stat = PBStats::ATTACK
    battler.pbRaiseStatStageByAbility(stat,1,battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:LIGHTNINGROD,
  proc { |ability,battler,battle|
    next if ![PBFieldEffects::Machine,PBFieldEffects::Electric,PBFieldEffects::Digital].include?(battle.field.field_effects)
    stat = PBStats::SPATK
    battler.pbRaiseStatStageByAbility(stat,1,battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:MOTORDRIVE,
  proc { |ability,battler,battle|
    next if ![PBFieldEffects::Machine,PBFieldEffects::Electric,PBFieldEffects::Digital].include?(battle.field.field_effects)
    stat = PBStats::SPEED
    battler.pbRaiseStatStageByAbility(stat,1,battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:LIGHTNINGROD,
  proc { |ability,battler,battle|
    next if ![PBFieldEffects::Machine,PBFieldEffects::Electric,PBFieldEffects::Digital].include?(battle.field.field_effects)
    stat = PBStats::SPATK
    battler.pbRaiseStatStageByAbility(stat,1,battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:FLASHFIRE,
  proc { |ability,battler,battle|
    next false if ![PBFieldEffects::Wildfire,PBFieldEffects::Lava].include?(battle.field.field_effects)
    battle.pbShowAbilitySplash(battler)
    if !battler.effects[PBEffects::FlashFire]
      battler.effects[PBEffects::FlashFire] = true
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("The power of {1}'s Fire-type moves rose!",battler.pbThis(true)))
      else
        battle.pbDisplay(_INTL("The power of {1}'s Fire-type moves rose because of its {2}!",
           battler.pbThis(true),battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
    next true
  }
)
