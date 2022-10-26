#===============================================================================
# SpeedCalcItem handlers
#===============================================================================

BattleHandlers::SpeedCalcItem.add(:CHOICESCARF,
  proc { |item,battler,mult|
    next mult*1.5
  }
)

BattleHandlers::SpeedCalcItem.add(:MACHOBRACE,
  proc { |item,battler,mult|
    next mult/2
  }
)

BattleHandlers::SpeedCalcItem.copy(:MACHOBRACE,:POWERANKLET,:POWERBAND,
                                               :POWERBELT,:POWERBRACER,
                                               :POWERLENS,:POWERWEIGHT)

BattleHandlers::SpeedCalcItem.add(:QUICKPOWDER,
  proc { |item,battler,mult|
    next mult*2 if battler.isSpecies?(:DITTO) &&
                   !battler.effects[PBEffects::Transform]
  }
)

BattleHandlers::SpeedCalcItem.add(:IRONBALL,
  proc { |item,battler,mult|
    next mult/2
  }
)

#===============================================================================
# WeightCalcItem handlers
#===============================================================================

BattleHandlers::WeightCalcItem.add(:FLOATSTONE,
  proc { |item,battler,w|
    next [w/2,1].max
  }
)

#===============================================================================
# HPHealItem handlers
#===============================================================================

BattleHandlers::HPHealItem.add(:AGUAVBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleConfusionBerry(battler,battle,item,forced,4,
       _INTL("For {1}, the {2} was too bitter!",battler.pbThis(true),PBItems.getName(item)))
  }
)

BattleHandlers::HPHealItem.add(:APICOTBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleStatIncreasingBerry(battler,battle,item,forced,PBStats::SPDEF)
  }
)

BattleHandlers::HPHealItem.add(:BERRYJUICE,
  proc { |item,battler,battle,forced|
    next false if !battler.canHeal?
    next false if !forced && battler.hp>battler.totalhp/2
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] Forced consuming of #{itemName}") if forced
    battle.pbCommonAnimation("UseItem",battler) if !forced
    battler.pbRecoverHP(20)
    if forced
      battle.pbDisplay(_INTL("{1}'s HP was restored.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} restored its health using its {2}!",battler.pbThis,itemName))
    end
    next true
  }
)

BattleHandlers::HPHealItem.add(:FIGYBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleConfusionBerry(battler,battle,item,forced,0,
       _INTL("For {1}, the {2} was too spicy!",battler.pbThis(true),PBItems.getName(item)))
  }
)

BattleHandlers::HPHealItem.add(:GANLONBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleStatIncreasingBerry(battler,battle,item,forced,PBStats::DEFENSE)
  }
)

BattleHandlers::HPHealItem.add(:IAPAPABERRY,
  proc { |item,battler,battle,forced|
    next pbBattleConfusionBerry(battler,battle,item,forced,1,
       _INTL("For {1}, the {2} was too sour!",battler.pbThis(true),PBItems.getName(item)))
  }
)

BattleHandlers::HPHealItem.add(:LANSATBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && !battler.pbCanConsumeBerry?(item)
    next false if battler.effects[PBEffects::FocusEnergy]>=2
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.effects[PBEffects::FocusEnergy] = 2
    itemName = PBItems.getName(item)
    if forced
      battle.pbDisplay(_INTL("{1} got pumped from the {2}!",battler.pbThis,itemName))
    else
      battle.pbDisplay(_INTL("{1} used its {2} to get pumped!",battler.pbThis,itemName))
    end
    next true
  }
)

BattleHandlers::HPHealItem.add(:LIECHIBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleStatIncreasingBerry(battler,battle,item,forced,PBStats::ATTACK)
  }
)

BattleHandlers::HPHealItem.add(:MAGOBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleConfusionBerry(battler,battle,item,forced,2,
       _INTL("For {1}, the {2} was too sweet!",battler.pbThis(true),PBItems.getName(item)))
  }
)

BattleHandlers::HPHealItem.add(:MICLEBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && !battler.pbCanConsumeBerry?(item)
    next false if !battler.effects[PBEffects::MicleBerry]
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.effects[PBEffects::MicleBerry] = true
    itemName = PBItems.getName(item)
    if forced
      PBDebug.log("[Item triggered] Forced consuming of #{itemName}")
      battle.pbDisplay(_INTL("{1} boosted the accuracy of its next move!",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} boosted the accuracy of its next move using its {2}!",
         battler.pbThis,itemName))
    end
    next true
  }
)

BattleHandlers::HPHealItem.add(:BERRY,
  proc { |item,battler,battle,forced|
    next false if !battler.canHeal?
    next false if !forced && battler.isUnnerved?
    next false if !forced && battler.hp>battler.totalhp/2
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    if battler.hasActiveAbility?(:RIPEN)
      battler.pbRecoverHP(20)
    else
      battler.pbRecoverHP(10)
    end
    itemName = PBItems.getName(item)
    if forced
      PBDebug.log("[Item triggered] Forced consuming of #{itemName}")
      battle.pbDisplay(_INTL("{1}'s HP was restored.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} restored a little HP using its {2}!",battler.pbThis,itemName))
    end
    next true
  }
)

BattleHandlers::HPHealItem.add(:PETAYABERRY,
  proc { |item,battler,battle,forced|
    next pbBattleStatIncreasingBerry(battler,battle,item,forced,PBStats::SPATK)
  }
)

BattleHandlers::HPHealItem.add(:SALACBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleStatIncreasingBerry(battler,battle,item,forced,PBStats::SPEED)
  }
)

BattleHandlers::HPHealItem.add(:GOLDBERRY,
  proc { |item,battler,battle,forced|
    next false if !battler.canHeal?
    next false if !forced && battler.isUnnerved?
    next false if !forced && battler.hp>battler.totalhp/2
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    if battler.hasActiveAbility?(:RIPEN)
      battler.pbRecoverHP?(battler.totalhp/2)
    else
      battler.pbRecoverHP(battler.totalhp/4)
    end
    itemName = PBItems.getName(item)
    if forced
      PBDebug.log("[Item triggered] Forced consuming of #{itemName}")
      battle.pbDisplay(_INTL("{1}'s HP was restored.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} restored its health using its {2}!",battler.pbThis,itemName))
    end
    next true
  }
)

