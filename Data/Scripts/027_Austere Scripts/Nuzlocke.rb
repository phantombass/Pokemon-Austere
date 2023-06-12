class Game_System
  attr_accessor :nuzlocke
  alias initialize_nuzlocke initialize
  def initialize
    initialize_nuzlocke
    @nuzlocke         = false
  end
  def nuzlocke
    return @nuzlocke
  end
end

#===Class Overrides for Nuzlocke Mode===#

def pbHealAll
  pbEachPokemon { |poke,_box| poke.heal}
end

class PokeBattle_Pokemon
 def heal
   return if egg?
   return if fainted? && $game_system.nuzlocke
   healHP
   healStatus
   healPP
 end
end

class PokemonStorageScreen
  def pbStore(selected,heldpoke)
    box = selected[0]
    index = selected[1]
    if box!=-1
      raise _INTL("Can't deposit from box...")
    end
    if pbAbleCount<=1 && pbAble?(@storage[box,index]) && !heldpoke
      pbPlayBuzzerSE
      pbDisplay(_INTL("That's your last POKéMON!"))
    elsif heldpoke && heldpoke.mail
      pbDisplay(_INTL("Please remove the Mail."))
    elsif !heldpoke && @storage[box,index].mail
      pbDisplay(_INTL("Please remove the Mail."))
    else
      loop do
        destbox = @scene.pbChooseBox(_INTL("Deposit in which BOX?"))
        if destbox>=0
          firstfree = @storage.pbFirstFreePos(destbox)
          if firstfree<0
            pbDisplay(_INTL("The BOX is full."))
            next
          end
          if heldpoke || selected[0]==-1
            p = (heldpoke) ? heldpoke : @storage[-1,index]
            p.formTime = nil if p.respond_to?("formTime")
            p.form     = 0 if p.isSpecies?(:SHAYMIN)
            p.heal if !$game_system.nuzlocke
          end
          @scene.pbStore(selected,heldpoke,destbox,firstfree)
          if heldpoke
            @storage.pbMoveCaughtToBox(heldpoke,destbox)
            @heldpkmn = nil
          else
            @storage.pbMove(destbox,-1,-1,index)
          end
        end
        break
      end
      @scene.pbRefresh
    end
  end

  def pbPlace(selected)
    box = selected[0]
    index = selected[1]
    if @storage[box,index]
      raise _INTL("Position {1},{2} is not empty...",box,index)
    end
    if box!=-1 && index>=@storage.maxPokemon(box)
      pbDisplay("Can't place that there.")
      return
    end
    if box!=-1 && @heldpkmn.mail
      pbDisplay("Please remove the mail.")
      return
    end
    if box>=0
      @heldpkmn.formTime = nil if @heldpkmn.respond_to?("formTime")
      @heldpkmn.form     = 0 if @heldpkmn.isSpecies?(:SHAYMIN)
      @heldpkmn.heal if !$game_system.nuzlocke
    end
    @scene.pbPlace(selected,@heldpkmn)
    @storage[box,index] = @heldpkmn
    if box==-1
      @storage.party.compact!
    end
    @scene.pbRefresh
    @heldpkmn = nil
  end

  def pbSwap(selected)
    box = selected[0]
    index = selected[1]
    if !@storage[box,index]
      raise _INTL("Position {1},{2} is empty...",box,index)
    end
    if box==-1 && pbAble?(@storage[box,index]) && pbAbleCount<=1 && !pbAble?(@heldpkmn)
      pbPlayBuzzerSE
      pbDisplay(_INTL("That's your last POKéMON!"))
      return false
    end
    if box!=-1 && @heldpkmn.mail
      pbDisplay("Please remove the mail.")
      return false
    end
    if box>=0
      @heldpkmn.formTime = nil if @heldpkmn.respond_to?("formTime")
      @heldpkmn.form     = 0 if @heldpkmn.isSpecies?(:SHAYMIN)
      @heldpkmn.heal if !$game_system.nuzlocke
    end
    @scene.pbSwap(selected,@heldpkmn)
    tmp = @storage[box,index]
    @storage[box,index] = @heldpkmn
    @heldpkmn = tmp
    @scene.pbRefresh
    return true
  end
end

