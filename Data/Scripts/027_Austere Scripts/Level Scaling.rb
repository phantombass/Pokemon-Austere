class Level_Scaling
  attr_accessor :gym_leader
  attr_accessor :boss_battle
  attr_accessor :partner
  def initialize
    @gym_leader = false
    @boss_battle = false
    @partner = false
  end

  def self.gym_leader=(value)
    @gym_leader = value
    return @gym_leader
  end

  def self.boss_battle=(value)
    @boss_battle = value
    return @boss_battle
  end

  def self.gym_leader?
    return @gym_leader
  end

  def self.boss_battle?
    return @boss_battle
  end

  def self.partner=(value)
    @partner = value
    return @partner
  end

  def self.partner?
    return @partner
  end

  def self.evolve(pokemon,level,levelcap)
    species = pokemon.species
    newspecies = pbGetBabySpecies(species) # revert to the first evolution
    evoflag=0 #used to track multiple evos not done by lvl
    endevo=false
    loop do #beginning of loop to evolve species
      pkmn = PokeBattle_Pokemon.new(newspecies, level)
      cevo = pbCheckEvolution(pkmn)
      evo = pbGetEvolvedFormData(newspecies)
      if evo
        evo = evo[rand(evo.length - 1)]
        # here we evolve things that don't evolve through level
        # that's what we check with evo[0]!=4
        #notice that such species have cevo==-1 and wouldn't pass the last check
        #to avoid it we set evoflag to 1 (with some randomness) so that
        #pokemon may have its second evolution (Raichu, for example)
        if (evo && cevo < 1) && $Trainer.numbadges > 2
          if evo[0] != 1
          newspecies = evo[2]
             if evoflag == 0
               evoflag=1
             else
               evoflag=0
             end
           end
        else
          endevo=true
        end
      end
      if evoflag==0 || endevo
        if  cevo == -1
          # Breaks if there no more evolutions or randomnly
          # Randomness applies only if the level is under 50
          break
        else
          newspecies = evo[2]
        end
      end
    end #end of loop do
    #fixing some things such as Bellossom would turn into Vileplume
    #check if original species could evolve (Bellosom couldn't)
    couldevo=pbGetEvolvedFormData(species)
    #check if current species can evolve
    evo = pbGetEvolvedFormData(newspecies)
    if evo.length<1 && couldevo.length<1
      return species
    else
      return newspecies
    end #end of evolving script
  end
end

def pbBossBattle
  Level_Scaling.boss_battle = true
end

def pbGymBattle
  Level_Scaling.gym_leader = true
end

def pbTagBattle
  Level_Scaling.partner = true
end

module Level_Scale
  Active = 901
  Boss_Mon = 908

  def self.active?
    return $game_switches[Level_Scale::Active]
  end

  def self.activate
    $game_switches[Level_Scale::Active] = true
  end

  def self.deactivate
    $game_switches[Level_Scale::Active] = false
  end

  def self.boss_mon
    $game_switches[Level_Scale::Boss_Mon] = true
    $game_switches[950] = true
  end
end

Events.onTrainerPartyLoad+=proc {|_sender, e |
  trainer = e[0][0]
  if trainer # Trainer data should exist to be loaded, but may not exist somehow
    party = e[0][2]
    if $PokemonSystem.level_caps == 0 && $Trainer && Level_Scale.active?
       levelcap = LEVEL_CAP[$game_system.level_cap]
       mlv = $Trainer.party.map { |e| e.level  }.max
      for i in 0...party.length
        level = party[i].level
        if Level_Scaling.gym_leader?
          level = levelcap
        else
          level = level
        end
        level = 1 if level<1
        party[i].level = level
        party[i].calcStats
      end
    end
  end
  }
Events.onWildPokemonCreate += proc { |_sender, e|
  pokemon = e[0]
  max_level = $Trainer.party.map { |e| e.level  }.max
  levelcap = LEVEL_CAP[$game_system.level_cap]
  if Level_Scale.active?
    new_level = max_level - 3 - rand(3)   # For variety
    new_level = 1 if new_level < 1
    pokemon.level = new_level
    pokemon.setAbility(rand(3))
    Level_Scaling.evolve(pokemon,new_level,levelcap)
    pokemon.calcStats
    pokemon.resetMoves
  end
  if pokemon.level > levelcap
    $game_switches[950] = true
  end
  if $game_map.map_id == 121 && $game_switches[908]
    pokemon.setAbility(2)
    pokemon.pbLearnMove(:LUNGE)
    pokemon.pbLearnMove(:STORMTHROW)
    pokemon.pbLearnMove(:ROCKTOMB)
    pokemon.pbLearnMove(:QUICKATTACK)
    pokemon.setNature(:ADAMANT)
    PBStats.eachStat {|s| pokemon.iv[s] = 31}
    pokemon.calcStats
  end
  if $game_map.map_id == 137
    pokemon.setAbility(2)
    pokemon.pbLearnMove(:PSYBEAM)
    pokemon.pbLearnMove(:DRAININGKISS)
    pokemon.pbLearnMove(:HPFIGHTING)
    pokemon.pbLearnMove(:PROTECT)
    pokemon.setNature(:TIMID)
    PBStats.eachStat {|s| pokemon.iv[s] = 31}
    pokemon.calcStats
  end
}
