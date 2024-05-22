class PokeBattle_AI
  def pbCalcTypeModPokemon(battlerThis,target)
    mod1 = PBTypes.getCombinedEffectiveness(battlerThis.type1,target.type1,target.type2)
    mod2 = PBTypeEffectiveness::NORMAL_EFFECTIVE
    if battlerThis.type1!=battlerThis.type2
      mod2 = PBTypes.getCombinedEffectiveness(battlerThis.type2,target.type1,target.type2)
    end
    return mod1*mod2   # Normal effectiveness is 64 here
  end
end

class PokeBattle_Battler
  def trappedInBattle?
    return true if @effects[PBEffects::Trapping] > 0
    return true if @effects[PBEffects::MeanLook] >= 0
    return true if @effects[PBEffects::Ingrain]
    return true if @battle.field.effects[PBEffects::FairyLock] > 0
  end
end

#===============================================================================
# Power is doubled if the target has already moved this round. (Payback)
#===============================================================================
class PokeBattle_Move_084 < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    ind = target.index != nil ? target.index : 1
    if @battle.choices[ind][0]!=:None &&
       ((@battle.choices[ind][0]!=:UseMove &&
       @battle.choices[ind][0]!=:Shift) || target.movedThisRound?)
      baseDmg *= 2
    end
    return baseDmg
  end
end