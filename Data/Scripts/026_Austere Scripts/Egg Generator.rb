def generate_egg
  egg_list = [:SKITTY,:GULPIN,:FLABEBE,:AZURILL,:MAREANIE,:SNEASEL,:TEDDIURSA,:TOXEL,:CUBONE,:DARUMAKA,:MIMEJR,:MEOWTH,:PONYTA,:CORSOLA,:FARFETCHD,:GEODUDE,:SKIDDO,:KLINK,:STANTLER,:PICHU,:MAGBY,:ELEKID,:SMOOCHUM,:HAPPINY,:MUNCHLAX,:POIPOLE,:COSMOG,:LARVESTA,:MAGNEMITE,:CARBINK,:AUDINO,:RALTS,:ABRA,:GASTLY,:DROWZEE,:ELGYEM,:BRONZOR,:MUNNA,:PYUKUMUKU,:WYNAUT,:SCRAGGY,:SEEL,:HORSEA,:JIGGLYPUFF,:MANKEY,:SEVIPER,
  :ZANGOOSE,:SNUBBULL,:MAREEP,:GIRAFARIG,:DUNSPARCE,:CHINGLING,:SNORUNT,:SPHEAL,:BUIZEL,:FINNEON,:MORELULL,:FOMANTIS,:INKAY,:COTTONEE,:MISDREAVUS,:MURKROW,:FEEBAS,:GOTHITA,:SOLOSIS,:STUNFISK,:PIKIPEK,:EMOLGA,:PLUSLE,:MINUN,:TOGEDEMARU,:VOLBEAT,:ILLUMISE,:ODDISH,:BELLSPROUT,:IGGLYBUFF,:CLEFFA,:PICHU,:STARYU,:GRIMER,:KOFFING,:LAPRAS,:ZUBAT,:NATU,:BONSLY,:WEEDLE,:CATERPIE,:WAILMER,:SHELMET,:KARRABLAST,:SCYTHER,:BARBOACH,:LUVDISC,:DEDENNE,:MINIOR,:CRABRAWLER,:KRABBY,
  :SKORUPI,:FOMANTIS,:DEWPIDER,:BUNEARY,:TYNAMO,:DELIBIRD,:REMORAID,:CHEWTLE,:YAMPER,:SKWOVET,:DHELMISE,:EKANS,:CRYOGONAL,:CUBCHOO,:WISHIWASHI,:TRAPINCH,:NOIBAT,:RIOLU,:TYROGUE,:CROAGUNK,:GLIGAR,:ZIGZAGOON,:JOLTIK]
  rand = rand(egg_list.length)
  egg = egg_list[rand]
  return egg
end

def egg_move_gen(egg)
  moves = pbGetEggMoves(egg)
  return rand(moves[moves.length])
end

def egg_gift
  mon = generate_egg
  if pbGenerateEgg(mon, _I("Egg Vendor"))
    egg = $Trainer.lastParty
    egg.eggsteps = 150
    egg.setAbility(2)
    egg.iv[PBStats::HP]=31
    egg.iv[PBStats::DEFENSE]=31
    egg.iv[PBStats::SPDEF]=31
    move = egg_move_gen(egg)
    egg.pbLearnMove(move)
    egg.calcStats
    $qol_toggle = true
    return true
  else
    return false
  end
end
