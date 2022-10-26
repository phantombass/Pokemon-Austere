def pbInfiniteRepel
  $inf_repel += 1
  $inf_repel = 0 if $inf_repel >= REPEL_STAGES.size
  $PokemonGlobal.repel = REPEL_STAGES[$inf_repel]
  $PokemonGlobal.repel == 0 ? pbMessage(_INTL("Infinite Repel Disabled.")) : pbMessage(_INTL("Infinite Repel Enabled."))
end

REPEL_STAGES = [0,1]
$inf_repel = 0
