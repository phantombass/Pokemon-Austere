def pbEeveeCheck
  eevee = []
  eevee_flag = false
  $eeveelution = nil
  pbEachPokemon { |poke,_box|
    mon = poke.species
    evo = pbGetBabySpecies(mon)
    evos = pbGetEvolutionFamilyData(mon)
    eevee.push(evo)
    eevee.push(evos)
  }
  if [:EEVEE].include?(eevee)
    eevee_flag = true
  end
  if eevee_flag == true
    pbEachPokemon { |pkmn,_box|
      e = pkmn.species if mon.include?(eevee)
      case e
      when :JOLTEON
        $eeveelution = 1
      when :UMBREON
        $eeveelution = 2
      when :FLAREON
        $eeveelution = 3
      when :LEAFEON
        $eeveelution = 4
      when :SYLVEON
        $eeveelution = 5
      when :VAPOREON
        $eeveelution = 6
      when :GLACEON
        $eeveelution = 7
      when :ESPEON
        $eeveelution = 8
      when :EEVEE
        $eeveelution = 9
      end
    }
  end
end
