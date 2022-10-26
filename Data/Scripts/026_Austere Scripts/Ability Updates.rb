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
