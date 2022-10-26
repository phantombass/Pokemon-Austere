class Level_Scaling
  attr_accessor :gym_leader
  attr_accessor :boss_battle
  def initialize
    @gym_leader = false
    @boss_battle = false
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
        if evo && cevo < 1
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

module Level_Scale
  Active = 901

  def self.active?
    return $game_switches[Level_Scale::Active]
  end

  def self.activate
    $game_switches[Level_Scale::Active] = true
  end

  def self.deactivate
    $game_switches[Level_Scale::Active] = false
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
        level = 0
        level=1 if level<1
        if Level_Scaling.gym_leader?
          level = levelcap
        elsif Level_Scaling.boss_battle?
          level = levelcap - 1
        else
          level = mlv - 2 -rand(2)
        end
        level = 1 if level<1
        party[i].level = level
        party[i].calcStats
        if !Level_Scaling.gym_leader? && !Level_Scaling.boss_battle?
          party[i].species = Level_Scaling.evolve(party[i],level,levelcap)
          party[i].resetMoves
        end
      end
    end
  end
  }