class PokemonBox
  def pbCopy(boxDst,indexDst,boxSrc,indexSrc)
    if indexDst<0 && boxDst<self.maxBoxes
      found = false
      for i in 0...maxPokemon(boxDst)
        next if self[boxDst,i]
        found = true
        indexDst = i
        break
      end
      return false if !found
    end
    if boxDst==-1   # Copying into party
      return false if self.party.nitems>=6
      self.party[self.party.length] = self[boxSrc,indexSrc]
      self.party.compact!
    else   # Copying into box
      pkmn = self[boxSrc,indexSrc]
      raise "Trying to copy nil to storage" if !pkmn
      pkmn.formTime = nil if pkmn.respond_to?("formTime")
      pkmn.form     = 0 if pkmn.isSpecies?(:SHAYMIN)
      #pkmn.heal
      self[boxDst,indexDst] = pkmn
    end
    return true
  end

  def pbMoveCaughtToBox(pkmn,box)
    for i in 0...maxPokemon(box)
      if self[box,i]==nil
        if box>=0
          pkmn.formTime = nil if pkmn.respond_to?("formTime") && pkmn.formTime
          pkmn.form     = 0 if pkmn.isSpecies?(:SHAYMIN)
          #pkmn.heal
        end
        self[box,i] = pkmn
        return true
      end
    end
    return false
  end

  def pbStoreCaught(pkmn)
    if @currentBox>=0
      pkmn.formTime = nil if pkmn.respond_to?("formTime")
      pkmn.form     = 0 if pkmn.isSpecies?(:SHAYMIN)
      #pkmn.heal
    end
    for i in 0...maxPokemon(@currentBox)
      if self[@currentBox,i]==nil
        self[@currentBox,i] = pkmn
        return @currentBox
      end
    end
    for j in 0...self.maxBoxes
      for i in 0...maxPokemon(j)
        if self[j,i]==nil
          self[j,i] = pkmn
          @currentBox = j
          return @currentBox
        end
      end
    end
    return -1
  end
end

class PokeBattle_Battle
  def pbAustereClauses
    self.rules["sleepclause"] = true
    self.rules["batonpassclause"] = true
  end
  def pbItemMenu(idxBattler,firstAction)
    if !@internalBattle || @opponent || $game_switches[950] == true
      pbDisplay(_INTL("Items can't be used here."))
      return false
    end
    ret = false
    @scene.pbItemMenu(idxBattler,firstAction) { |item,useType,idxPkmn,idxMove,itemScene|
      next false if item<0
      battler = pkmn = nil
      case useType
      when 1, 2, 6, 7   # Use on Pokémon/Pokémon's move
        next false if !ItemHandlers.hasBattleUseOnPokemon(item)
        battler = pbFindBattler(idxPkmn,idxBattler)
        pkmn    = pbParty(idxBattler)[idxPkmn]
        next false if !pbCanUseItemOnPokemon?(item,pkmn,battler,itemScene)
      when 3, 8   # Use on battler
        next false if !ItemHandlers.hasBattleUseOnBattler(item)
        battler = pbFindBattler(idxPkmn,idxBattler)
        pkmn    = battler.pokemon if battler
        next false if !pbCanUseItemOnPokemon?(item,pkmn,battler,itemScene)
      when 4, 9   # Poké Balls
        next false if idxPkmn<0
        battler = @battlers[idxPkmn]
        pkmn    = battler.pokemon if battler
      when 5, 10   # No target (Poké Doll, Guard Spec., Launcher items)
        battler = @battlers[idxBattler]
        pkmn    = battler.pokemon if battler
      else
        next false
      end
      next false if !pkmn
      next false if !ItemHandlers.triggerCanUseInBattle(item,
         pkmn,battler,idxMove,firstAction,self,itemScene)
      next false if !pbRegisterItem(idxBattler,item,idxPkmn,idxMove)
      ret = true
      next true
    }
    return ret
  end
end