BattleHandlers::HPHealItem.add(:STARFBERRY,
  proc { |item,battler,battle,forced|
    stats = []
    PBStats.eachMainBattleStat { |s| stats.push(s) if battler.pbCanRaiseStatStage?(s,battler) }
    next false if stats.length==0
    stat = stats[battle.pbRandom(stats.length)]
    if battler.hasActiveAbility?(:RIPEN)
      next pbBattleStatIncreasingBerry(battler,battle,item,forced,stat,4)
    else
      next pbBattleStatIncreasingBerry(battler,battle,item,forced,stat,2)
    end
  }
)

BattleHandlers::HPHealItem.add(:WIKIBERRY,
  proc { |item,battler,battle,forced|
    next pbBattleConfusionBerry(battler,battle,item,forced,3,
       _INTL("For {1}, the {2} was too dry!",battler.pbThis(true),PBItems.getName(item)))
  }
)

#===============================================================================
# StatusCureItem handlers
#===============================================================================

BattleHandlers::StatusCureItem.add(:BURNTBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.status!=PBStatuses::FROZEN
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.pbCureStatus(forced)
    battle.pbDisplay(_INTL("{1}'s {2} defrosted it!",battler.pbThis,itemName)) if !forced
    next true
  }
)

BattleHandlers::StatusCureItem.add(:PRZCUREBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.status!=PBStatuses::PARALYSIS
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.pbCureStatus(forced)
    battle.pbDisplay(_INTL("{1}'s {2} cured its paralysis!",battler.pbThis,itemName)) if !forced
    next true
  }
)

BattleHandlers::StatusCureItem.add(:MINTBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.status!=PBStatuses::SLEEP
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.pbCureStatus(forced)
    battle.pbDisplay(_INTL("{1}'s {2} woke it up!",battler.pbThis,itemName)) if !forced
    next true
  }
)

BattleHandlers::StatusCureItem.add(:MIRACLEBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.status==PBStatuses::NONE &&
                  battler.effects[PBEffects::Confusion]==0
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    oldStatus = battler.status
    oldConfusion = (battler.effects[PBEffects::Confusion]>0)
    battler.pbCureStatus(forced)
    battler.pbCureConfusion
    if forced
      battle.pbDisplay(_INTL("{1} snapped out of its confusion.",battler.pbThis)) if oldConfusion
    else
      case oldStatus
      when PBStatuses::SLEEP
        battle.pbDisplay(_INTL("{1}'s {2} woke it up!",battler.pbThis,itemName))
      when PBStatuses::POISON
        battle.pbDisplay(_INTL("{1}'s {2} cured its poisoning!",battler.pbThis,itemName))
      when PBStatuses::BURN
        battle.pbDisplay(_INTL("{1}'s {2} healed its burn!",battler.pbThis,itemName))
      when PBStatuses::PARALYSIS
        battle.pbDisplay(_INTL("{1}'s {2} cured its paralysis!",battler.pbThis,itemName))
      when PBStatuses::FROZEN
        battle.pbDisplay(_INTL("{1}'s {2} defrosted it!",battler.pbThis,itemName))
      end
      if oldConfusion
        battle.pbDisplay(_INTL("{1}'s {2} snapped it out of its confusion!",battler.pbThis,itemName))
      end
    end
    next true
  }
)

BattleHandlers::StatusCureItem.add(:MENTALHERB,
  proc { |item,battler,battle,forced|
    next false if battler.effects[PBEffects::Attract]==-1 &&
                  battler.effects[PBEffects::Taunt]==0 &&
                  battler.effects[PBEffects::Encore]==0 &&
                  !battler.effects[PBEffects::Torment] &&
                  battler.effects[PBEffects::Disable]==0 &&
                  battler.effects[PBEffects::HealBlock]==0
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}")
    battle.pbCommonAnimation("UseItem",battler) if !forced
    if battler.effects[PBEffects::Attract]>=0
      if forced
        battle.pbDisplay(_INTL("{1} got over its infatuation.",battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1} cured its infatuation status using its {2}!",
           battler.pbThis,itemName))
      end
      battler.pbCureAttract
    end
    battle.pbDisplay(_INTL("{1}'s taunt wore off!",battler.pbThis)) if battler.effects[PBEffects::Taunt]>0
    battler.effects[PBEffects::Taunt]      = 0
    battle.pbDisplay(_INTL("{1}'s encore ended!",battler.pbThis)) if battler.effects[PBEffects::Encore]>0
    battler.effects[PBEffects::Encore]     = 0
    battler.effects[PBEffects::EncoreMove] = 0
    battle.pbDisplay(_INTL("{1}'s torment wore off!",battler.pbThis)) if battler.effects[PBEffects::Torment]
    battler.effects[PBEffects::Torment]    = false
    battle.pbDisplay(_INTL("{1} is no longer disabled!",battler.pbThis)) if battler.effects[PBEffects::Disable]>0
    battler.effects[PBEffects::Disable]    = 0
    battle.pbDisplay(_INTL("{1}'s Heal Block wore off!",battler.pbThis)) if battler.effects[PBEffects::HealBlock]>0
    battler.effects[PBEffects::HealBlock]  = 0
    next true
  }
)

BattleHandlers::StatusCureItem.add(:PSNCUREBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.status!=PBStatuses::POISON
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.pbCureStatus(forced)
    battle.pbDisplay(_INTL("{1}'s {2} cured its poisoning!",battler.pbThis,itemName)) if !forced
    next true
  }
)

BattleHandlers::StatusCureItem.add(:BITTERBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.effects[PBEffects::Confusion]==0
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.pbCureConfusion
    if forced
      battle.pbDisplay(_INTL("{1} snapped out of its confusion.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}'s {2} snapped it out of its confusion!",battler.pbThis,
         itemName))
    end
    next true
  }
)

BattleHandlers::StatusCureItem.add(:ICEBERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    next false if battler.status!=PBStatuses::BURN
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    battler.pbCureStatus(forced)
    battle.pbDisplay(_INTL("{1}'s {2} healed its burn!",battler.pbThis,itemName)) if !forced
    next true
  }
)

#===============================================================================
# PriorityBracketChangeItem handlers
#===============================================================================

BattleHandlers::PriorityBracketChangeItem.add(:CUSTAPBERRY,
  proc { |item,battler,subPri,battle|
    next if !battler.pbCanConsumeBerry?(item)
    next 1 if subPri<1 && (!battler.effects[PBEffects::PriorityAbility] && b.hasActiveAbility?(:QUICKDRAW))
  }
)

