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