class PokeBattle_Scene
  def pbItemMenu(idxBattler,_firstAction)
    # Fade out and hide all sprites
    visibleSprites = pbFadeOutAndHide(@sprites)
    # Set Bag starting positions
    oldLastPocket = $PokemonBag.lastpocket
    oldChoices    = $PokemonBag.getAllChoices
    $PokemonBag.lastpocket = @bagLastPocket if @bagLastPocket!=nil
    $PokemonBag.setAllChoices(@bagChoices) if @bagChoices!=nil
    # Start Bag screen
    itemScene = PokemonBag_Scene.new
    itemScene.pbStartScene($PokemonBag,true,Proc.new { |item|
      useType = pbGetItemData(item,ITEM_BATTLE_USE)
      next useType && [4,9].include?(useType)
      },false)
    # Loop while in Bag screen
    wasTargeting = false
    loop do
      # Select an item
      item = itemScene.pbChooseItem
      break if item==0
      # Choose a command for the selected item
      itemName = PBItems.getName(item)
      useType = pbGetItemData(item,ITEM_BATTLE_USE)
      cmdUse = -1
      commands = []
      commands[cmdUse = commands.length] = _INTL("USE") if useType && [4,9].include?(useType)
      commands[commands.length]          = _INTL("CANCEL")
      command = itemScene.pbShowCommands(nil,commands) # _INTL("{1} is selected.",itemName)
      next unless cmdUse>=0 && command==cmdUse   # Use
      # Use types:
      # 0 = not usable in battle
      # 1 = use on Pokémon (lots of items), consumed
      # 2 = use on Pokémon's move (Ethers), consumed
      # 3 = use on battler (X items, Persim Berry), consumed
      # 4 = use on opposing battler (Poké Balls), consumed
      # 5 = use no target (Poké Doll, Guard Spec., Launcher items), consumed
      # 6 = use on Pokémon (Blue Flute), not consumed
      # 7 = use on Pokémon's move, not consumed
      # 8 = use on battler (Red/Yellow Flutes), not consumed
      # 9 = use on opposing battler, not consumed
      # 10 = use no target (Poké Flute), not consumed
      case useType
      when 1, 2, 3, 6, 7, 8   # Use on Pokémon/Pokémon's move/battler
        # Auto-choose the Pokémon/battler whose action is being decided if they
        # are the only available Pokémon/battler to use the item on
        case useType
        when 1, 6   # Use on Pokémon
          if @battle.pbTeamLengthFromBattlerIndex(idxBattler)==1
            break if yield item, useType, @battle.battlers[idxBattler].pokemonIndex, -1, itemScene
          end
        when 3, 8   # Use on battler
          if @battle.pbPlayerBattlerCount==1
            break if yield item, useType, @battle.battlers[idxBattler].pokemonIndex, -1, itemScene
          end
        end
        # Fade out and hide Bag screen
        itemScene.pbFadeOutScene
        # Get player's party
        party    = @battle.pbParty(idxBattler)
        partyPos = @battle.pbPartyOrder(idxBattler)
        partyStart, _partyEnd = @battle.pbTeamIndexRangeFromBattlerIndex(idxBattler)
        modParty = @battle.pbPlayerDisplayParty(idxBattler)
        # Start party screen
        pkmnScene = PokemonParty_Scene.new
        pkmnScreen = PokemonPartyScreen.new(pkmnScene,modParty)
        pkmnScreen.pbStartScene(_INTL("Use on which {}?"),@battle.pbNumPositions(0,0))
        idxParty = -1
        # Loop while in party screen
        loop do
          # Select a Pokémon
          pkmnScene.pbSetHelpText(_INTL("Use on which {}?"))
          idxParty = pkmnScreen.pbChoosePokemon
          break if idxParty<0
          idxPartyRet = -1
          partyPos.each_with_index do |pos,i|
            next if pos!=idxParty+partyStart
            idxPartyRet = i
            break
          end
          next if idxPartyRet<0
          pkmn = party[idxPartyRet]
          next if !pkmn || pkmn.egg?
          idxMove = -1
          if useType==2 || useType==7   # Use on Pokémon's move
            idxMove = pkmnScreen.pbChooseMove(pkmn,_INTL("Restore which move?"))
            next if idxMove<0
          end
          break if yield item, useType, idxPartyRet, idxMove, pkmnScene
        end
        pkmnScene.pbEndScene
        break if idxParty>=0
        # Cancelled choosing a Pokémon; show the Bag screen again
        itemScene.pbFadeInScene
      when 4, 9   # Use on opposing battler (Poké Balls)
        idxTarget = -1
        if @battle.pbOpposingBattlerCount(idxBattler)==1
          @battle.eachOtherSideBattler(idxBattler) { |b| idxTarget = b.index }
          break if yield item, useType, idxTarget, -1, itemScene
        else
          wasTargeting = true
          # Fade out and hide Bag screen
          itemScene.pbFadeOutScene
          # Fade in and show the battle screen, choosing a target
          tempVisibleSprites = visibleSprites.clone
          tempVisibleSprites["commandWindow"] = false
          tempVisibleSprites["targetWindow"]  = true
          idxTarget = pbChooseTarget(idxBattler,PBTargets::Foe,tempVisibleSprites)
          if idxTarget>=0
            break if yield item, useType, idxTarget, -1, self
          end
          # Target invalid/cancelled choosing a target; show the Bag screen again
          wasTargeting = false
          pbFadeOutAndHide(@sprites)
          itemScene.pbFadeInScene
        end
      when 5, 10   # Use with no target
        break if yield item, useType, idxBattler, -1, itemScene
      end
    end
    @bagLastPocket = $PokemonBag.lastpocket
    @bagChoices    = $PokemonBag.getAllChoices
    $PokemonBag.lastpocket = oldLastPocket
    $PokemonBag.setAllChoices(oldChoices)
    # Close Bag screen
    itemScene.pbEndScene
    # Fade back into battle screen (if not already showing it)
    pbFadeInAndShow(@sprites,visibleSprites) if !wasTargeting
  end
end