BattleHandlers::PriorityBracketChangeItem.add(:LAGGINGTAIL,
  proc { |item,battler,subPri,battle|
    next -1 if subPri==0
  }
)

BattleHandlers::PriorityBracketChangeItem.copy(:LAGGINGTAIL,:FULLINCENSE)

BattleHandlers::PriorityBracketChangeItem.add(:QUICKCLAW,
  proc { |item,battler,subPri,battle|
    next 1 if subPri<1 && battle.pbRandom(100)<20 && (!battler.effects[PBEffects::PriorityAbility] && b.hasActiveAbility?(:QUICKDRAW))
  }
)

#===============================================================================
# PriorityBracketUseItem handlers
#===============================================================================

BattleHandlers::PriorityBracketUseItem.add(:CUSTAPBERRY,
  proc { |item,battler,battle|
    battle.pbCommonAnimation("EatBerry",battler)
    battle.pbDisplay(_INTL("{1}'s {2} let it move first!",battler.pbThis,battler.itemName))
    battler.pbConsumeItem
  }
)

BattleHandlers::PriorityBracketUseItem.add(:QUICKCLAW,
  proc { |item,battler,battle|
    battle.pbCommonAnimation("UseItem",battler)
    battle.pbDisplay(_INTL("{1}'s {2} let it move first!",battler.pbThis,battler.itemName))
  }
)

#===============================================================================
# AccuracyCalcUserItem handlers
#===============================================================================

BattleHandlers::AccuracyCalcUserItem.add(:WIDELENS,
  proc { |item,mods,user,target,move,type|
    mods[ACC_MULT] *= 1.1
  }
)

BattleHandlers::AccuracyCalcUserItem.add(:ZOOMLENS,
  proc { |item,mods,user,target,move,type|
    if (target.battle.choices[target.index][0]!=:UseMove &&
       target.battle.choices[target.index][0]!=:Shift) ||
       target.movedThisRound?
      mods[ACC_MULT] *= 1.2
    end
  }
)

#===============================================================================
# AccuracyCalcTargetItem handlers
#===============================================================================

BattleHandlers::AccuracyCalcTargetItem.add(:BRIGHTPOWDER,
  proc { |item,mods,user,target,move,type|
    mods[ACC_MULT] *= 0.9
  }
)

BattleHandlers::AccuracyCalcTargetItem.copy(:BRIGHTPOWDER,:LAXINCENSE)

#===============================================================================
# DamageCalcUserItem handlers
#===============================================================================

BattleHandlers::DamageCalcUserItem.add(:ADAMANTORB,
  proc { |item,user,target,move,mults,baseDmg,type|
    if user.isSpecies?(:DIALGA) &&
       (isConst?(type,PBTypes,:DRAGON) || isConst?(type,PBTypes,:STEEL))
      mults[BASE_DMG_MULT] *= 1.2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:BLACKBELT,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:FIGHTING)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:BLACKBELT,:FISTPLATE)

BattleHandlers::DamageCalcUserItem.add(:BLACKGLASSES,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:DARK)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:BLACKGLASSES,:DREADPLATE)

BattleHandlers::DamageCalcUserItem.add(:BUGGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:BUG,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:CHARCOAL,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:FIRE)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:CHARCOAL,:FLAMEPLATE)

BattleHandlers::DamageCalcUserItem.add(:CHOICEBAND,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.5 if move.physicalMove?
  }
)

BattleHandlers::DamageCalcUserItem.add(:CHOICESPECS,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.5 if move.specialMove?
  }
)

BattleHandlers::DamageCalcUserItem.add(:DARKGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:DARK,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:DEEPSEATOOTH,
  proc { |item,user,target,move,mults,baseDmg,type|
    if user.isSpecies?(:CLAMPERL) && move.specialMove?
      mults[ATK_MULT] *= 2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:DRAGONFANG,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:DRAGON)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:DRAGONFANG,:DRACOPLATE)

BattleHandlers::DamageCalcUserItem.add(:DRAGONGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:DRAGON,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:ELECTRICGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:ELECTRIC,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:EXPERTBELT,
  proc { |item,user,target,move,mults,baseDmg,type|
    if PBTypes.superEffective?(target.damageState.typeMod)
      mults[FINAL_DMG_MULT] *= 1.2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:FAIRYGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:FAIRY,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:FIGHTINGGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:FIGHTING,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:FIREGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:FIRE,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:FLYINGGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:FLYING,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:GHOSTGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:GHOST,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:GRASSGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:GRASS,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:GRISEOUSORB,
  proc { |item,user,target,move,mults,baseDmg,type|
    if user.isSpecies?(:GIRATINA) &&
       (isConst?(type,PBTypes,:DRAGON) || isConst?(type,PBTypes,:GHOST))
      mults[BASE_DMG_MULT] *= 1.2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:GROUNDGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:GROUND,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:HARDSTONE,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:ROCK)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:HARDSTONE,:STONEPLATE,:ROCKINCENSE)

BattleHandlers::DamageCalcUserItem.add(:ICEGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:ICE,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:LIFEORB,
  proc { |item,user,target,move,mults,baseDmg,type|
    if !move.is_a?(PokeBattle_Confusion)
      mults[FINAL_DMG_MULT] *= 1.3
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:LIGHTBALL,
  proc { |item,user,target,move,mults,baseDmg,type|
    if user.isSpecies?(:PIKACHU)
      mults[ATK_MULT] *= 2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:LUSTROUSORB,
  proc { |item,user,target,move,mults,baseDmg,type|
    if user.isSpecies?(:PALKIA) &&
       (isConst?(type,PBTypes,:DRAGON) || isConst?(type,PBTypes,:WATER))
      mults[BASE_DMG_MULT] *= 1.2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:MAGNET,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:ELECTRIC)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:MAGNET,:ZAPPLATE)

BattleHandlers::DamageCalcUserItem.add(:METALCOAT,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:STEEL)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:METALCOAT,:IRONPLATE)

BattleHandlers::DamageCalcUserItem.add(:METRONOME,
  proc { |item,user,target,move,mults,baseDmg,type|
    met = 1+0.2*[user.effects[PBEffects::Metronome],5].min
    mults[FINAL_DMG_MULT] *= met
  }
)

BattleHandlers::DamageCalcUserItem.add(:MIRACLESEED,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:GRASS)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:MIRACLESEED,:MEADOWPLATE,:ROSEINCENSE)

BattleHandlers::DamageCalcUserItem.add(:MUSCLEBAND,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.1 if move.physicalMove?
  }
)

