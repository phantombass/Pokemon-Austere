ItemHandlers::UseOnPokemon.add(:ALTERNATESTONE,proc { |item,pkmn,scene|
    if pkmn.shadowPokemon?
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pkmn.form = 1 if pkmn.alternate_stone_able?
    newspecies = pbCheckEvolution(pkmn,item)
    if newspecies<=0
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    else
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn,newspecies)
        evo.pbEvolution(false)
        evo.pbEndScreen
        if scene.is_a?(PokemonPartyScreen)
          scene.pbRefreshAnnotations(proc { |p| pbCheckEvolution(p,item)>0 })
          scene.pbRefresh
        end
      }
      next true
    end
  }
)

class PokeBattle_Pokemon
  def alolan?
    pkmn = [:CUBONE,:EXEGGCUTE,:PIKACHU]
    return pkmn.include?(self.species)
  end

  def galarian?
    pkmn = [:KOFFING,:MIMEJR]
    return pkmn.include?(self.species)
  end

  def hisuian?
    pkmn = [:QUILAVA,:DARTRIX,:DEWOTT,:GOOMY,:RUFFLET,:PETILIL,:BERGMITE]
    return pkmn.include?(self.species)
  end

  def paldean?
    pkmn = [:URSARING]
  end

  def alternate_stone_able?
    return alolan? || galarian? || hisuian?
  end
end