BattleHandlers::DamageCalcUserItem.add(:MYSTICWATER,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:WATER)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:MYSTICWATER,:SPLASHPLATE,:SEAINCENSE,:WAVEINCENSE)

BattleHandlers::DamageCalcUserItem.add(:NEVERMELTICE,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:ICE)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:NEVERMELTICE,:ICICLEPLATE)

BattleHandlers::DamageCalcUserItem.add(:NORMALGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:NORMAL,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:PIXIEPLATE,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:FAIRY)
  }
)

BattleHandlers::DamageCalcUserItem.add(:POISONBARB,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:POISON)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:POISONBARB,:TOXICPLATE)

BattleHandlers::DamageCalcUserItem.add(:POISONGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:POISON,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:PSYCHICGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:PSYCHIC,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:ROCKGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:ROCK,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:SHARPBEAK,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:FLYING)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:SHARPBEAK,:SKYPLATE)

BattleHandlers::DamageCalcUserItem.add(:SILKSCARF,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:NORMAL)
  }
)

BattleHandlers::DamageCalcUserItem.add(:SILVERPOWDER,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:BUG)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:SILVERPOWDER,:INSECTPLATE)

BattleHandlers::DamageCalcUserItem.add(:SOFTSAND,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:GROUND)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:SOFTSAND,:EARTHPLATE)

BattleHandlers::DamageCalcUserItem.add(:SOULDEW,
  proc { |item,user,target,move,mults,baseDmg,type|
    next if !user.isSpecies?(:LATIAS) && !user.isSpecies?(:LATIOS)
    if NEWEST_BATTLE_MECHANICS
      if isConst?(type,PBTypes,:PSYCHIC) || isConst?(type,PBTypes,:DRAGON)
        mults[FINAL_DMG_MULT] *= 1.2
      end
    else
      if move.specialMove? && !user.battle.rules["souldewclause"]
        mults[ATK_MULT] *= 1.5
      end
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:SPELLTAG,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:GHOST)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:SPELLTAG,:SPOOKYPLATE)

BattleHandlers::DamageCalcUserItem.add(:STEELGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:STEEL,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:THICKCLUB,
  proc { |item,user,target,move,mults,baseDmg,type|
    if (user.isSpecies?(:CUBONE) || user.isSpecies?(:MAROWAK)) && move.physicalMove?
      mults[ATK_MULT] *= 2
    end
  }
)

BattleHandlers::DamageCalcUserItem.add(:TWISTEDSPOON,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.2 if isConst?(type,PBTypes,:PSYCHIC)
  }
)

BattleHandlers::DamageCalcUserItem.copy(:TWISTEDSPOON,:MINDPLATE,:ODDINCENSE)

BattleHandlers::DamageCalcUserItem.add(:WATERGEM,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleGem(user,:WATER,move,mults,type)
  }
)

BattleHandlers::DamageCalcUserItem.add(:WISEGLASSES,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[BASE_DMG_MULT] *= 1.1 if move.specialMove?
  }
)

#===============================================================================
# DamageCalcTargetItem handlers
#===============================================================================
# NOTE: Species-specific held items consider the original species, not the
#       transformed species, and still work while transformed. The exceptions
#       are Metal/Quick Powder, which don't work if the holder is transformed.

BattleHandlers::DamageCalcTargetItem.add(:ASSAULTVEST,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[DEF_MULT] *= 1.5 if move.specialMove?
  }
)

BattleHandlers::DamageCalcTargetItem.add(:BABIRIBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:STEEL,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:CHARTIBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:ROCK,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:CHILANBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:NORMAL,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:CHOPLEBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:FIGHTING,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:COBABERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:FLYING,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:COLBURBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:DARK,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:DEEPSEASCALE,
  proc { |item,user,target,move,mults,baseDmg,type|
    if target.isSpecies?(:CLAMPERL) && move.specialMove?
      mults[DEF_MULT] *= 2
    end
  }
)

BattleHandlers::DamageCalcTargetItem.add(:EVIOLITE,
  proc { |item,user,target,move,mults,baseDmg,type|
    # NOTE: Eviolite cares about whether the Pokémon itself can evolve, which
    #       means it also cares about the Pokémon's form. Some forms cannot
    #       evolve even if the species generally can, and such forms are not
    #       affected by Eviolite.
    evos = pbGetEvolvedFormData(target.pokemon.fSpecies,true)
    mults[DEF_MULT] *= 1.5 if evos && evos.length>0
  }
)

BattleHandlers::DamageCalcTargetItem.add(:HABANBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:DRAGON,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:KASIBBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:GHOST,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:KEBIABERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:POISON,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:METALPOWDER,
  proc { |item,user,target,move,mults,baseDmg,type|
    if target.isSpecies?(:DITTO) && !target.effects[PBEffects::Transform]
      mults[DEF_MULT] *= 1.5
    end
  }
)

BattleHandlers::DamageCalcTargetItem.add(:OCCABERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:FIRE,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:PASSHOBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:WATER,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:PAYAPABERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:PSYCHIC,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:RINDOBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:GRASS,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:ROSELIBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:FAIRY,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:SHUCABERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:GROUND,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:SOULDEW,
  proc { |item,user,target,move,mults,baseDmg,type|
    next if NEWEST_BATTLE_MECHANICS
    next if !target.isSpecies?(:LATIAS) && !target.isSpecies?(:LATIOS)
    if move.specialMove? && !user.battle.rules["souldewclause"]
      mults[DEF_MULT] *= 1.5
    end
  }
)

BattleHandlers::DamageCalcTargetItem.add(:TANGABERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:BUG,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:WACANBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:ELECTRIC,type,target,mults)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:YACHEBERRY,
  proc { |item,user,target,move,mults,baseDmg,type|
    pbBattleTypeWeakingBerry(:ICE,type,target,mults)
  }
)

#===============================================================================
# CriticalCalcUserItem handlers
#===============================================================================

BattleHandlers::CriticalCalcUserItem.add(:LUCKYPUNCH,
  proc { |item,user,target,c|
    next c+2 if user.isSpecies?(:CHANSEY)
  }
)

BattleHandlers::CriticalCalcUserItem.add(:RAZORCLAW,
  proc { |item,user,target,c|
    next c+1
  }
)

BattleHandlers::CriticalCalcUserItem.copy(:RAZORCLAW,:SCOPELENS)

BattleHandlers::CriticalCalcUserItem.add(:LEEK,
  proc { |item,user,target,c|
    next c+2 if user.isSpecies?(:FARFETCHD) || user.isSpecies?(:SIRFETCHD)
  }
)

#===============================================================================
# CriticalCalcTargetItem handlers
#===============================================================================

# There aren't any!

#===============================================================================
# TargetItemOnHit handlers
#===============================================================================

BattleHandlers::TargetItemOnHit.add(:ABSORBBULB,
  proc { |item,user,target,move,battle|
    next if !isConst?(move.calcType,PBTypes,:WATER)
    next if !target.pbCanRaiseStatStage?(PBStats::SPATK,target)
    battle.pbCommonAnimation("UseItem",target)
    target.pbRaiseStatStageByCause(PBStats::SPATK,1,target,target.itemName)
    target.pbHeldItemTriggered(item)
  }
)

BattleHandlers::TargetItemOnHit.add(:AIRBALLOON,
  proc { |item,user,target,move,battle|
    battle.pbDisplay(_INTL("{1}'s {2} popped!",target.pbThis,target.itemName))
    target.pbConsumeItem(false,true)
    target.pbSymbiosis
  }
)

BattleHandlers::TargetItemOnHit.add(:CELLBATTERY,
  proc { |item,user,target,move,battle|
    next if !isConst?(move.calcType,PBTypes,:ELECTRIC)
    next if !target.pbCanRaiseStatStage?(PBStats::ATTACK,target)
    battle.pbCommonAnimation("UseItem",target)
    target.pbRaiseStatStageByCause(PBStats::ATTACK,1,target,target.itemName)
    target.pbHeldItemTriggered(item)
  }
)

BattleHandlers::TargetItemOnHit.add(:ENIGMABERRY,
  proc { |item,user,target,move,battle|
    next if target.damageState.substitute || target.damageState.disguise || target.damageState.iceface
    next if !PBTypes.superEffective?(target.damageState.typeMod)
    if BattleHandlers.triggerTargetItemOnHitPositiveBerry(item,target,battle,false)
      target.pbHeldItemTriggered(item)
    end
  }
)

BattleHandlers::TargetItemOnHit.add(:JABOCABERRY,
  proc { |item,user,target,move,battle|
    next if battle.pbCheckOpposingAbility(:UNNERVE,target.index)
    next if !move.physicalMove?
    next if !user.takesIndirectDamage?
    battle.pbCommonAnimation("EatBerry",target)
    battle.scene.pbDamageAnimation(user)
    if target.hasActiveAbility?(:RIPEN)
      user.pbReduceHP(user.totalhp/4,false)
    else
      user.pbReduceHP(user.totalhp/8,false)
    end
    battle.pbDisplay(_INTL("{1} consumed its {2} and hurt {3}!",target.pbThis,
       target.itemName,user.pbThis(true)))
    target.pbHeldItemTriggered(item)
  }
)

# NOTE: Kee Berry supposedly shouldn't trigger if the user has Sheer Force, but
#       I'm ignoring this. Weakness Policy has the same kind of effect and
#       nowhere says it should be stopped by Sheer Force. I suspect this
#       stoppage is either a false report that no one ever corrected, or an
#       effect that later changed and wasn't noticed.
BattleHandlers::TargetItemOnHit.add(:KEEBERRY,
  proc { |item,user,target,move,battle|
    next if !move.physicalMove?
    if BattleHandlers.triggerTargetItemOnHitPositiveBerry(item,target,battle,false)
      target.pbHeldItemTriggered(item)
    end
  }
)

BattleHandlers::TargetItemOnHit.add(:LUMINOUSMOSS,
  proc { |item,user,target,move,battle|
    next if !isConst?(move.calcType,PBTypes,:WATER)
    next if !target.pbCanRaiseStatStage?(PBStats::SPDEF,target)
    battle.pbCommonAnimation("UseItem",target)
    target.pbRaiseStatStageByCause(PBStats::SPDEF,1,target,target.itemName)
    target.pbHeldItemTriggered(item)
  }
)

# NOTE: Maranga Berry supposedly shouldn't trigger if the user has Sheer Force,
#       but I'm ignoring this. Weakness Policy has the same kind of effect and
#       nowhere says it should be stopped by Sheer Force. I suspect this
#       stoppage is either a false report that no one ever corrected, or an
#       effect that later changed and wasn't noticed.
BattleHandlers::TargetItemOnHit.add(:MARANGABERRY,
  proc { |item,user,target,move,battle|
    next if !move.specialMove?
    if BattleHandlers.triggerTargetItemOnHitPositiveBerry(item,target,battle,false)
      target.pbHeldItemTriggered(item)
    end
  }
)

BattleHandlers::TargetItemOnHit.add(:ROCKYHELMET,
  proc { |item,user,target,move,battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if !user.takesIndirectDamage?
    battle.scene.pbDamageAnimation(user)
    user.pbReduceHP(user.totalhp/6,false)
    battle.pbDisplay(_INTL("{1} was hurt by the {2}!",user.pbThis,target.itemName))
  }
)

BattleHandlers::TargetItemOnHit.add(:ROWAPBERRY,
  proc { |item,user,target,move,battle|
    next if battle.pbCheckOpposingAbility(:UNNERVE,target.index)
    next if !move.specialMove?
    next if !user.takesIndirectDamage?
    battle.pbCommonAnimation("EatBerry",target)
    battle.scene.pbDamageAnimation(user)
    if target.hasActiveAbility?(:RIPEN)
      user.pbReduceHP(user.totalhp/4,false)
    else
      user.pbReduceHP(user.totalhp/8,false)
    end
    battle.pbDisplay(_INTL("{1} consumed its {2} and hurt {3}!",target.pbThis,
       target.itemName,user.pbThis(true)))
    target.pbHeldItemTriggered(item)
  }
)

BattleHandlers::TargetItemOnHit.add(:SNOWBALL,
  proc { |item,user,target,move,battle|
    next if !isConst?(move.calcType,PBTypes,:ICE)
    next if !target.pbCanRaiseStatStage?(PBStats::ATTACK,target)
    battle.pbCommonAnimation("UseItem",target)
    target.pbRaiseStatStageByCause(PBStats::ATTACK,1,target,target.itemName)
    target.pbHeldItemTriggered(item)
  }
)

BattleHandlers::TargetItemOnHit.add(:STICKYBARB,
  proc { |item,user,target,move,battle|
    next if !move.pbContactMove?(user) || !user.affectedByContactEffect?
    next if user.fainted? || user.item>0
    user.item = target.item
    target.item = 0
    target.effects[PBEffects::Unburden] = true
    if battle.wildBattle? && !user.opposes?
      if user.initialItem==0 && target.initialItem==user.item
        user.setInitialItem(user.item)
        target.setInitialItem(0)
      end
    end
    battle.pbDisplay(_INTL("{1}'s {2} was transferred to {3}!",
       target.pbThis,user.itemName,user.pbThis(true)))
  }
)

BattleHandlers::TargetItemOnHit.add(:WEAKNESSPOLICY,
  proc { |item,user,target,move,battle|
    next if target.damageState.disguise || target.damageState.iceface
    next if !PBTypes.superEffective?(target.damageState.typeMod)
    next if !target.pbCanRaiseStatStage?(PBStats::ATTACK,target) &&
            !target.pbCanRaiseStatStage?(PBStats::SPATK,target)
    battle.pbCommonAnimation("UseItem",target)
    showAnim = true
    if target.pbCanRaiseStatStage?(PBStats::ATTACK,target)
      target.pbRaiseStatStageByCause(PBStats::ATTACK,2,target,target.itemName,showAnim)
      showAnim = false
    end
    if target.pbCanRaiseStatStage?(PBStats::SPATK,target)
      target.pbRaiseStatStageByCause(PBStats::SPATK,2,target,target.itemName,showAnim)
    end
    target.pbHeldItemTriggered(item)
  }
)

#===============================================================================
# TargetItemOnHitPositiveBerry handlers
# NOTE: This is for berries that have an effect when Pluck/Bug Bite/Fling
#       forces their use.
#===============================================================================

BattleHandlers::TargetItemOnHitPositiveBerry.add(:ENIGMABERRY,
  proc { |item,battler,battle,forced|
    next false if !battler.canHeal?
    next false if !forced && battler.isUnnerved?
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    if battler.hasActiveAbility?(:RIPEN)
      battler.pbRecoverHP(battler.totalhp/2)
    else
      battler.pbRecoverHP(battler.totalhp/4)
    end
    if forced
      battle.pbDisplay(_INTL("{1}'s HP was restored.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} restored its health using its {2}!",battler.pbThis,
         itemName))
    end
    next true
  }
)

BattleHandlers::TargetItemOnHitPositiveBerry.add(:KEEBERRY,
  proc { |item,battler,battle,forced|
    increment=1
    next false if !forced && battler.isUnnerved?
    next false if !battler.pbCanRaiseStatStage?(PBStats::DEFENSE,battler)
    itemName = PBItems.getName(item)
    if battler.hasActiveAbility?(:RIPEN)
      increment *=2
    end
    if !forced
      battle.pbCommonAnimation("EatBerry",battler)
      next battler.pbRaiseStatStageByCause(PBStats::DEFENSE,increment,battler,itemName)
    end
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}")
    next battler.pbRaiseStatStage(PBStats::DEFENSE,increment,battler)
  }
)

BattleHandlers::TargetItemOnHitPositiveBerry.add(:MARANGABERRY,
  proc { |item,battler,battle,forced|
    increment=1
    next false if !forced && battler.isUnnerved?
    next false if !battler.pbCanRaiseStatStage?(PBStats::SPDEF,battler)
    itemName = PBItems.getName(item)
    if battler.hasActiveAbility?(:RIPEN)
      increment*=2
    end
    if !forced
      battle.pbCommonAnimation("EatBerry",battler)
      next battler.pbRaiseStatStageByCause(PBStats::SPDEF,increment,battler,itemName)
    end
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}")
    next battler.pbRaiseStatStage(PBStats::SPDEF,increment,battler)
  }
)

#===============================================================================
# TargetItemAfterMoveUse handlers
#===============================================================================

BattleHandlers::TargetItemAfterMoveUse.add(:EJECTBUTTON,
  proc { |item,battler,user,move,switched,battle|
    next if battle.pbAllFainted?(battler.idxOpposingSide)
    next if !battle.pbCanChooseNonActive?(battler.index)
    battle.pbCommonAnimation("UseItem",battler)
    battle.pbDisplay(_INTL("{1} is switched out with the {2}!",battler.pbThis,battler.itemName))
    battler.pbConsumeItem(true,false)
    newPkmn = battle.pbGetReplacementPokemonIndex(battler.index)   # Owner chooses
    next if newPkmn<0
    battle.pbRecallAndReplace(battler.index,newPkmn)
    battle.pbClearChoice(battler.index)   # Replacement Pokémon does nothing this round
    switched.push(battler.index)
  }
)

BattleHandlers::TargetItemAfterMoveUse.add(:REDCARD,
  proc { |item,battler,user,move,switched,battle|
    next if user.fainted? || switched.include?(user.index)
    newPkmn = battle.pbGetReplacementPokemonIndex(user.index,true)   # Random
    next if newPkmn<0
    battle.pbCommonAnimation("UseItem",battler)
    battle.pbDisplay(_INTL("{1} held up its {2} against {3}!",
       battler.pbThis,battler.itemName,user.pbThis(true)))
    battler.pbConsumeItem
    battle.pbRecallAndReplace(user.index, newPkmn, true)
    battle.pbDisplay(_INTL("{1} was dragged out!",user.pbThis))
    battle.pbClearChoice(user.index)   # Replacement Pokémon does nothing this round
    switched.push(user.index)
  }
)

#===============================================================================
# UserItemAfterMoveUse handlers
#===============================================================================

BattleHandlers::UserItemAfterMoveUse.add(:LIFEORB,
  proc { |item,user,targets,move,numHits,battle|
    next if !user.takesIndirectDamage?
    next if !move.pbDamagingMove? || numHits==0
    hitBattler = false
    targets.each do |b|
      hitBattler = true if !b.damageState.unaffected && !b.damageState.substitute
      break if hitBattler
    end
    next if !hitBattler
    PBDebug.log("[Item triggered] #{user.pbThis}'s #{user.itemName} (recoil)")
    user.pbReduceHP(user.totalhp/10)
    battle.pbDisplay(_INTL("{1} lost some of its HP!",user.pbThis))
    user.pbItemHPHealCheck
    user.pbFaint if user.fainted?
  }
)

BattleHandlers::UserItemAfterMoveUse.add(:SHELLBELL,
  proc { |item,user,targets,move,numHits,battle|
    next if !user.canHeal?
    totalDamage = 0
    targets.each { |b| totalDamage += b.damageState.totalHPLost }
    next if totalDamage<=0
    user.pbRecoverHP(totalDamage/8)
    battle.pbDisplay(_INTL("{1} restored a little HP using its {2}!",
       user.pbThis,user.itemName))
  }
)

BattleHandlers::UserItemAfterMoveUse.add(:THROATSPRAY,
  proc { |item,user,targets,move,numHits,battle|
    next if !move.soundMove? || numHits==0
    next if !user.pbCanRaiseStatStage?(PBStats::SPATK,user)
    battle.pbCommonAnimation("UseItem",user)
    showAnim = true
    user.pbRaiseStatStageByCause(PBStats::SPATK,1,user,user.itemName,showAnim)
    user.pbConsumeItem
  }
)

#===============================================================================
# EndOfMoveItem handlers
#===============================================================================

BattleHandlers::EndOfMoveItem.add(:LEPPABERRY,
  proc { |item,battler,battle,forced|
    next false if !forced && battler.isUnnerved?
    found = []
    battler.pokemon.moves.each_with_index do |m,i|
      next if !m || m.id==0
      next if m.totalpp<=0 || m.pp==m.totalpp
      next if !forced && m.pp>0
      found.push(i)
    end
    next false if found.length==0
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("EatBerry",battler) if !forced
    choice = found[battle.pbRandom(found.length)]
    pkmnMove = battler.pokemon.moves[choice]
    pkmnMove.pp += 10
    pkmnMove.pp = pkmnMove.totalpp if pkmnMove.pp>pkmnMove.totalpp
    battler.moves[choice].pp = pkmnMove.pp
    moveName = PBMoves.getName(pkmnMove.id)
    if forced
      battle.pbDisplay(_INTL("{1} restored its {2}'s PP.",battler.pbThis,moveName))
    else
      battle.pbDisplay(_INTL("{1}'s {2} restored its {3}'s PP!",battler.pbThis,itemName,moveName))
    end
    next true
  }
)

#===============================================================================
# EndOfMoveStatRestoreItem handlers
#===============================================================================

BattleHandlers::EndOfMoveStatRestoreItem.add(:WHITEHERB,
  proc { |item,battler,battle,forced|
    reducedStats = false
    PBStats.eachBattleStat do |s|
      next if battler.stages[s]>=0
      battler.stages[s] = 0
      reducedStats = true
    end
    next false if !reducedStats
    itemName = PBItems.getName(item)
    PBDebug.log("[Item triggered] #{battler.pbThis}'s #{itemName}") if forced
    battle.pbCommonAnimation("UseItem",battler) if !forced
    if forced
      battle.pbDisplay(_INTL("{1}'s status returned to normal!",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} returned its status to normal using its {2}!",
         battler.pbThis,itemName))
    end
    next true
  }
)

#===============================================================================
# ExpGainModifierItem handlers
#===============================================================================

BattleHandlers::ExpGainModifierItem.add(:LUCKYEGG,
  proc { |item,battler,exp|
    next exp*3/2
  }
)

#===============================================================================
# EVGainModifierItem handlers
#===============================================================================

BattleHandlers::EVGainModifierItem.add(:MACHOBRACE,
  proc { |item,battler,evYield|
    evYield.collect! { |a| a*2 }
  }
)

BattleHandlers::EVGainModifierItem.add(:POWERANKLET,
  proc { |item,battler,evYield|
    evYield[PBStats::SPEED] += 4
  }
)

BattleHandlers::EVGainModifierItem.add(:POWERBAND,
  proc { |item,battler,evYield|
    evYield[PBStats::SPDEF] += 4
  }
)

BattleHandlers::EVGainModifierItem.add(:POWERBELT,
  proc { |item,battler,evYield|
    evYield[PBStats::DEFENSE] += 4
  }
)

BattleHandlers::EVGainModifierItem.add(:POWERBRACER,
  proc { |item,battler,evYield|
    evYield[PBStats::ATTACK] += 4
  }
)

BattleHandlers::EVGainModifierItem.add(:POWERLENS,
  proc { |item,battler,evYield|
    evYield[PBStats::SPATK] += 4
  }
)

BattleHandlers::EVGainModifierItem.add(:POWERWEIGHT,
  proc { |item,battler,evYield|
    evYield[PBStats::HP] += 4
  }
)

#===============================================================================
# WeatherExtenderItem handlers
#===============================================================================

BattleHandlers::WeatherExtenderItem.add(:DAMPROCK,
  proc { |item,weather,duration,battler,battle|
    next 8 if weather==PBWeather::Rain
  }
)

BattleHandlers::WeatherExtenderItem.add(:HEATROCK,
  proc { |item,weather,duration,battler,battle|
    next 8 if weather==PBWeather::Sun
  }
)

BattleHandlers::WeatherExtenderItem.add(:ICYROCK,
  proc { |item,weather,duration,battler,battle|
    next 8 if weather==PBWeather::Hail
  }
)

BattleHandlers::WeatherExtenderItem.add(:SMOOTHROCK,
  proc { |item,weather,duration,battler,battle|
    next 8 if weather==PBWeather::Sandstorm
  }
)

#===============================================================================
# TerrainExtenderItem handlers
#===============================================================================

BattleHandlers::TerrainExtenderItem.add(:TERRAINEXTENDER,
  proc { |item,terrain,duration,battler,battle|
    next 8
  }
)

#===============================================================================
# TerrainStatBoostItem handlers
#===============================================================================

BattleHandlers::TerrainStatBoostItem.add(:ELECTRICSEED,
  proc { |item,battler,battle|
    next false if battle.field.terrain!=PBBattleTerrains::Electric
    next false if !battler.pbCanRaiseStatStage?(PBStats::DEFENSE,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::DEFENSE,1,battler,itemName)
  }
)

BattleHandlers::TerrainStatBoostItem.add(:GRASSYSEED,
  proc { |item,battler,battle|
    next false if battle.field.terrain!=PBBattleTerrains::Grassy
    next false if !battler.pbCanRaiseStatStage?(PBStats::DEFENSE,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::DEFENSE,1,battler,itemName)
  }
)

BattleHandlers::TerrainStatBoostItem.add(:MISTYSEED,
  proc { |item,battler,battle|
    next false if battle.field.terrain!=PBBattleTerrains::Misty
    next false if !battler.pbCanRaiseStatStage?(PBStats::SPDEF,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::SPDEF,1,battler,itemName)
  }
)

BattleHandlers::TerrainStatBoostItem.add(:PSYCHICSEED,
  proc { |item,battler,battle|
    next false if battle.field.terrain!=PBBattleTerrains::Psychic
    next false if !battler.pbCanRaiseStatStage?(PBStats::SPDEF,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::SPDEF,1,battler,itemName)
  }
)

#===============================================================================
# EORHealingItem handlers
#===============================================================================

BattleHandlers::EORHealingItem.add(:BLACKSLUDGE,
  proc { |item,battler,battle|
    if battler.pbHasType?(:POISON)
      next if !battler.canHeal?
      battle.pbCommonAnimation("UseItem",battler)
      battler.pbRecoverHP(battler.totalhp/16)
      battle.pbDisplay(_INTL("{1} restored a little HP using its {2}!",
         battler.pbThis,battler.itemName))
    elsif battler.takesIndirectDamage?
      oldHP = battler.hp
      battle.pbCommonAnimation("UseItem",battler)
      battler.pbReduceHP(battler.totalhp/8)
      battle.pbDisplay(_INTL("{1} is hurt by its {2}!",battler.pbThis,battler.itemName))
      battler.pbItemHPHealCheck
      battler.pbAbilitiesOnDamageTaken(oldHP)
      battler.pbFaint if battler.fainted?
    end
  }
)

BattleHandlers::EORHealingItem.add(:LEFTOVERS,
  proc { |item,battler,battle|
    next if !battler.canHeal?
    battle.pbCommonAnimation("UseItem",battler)
    battler.pbRecoverHP(battler.totalhp/16)
    battle.pbDisplay(_INTL("{1} restored a little HP using its {2}!",
       battler.pbThis,battler.itemName))
  }
)

#===============================================================================
# EOREffectItem handlers
#===============================================================================

BattleHandlers::EOREffectItem.add(:FLAMEORB,
  proc { |item,battler,battle|
    next if !battler.pbCanBurn?(nil,false)
    battler.pbBurn(nil,_INTL("{1} was burned by the {2}!",battler.pbThis,battler.itemName))
  }
)

BattleHandlers::EOREffectItem.add(:STICKYBARB,
  proc { |item,battler,battle|
    next if !battler.takesIndirectDamage?
    oldHP = battler.hp
    battle.scene.pbDamageAnimation(battler)
    battler.pbReduceHP(battler.totalhp/8,false)
    battle.pbDisplay(_INTL("{1} is hurt by its {2}!",battler.pbThis,battler.itemName))
    battler.pbItemHPHealCheck
    battler.pbAbilitiesOnDamageTaken(oldHP)
    battler.pbFaint if battler.fainted?
  }
)

BattleHandlers::EOREffectItem.add(:TOXICORB,
  proc { |item,battler,battle|
    next if !battler.pbCanPoison?(nil,false)
    battler.pbPoison(nil,_INTL("{1} was badly poisoned by the {2}!",
       battler.pbThis,battler.itemName),true)
  }
)

#===============================================================================
# CertainSwitchingUserItem handlers
#===============================================================================

BattleHandlers::CertainSwitchingUserItem.add(:SHEDSHELL,
  proc { |item,battler,battle|
    next true
  }
)

#===============================================================================
# TrappingTargetItem handlers
#===============================================================================

# There aren't any!


#===============================================================================
# ItemOnSwitchIn handlers
#===============================================================================

BattleHandlers::ItemOnSwitchIn.add(:AIRBALLOON,
  proc { |item,battler,battle|
    battle.pbDisplay(_INTL("{1} floats in the air with its {2}!",
       battler.pbThis,battler.itemName))
  }
)

BattleHandlers::ItemOnSwitchIn.add(:ROOMSERVICE,
  proc { |item,battler,battle|
    next if battle.field.effects[PBEffects::TrickRoom] == 0
    next if !battler.pbCanLowerStatStage?(PBStats::SPEED,battler)
    battler.pbLowerStatStageByCause(PBStats::SPEED,1,battler,battler.itemName)
    battler.pbConsumeItem
  }
)

#===============================================================================
# ItemOnIntimidated handlers
#===============================================================================

BattleHandlers::ItemOnIntimidated.add(:ADRENALINEORB,
  proc { |item,battler,battle|
    next false if !battler.pbCanRaiseStatStage?(PBStats::SPEED,battler)
    itemName = PBItems.getName(item)
    battle.pbCommonAnimation("UseItem",battler)
    next battler.pbRaiseStatStageByCause(PBStats::SPEED,1,battler,itemName)
  }
)

#===============================================================================
# RunFromBattleItem handlers
#===============================================================================

BattleHandlers::RunFromBattleItem.add(:SMOKEBALL,
  proc { |item,battler|
    next true
  }
)


#===============================================================================
# ItemOnStatLoss handlers
#===============================================================================

BattleHandlers::ItemOnStatLoss.add(:EJECTPACK,
  proc { |item,battler,user,move,switched,battle|
    next if battle.pbAllFainted?(battler.idxOpposingSide)
    next if !battle.pbCanChooseNonActive?(battler.index)
	next if move.function=="0EE" # U-Turn, Volt-Switch, Flip Turn
	next if move.function=="151" # Parting Shot
    battle.pbCommonAnimation("UseItem",battler)
    battle.pbDisplay(_INTL("{1} is switched out with the {2}!",battler.pbThis,battler.itemName))
    battler.pbConsumeItem(true,false)
    newPkmn = battle.pbGetReplacementPokemonIndex(battler.index)   # Owner chooses
    next if newPkmn<0
    battle.pbRecallAndReplace(battler.index,newPkmn)
    battle.pbClearChoice(battler.index)   # Replacement Pokémon does nothing this round
    switched.push(battler.index)
  }
)
