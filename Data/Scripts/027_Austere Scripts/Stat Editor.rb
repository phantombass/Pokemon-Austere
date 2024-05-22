class PokemonSummary_Scene
  def pbScene
    pbPlayCry(@pokemon)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::A)
        if @page==2
    	     pbPlayDecisionSE
    		  pbMoveSelection
    		  dorefresh = true
    		end
      elsif Input.trigger?(Input::B)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::C)
        if @page==1
  		    @page += 1
  		    dorefresh = true
    		elsif @page==2
          @page += 1
    		  dorefresh = true
    		elsif @page==3
    		  @page += 1
    		  dorefresh = true
    		elsif @page==4
    		  @page += 1
    		  dorefresh = true
        elsif @page==5
          min_grind_commands = []
          cmdLevel = -1
          cmdNature = -1
          cmdStatChange = -1
          cmdAbility = -1
          min_grind_commands[cmdLevel = min_grind_commands.length] = _INTL("Set Level")
          min_grind_commands[cmdNature = min_grind_commands.length] = _INTL("Change Nature") if !DISABLE_EVS
          min_grind_commands[cmdStatChange = min_grind_commands.length] = _INTL("Change EVs/IVs") if !DISABLE_EVS
          min_grind_commands[cmdAbility = min_grind_commands.length] = _INTL("Change Ability") if !DISABLE_EVS
          min_command = pbShowCommands(min_grind_commands) if !@inbattle
          if cmdLevel>=0 && min_command==cmdLevel
            if @pokemon.level > LEVEL_CAP[$game_system.level_cap]
              pbMessage(_INTL("You can't change the Level of this Pokémon."))
              dorefresh = true
            else
              change_Level
            end
          elsif cmdNature>=0 && min_command==cmdNature
            change_Nature
          elsif cmdStatChange>=0 && min_command==cmdStatChange
            change_Stats
          elsif cmdAbility>=0 && min_command==cmdAbility
            change_Ability
          end
    		end
      elsif Input.trigger?(Input::UP) && @partyindex>0
        oldindex = @partyindex
        pbGoToPrevious
        if @partyindex!=oldindex
          pbChangePokemon
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN) && @partyindex<@party.length-1
        oldindex = @partyindex
        pbGoToNext
        if @partyindex!=oldindex
          pbChangePokemon
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT) && !@pokemon.egg?
        oldpage = @page
        @page -= 1
        @page = 5 if @page<1
        @page = 1 if @page>5
        if @page!=oldpage   # Move to next page
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT) && !@pokemon.egg?
        oldpage = @page
        @page += 1
        @page = 5 if @page<1
        @page = 1 if @page>5
        if @page!=oldpage   # Move to next page
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @partyindex
  end
  def change_Stats
    @sprites["nav"] = AnimatedSprite.new("Graphics/Pictures/selarrow",8,12,28,2,@viewport)
    @sprites["nav"].x = 16
    @sprites["nav"].y = 144
    @sprites["nav"].visible
    commands = []
    cmdHP = -1
    cmdAtk = -1
    cmdDef = -1
    cmdSpA = -1
    cmdSpD = -1
    cmdSpe = -1
    stat_choice = 0
    loop do
      Graphics.update
      Input.update
      pbUpdateSpriteHash(@sprites)
      if Input.trigger?(Input::DOWN)
        if stat_choice < 5
          @sprites["nav"].y += 24
          stat_choice += 1
        elsif stat_choice == 5
          stat_choice -= 5
          @sprites["nav"].y = 144
        end
      elsif Input.trigger?(Input::UP)
        if stat_choice == 0
          @sprites["nav"].y += 120
          stat_choice += 5
        elsif stat_choice > 0
          stat_choice -= 1
          @sprites["nav"].y -= 24
        end
      elsif Input.trigger?(Input::C)
        @scene.pbMessage(_INTL("Change which?\\ch[34,3,EVs,IVs,Cancel]"))
        stat = $game_variables[34]
        stats = [PBStats::HP,PBStats::ATTACK,PBStats::DEFENSE,PBStats::SPATK,PBStats::SPDEF,PBStats::SPEED]
        pkmn = @pokemon
        if stat == -1 || stat == 3 || stat == 2
          @sprites["nav"].visible = false
          pbPlayCloseMenuSE
          break
        end
        if stat == 0
          @scene.pbMessage(_INTL("How?\\ch[34,4,Max EVs,Clear EVs,Change EVs...,Cancel]"))
          stat_ev = $game_variables[34]
          if stat_ev == -1 || stat_ev == 4 || stat_ev == 3
            @sprites["nav"].visible = false
            pbPlayCloseMenuSE
            break
          end
          if stat_ev == 0
            upperLimit = 0
            PBStats.eachStat { |s| upperLimit += pkmn.ev[s] if s != stats[stat_choice] }
            upperLimit = PokeBattle_Pokemon::EV_LIMIT - upperLimit
            upperLimit = [upperLimit, PokeBattle_Pokemon::EV_STAT_LIMIT].min
            pkmn.ev[stats[stat_choice]] = upperLimit
            pkmn.calcStats
            dorefresh = true
          elsif stat_ev == 1
            pkmn.ev[stats[stat_choice]] = 0
            pkmn.calcStats
            dorefresh = true
          elsif stat_ev == 2
            params = ChooseNumberParams.new
            upperLimit = 0
            PBStats.eachStat { |s| upperLimit += pkmn.ev[s] if s != stats[stat_choice] }
            upperLimit = PokeBattle_Pokemon::EV_LIMIT - upperLimit
            upperLimit = [upperLimit, PokeBattle_Pokemon::EV_STAT_LIMIT].min
            thisValue = [pkmn.ev[stats[stat_choice]], upperLimit].min
            params.setRange(0, upperLimit)
            params.setDefaultValue(thisValue)
            params.setCancelValue(pkmn.ev[stats[stat_choice]])
            f = pbMessageChooseNumber(_INTL("Set the EV for {1} (max. {2}).",
               PBStats.getName(stats[stat_choice]), upperLimit), params) { pbUpdate }
            if f != pkmn.ev[stats[stat_choice]]
              pkmn.ev[stats[stat_choice]] = f
              pkmn.calcStats
              dorefresh = true
            end
          end
        end
        if stat == 1
          @scene.pbMessage(_INTL("How?\\ch[34,4,Max IVs,Min IVs,Cancel]"))
          stat_iv = $game_variables[34]
          if stat_iv == -1 || stat_iv == 3 || stat_iv == 2
            @sprites["nav"].visible = false
            pbPlayCloseMenuSE
            break
          end
          if stat_iv == 0
            pkmn.iv[stats[stat_choice]] = 31
            pkmn.calcStats
            dorefresh = true
          elsif stat_iv == 1
            pkmn.iv[stats[stat_choice]] = 0
            pkmn.calcStats
            dorefresh = true
          else
            break
          end
        end
      elsif Input.trigger?(Input::B)
        @sprites["nav"].visible = false
        pbPlayCloseMenuSE
        break
      end
      if dorefresh
        drawPage(@page)
      end
    end
  end

  def change_Nature
    commands = []
    pkmn = @pokemon
    (PBNatures.getCount).times do |i|
      text = _INTL("{1}",PBNatures.getName(i))
      commands.push(text)
    end
    cmd = pkmn.nature
    loop do
      oldnature = PBNatures.getName(pkmn.nature)
      cmd = pbShowCommands(commands,cmd)
      break if cmd<0
      if cmd>=0 && cmd<PBNatures.getCount   # Set nature override
        pkmn.setNature(cmd)
        pkmn.calcStats
      end
      drawPage(@page)
    end
  end

  def change_Ability
    cmd = 0
    pkmn = @pokemon
    loop do
      abils = pkmn.getAbilityList
      oldabil = PBAbilities.getName(pkmn.ability)
      commands = []
      for i in abils
        commands.push(((i[1]<2) ? "" : "(H) ")+PBAbilities.getName(i[0]))
      end
      cmd = pbShowCommands(commands,cmd)
      break if cmd<0
      if cmd>=0 && cmd<abils.length   # Set ability override
        pkmn.setAbility(abils[cmd][1])
      end
      drawPage(@page)
    end
  end

  def change_Level
    pkmn = @pokemon
    if pkmn.egg?
      pbMessage(_INTL("{1} is an egg.", pkmn.name))
    elsif pkmn.fainted? && $game_system.nuzlocke == true
      pbMessage(_INTL("This Pokémon can no longer be used in the Nuzlocke."))
    else
      @scene.pbMessage(_INTL("How would you like to Level Up?\\ch[34,5,To Level Cap,Change Level...,Cancel]"))
      lvl = $game_variables[34]
      if lvl == -1 || lvl == 2 || lvl == 3
        pbPlayCloseMenuSE
        dorefresh = true
      end
      case lvl
      when 0
        pkmn.level = LEVEL_CAP[$game_system.level_cap]
        pkmn.calcStats
        dorefresh = true
      when 1
        params = ChooseNumberParams.new
        params.setRange(1, LEVEL_CAP[$game_system.level_cap])
        params.setDefaultValue(pkmn.level)
        level = pbMessageChooseNumber(
           _INTL("Set the Pokémon's level (max. {1}).", params.maxNumber), params) { pbUpdate }
        if level != pkmn.level
          pkmn.level = level
          pkmn.calcStats
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
  end
end

class PokemonPartyScreen
  def pbPokemonScreen
    @scene.pbStartScene(@party,
       (@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose a POKéMON."),nil)
    loop do
      @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose a POKéMON."))
      pkmnid = @scene.pbChoosePokemon(false,-1,1)
      break if (pkmnid.is_a?(Numeric) && pkmnid<0) || (pkmnid.is_a?(Array) && pkmnid[1]<0)
      if pkmnid.is_a?(Array) && pkmnid[0]==1   # Switch
        @scene.pbSetHelpText(_INTL("Move to where?"))
        oldpkmnid = pkmnid[1]
        pkmnid = @scene.pbChoosePokemon(true,-1,2)
        if pkmnid>=0 && pkmnid!=oldpkmnid
          pbSwitch(oldpkmnid,pkmnid)
        end
        next
      end
      pkmn = @party[pkmnid]
      commands   = []
      cmdSummary = -1
      cmdDebug   = -1
      cmdMoves   = [-1,-1,-1,-1]
      cmdSwitch  = -1
      cmdMail    = -1
      cmdItem    = -1
      cmdRelearn = -1
      cmdEvolve  = -1
      cmdEgg     = -1
      cmdName    = -1
      # Build the commands
      commands[cmdSummary = commands.length]      = _INTL("STATS")
      commands[cmdDebug = commands.length]        = _INTL("DEBUG") if $DEBUG
      for i in 0...pkmn.moves.length
        move = pkmn.moves[i]
        # Check for hidden moves and add any that were found
        if !pkmn.egg? && (isConst?(move.id,PBMoves,:MILKDRINK) ||
                          isConst?(move.id,PBMoves,:SOFTBOILED) ||
                          HiddenMoveHandlers.hasHandler(move.id))
          commands[cmdMoves[i] = commands.length] = [PBMoves.getName(move.id),1]
        end
      end
      commands[cmdSwitch = commands.length]       = _INTL("SWITCH") if @party.length>1
      if !pkmn.egg?
        if pkmn.mail
          commands[cmdMail = commands.length]     = _INTL("MAIL")
        else
          commands[cmdItem = commands.length]     = _INTL("ITEM")
        end
      end
      commands[cmdRelearn = commands.length]   = _INTL("RELEARN")
      commands[cmdEvolve = commands.length]   = _INTL("EVOLVE")
      commands[cmdEgg = commands.length]   = _INTL("EGG MOVES") if $game_switches[900]
      commands[cmdName = commands.length]   = _INTL("NICKNAME")
      commands[commands.length]                   = _INTL("CANCEL")
      command = @scene.pbShowCommands("",commands)
      havecommand = false
      for i in 0...4
        if cmdMoves[i]>=0 && command==cmdMoves[i]
          havecommand = true
          if isConst?(pkmn.moves[i].id,PBMoves,:SOFTBOILED) ||
             isConst?(pkmn.moves[i].id,PBMoves,:MILKDRINK)
            amt = [(pkmn.totalhp/5).floor,1].max
            if pkmn.hp<=amt
              pbDisplay(_INTL("Not enough HP..."))
              break
            end
            @scene.pbSetHelpText(_INTL("Use on which {}?"))
            oldpkmnid = pkmnid
            loop do
              @scene.pbPreSelect(oldpkmnid)
              pkmnid = @scene.pbChoosePokemon(true,pkmnid)
              break if pkmnid<0
              newpkmn = @party[pkmnid]
              movename = PBMoves.getName(pkmn.moves[i].id)
              if pkmnid==oldpkmnid
                pbDisplay(_INTL("{1} can't use {2} on itself!",pkmn.name,movename))
              elsif newpkmn.egg?
                pbDisplay(_INTL("{1} can't be used on an EGG!",movename))
              elsif newpkmn.hp==0 || newpkmn.hp==newpkmn.totalhp
                pbDisplay(_INTL("{1} can't be used on that POKéMON.",movename))
              else
                pkmn.hp -= amt
                hpgain = pbItemRestoreHP(newpkmn,amt)
                @scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.",newpkmn.name,hpgain))
                pbRefresh
              end
              break if pkmn.hp<=amt
            end
            @scene.pbSelect(oldpkmnid)
            pbRefresh
            break
          elsif pbCanUseHiddenMove?(pkmn,pkmn.moves[i].id)
            if pbConfirmUseHiddenMove(pkmn,pkmn.moves[i].id)
              @scene.pbEndScene
              if isConst?(pkmn.moves[i].id,PBMoves,:FLY)
                scene = PokemonRegionMap_Scene.new(-1,false)
                screen = PokemonRegionMapScreen.new(scene)
                ret = screen.pbStartFlyScreen
                if ret
                  $PokemonTemp.flydata=ret
                  return [pkmn,pkmn.moves[i].id]
                end
                @scene.pbStartScene(@party,
                   (@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose a POKéMON."))
                break
              end
              return [pkmn,pkmn.moves[i].id]
            end
          else
            break
          end
        end
      end
      next if havecommand
      if cmdSummary>=0 && command==cmdSummary
        @scene.pbSummary(pkmnid) {
          @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose a POKéMON."))
        }
      elsif cmdDebug>=0 && command==cmdDebug
        pbPokemonDebug(pkmn,pkmnid)
      elsif cmdSwitch>=0 && command==cmdSwitch
        @scene.pbSetHelpText(_INTL("Move to where?"))
        oldpkmnid = pkmnid
        pkmnid = @scene.pbChoosePokemon(true)
        if pkmnid>=0 && pkmnid!=oldpkmnid
          pbSwitch(oldpkmnid,pkmnid)
        end
      elsif cmdMail>=0 && command==cmdMail
        command = @scene.pbShowCommands("",
           [_INTL("READ"),_INTL("TAKE"),_INTL("QUIT")])
        case command
        when 0   # Read
          pbFadeOutIn {
            pbDisplayMail(pkmn.mail,pkmn)
            @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose a POKéMON."))
          }
        when 1   # Take
          if pbTakeItemFromPokemon(pkmn,self)
            pbRefreshSingle(pkmnid)
          end
        end
      elsif cmdItem>=0 && command==cmdItem
        itemcommands = []
        #cmdUseItem   = -1
        cmdGiveItem  = -1
        cmdTakeItem  = -1
        cmdMoveItem  = -1
        # Build the commands
        #itemcommands[cmdUseItem=itemcommands.length]  = _INTL("USE")
        itemcommands[cmdGiveItem=itemcommands.length] = _INTL("GIVE")
        itemcommands[cmdTakeItem=itemcommands.length] = _INTL("TAKE") if pkmn.hasItem?
        itemcommands[cmdMoveItem=itemcommands.length] = _INTL("MOVE") if pkmn.hasItem? && !pbIsMail?(pkmn.item)
        itemcommands[itemcommands.length]             = _INTL("CANCEL")
        command = @scene.pbShowCommands("",itemcommands)
        #if cmdUseItem>=0 && command==cmdUseItem   # Use
         # item = @scene.pbUseItem($PokemonBag,pkmn) {
          #  @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose POKéMON or cancel."))
          #}
          #if item>0
           # pbUseItemOnPokemon(item,pkmn,self)
            #pbRefreshSingle(pkmnid)
          #end
        if cmdGiveItem>=0 && command==cmdGiveItem   # Give
          item = @scene.pbChooseItem($PokemonBag) {
            @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a POKéMON.") : _INTL("Choose a POKéMON."))
          }
          if item>0
            if pbGiveItemToPokemon(item,pkmn,self,pkmnid)
              pbRefreshSingle(pkmnid)
            end
          end
        elsif cmdTakeItem>=0 && command==cmdTakeItem   # Take
          if pbTakeItemFromPokemon(pkmn,self)
            pbRefreshSingle(pkmnid)
          end
        elsif cmdMoveItem>=0 && command==cmdMoveItem   # Move
          item = pkmn.item
          itemname = PBItems.getName(item)
          @scene.pbSetHelpText(_INTL("Move {1} to where?",itemname))
          oldpkmnid = pkmnid
          loop do
            @scene.pbPreSelect(oldpkmnid)
            pkmnid = @scene.pbChoosePokemon(true,pkmnid)
            break if pkmnid<0
            newpkmn = @party[pkmnid]
            if pkmnid==oldpkmnid
              break
            elsif newpkmn.egg?
              pbDisplay(_INTL("EGGS can't hold items."))
            elsif !newpkmn.hasItem?
              newpkmn.setItem(item)
              pkmn.setItem(0)
              @scene.pbClearSwitching
              pbRefresh
              pbDisplay(_INTL("{1} was given the {2} to hold.",newpkmn.name,itemname))
              break
            elsif pbIsMail?(newpkmn.item)
              pbDisplay(_INTL("{1}'s mail must be removed before giving it an item.",newpkmn.name))
            else
              newitem = newpkmn.item
              newitemname = PBItems.getName(newitem)
              if isConst?(newitem,PBItems,:LEFTOVERS)
                pbDisplay(_INTL("{1} is already holding some {2}.\1",newpkmn.name,newitemname))
              elsif newitemname.starts_with_vowel?
                pbDisplay(_INTL("{1} is already holding an {2}.\1",newpkmn.name,newitemname))
              else
                pbDisplay(_INTL("{1} is already holding a {2}.\1",newpkmn.name,newitemname))
              end
              if pbConfirm(_INTL("Would you like to switch the two items?"))
                newpkmn.setItem(item)
                pkmn.setItem(newitem)
                @scene.pbClearSwitching
                pbRefresh
                pbDisplay(_INTL("{1} was given the {2} to hold.",newpkmn.name,itemname))
                pbDisplay(_INTL("{1} was given the {2} to hold.",pkmn.name,newitemname))
                break
              end
            end
          end
        end
      elsif cmdRelearn>=0 && command==cmdRelearn
        if pbHasRelearnableMove?(pkmn)
          pbRelearnMoveScreen(pkmn)
        else
          pbDisplay(_INTL("This POKéMON cannot relearn any moves."))
        end
      elsif cmdEvolve>=0 && command==cmdEvolve
        if pkmn.fainted? && $PokemonSystem.nuzlocke == true
          pbDisplay(_INTL("This POKéMON has fainted and can no longer be used."))
        else
          evoreqs = {}
          species = pkmn.species
          pbGetEvolvedFormData(species).each do |evo|   # [method, parameter, new_species]
            if [26,27,28,29,30,34,35].include?(evo[0]) #Happiness Evolutions
              evoreqs[evo[2]] = nil
            elsif [40,41,47,48,49,50,51,52,62].include?(evo[0]) && $PokemonBag.pbHasItem?(evo[1]) #Item Evolutions
              evoreqs[evo[2]] = evo[1]
            elsif [53,54,55,56,57,58,59].include?(evo[0]) && $Trainer.pbHasSpecies?(species) #Trade Evolutions
              evoreqs[evo[2]] = evo[1]
            elsif pbCheckEvolution(pkmn) > -1 #Level Up Evolutions
              evoreqs[evo[2]] = nil
            end
          end
          case evoreqs.length
          when 0
            pbDisplay(_INTL("This Pokémon can't evolve."))
            next
          when 1
            newspecies = evoreqs.keys[0]
          else
            newspecies = evoreqs.keys[@scene.pbShowCommands(
              _INTL("Which species would you like to evolve into?"),
              evoreqs.keys.map { |id| _INTL(PBSpecies.getName(id)) }
            )]
          end
          if evoreqs[newspecies] # requires an item
            next unless @scene.pbConfirmMessage(_INTL(
              "This will consume a {1}. Do you want to continue?",
              PBItems.getName(evoreqs[newspecies])
            ))
            $PokemonBag.pbDeleteItem(evoreqs[newspecies])
          end
          pbFadeOutInWithMusic {
            evo = PokemonEvolutionScene.new
            evo.pbStartScreen(pkmn,newspecies)
            evo.pbEvolution
            evo.pbEndScreen
            pbRefresh
          }
        end
      elsif cmdEgg>=0 && command==cmdEgg
        if pkmn.has_egg_move?
          pbEggMoveScreen(pkmn)
        else
          pbDisplay(_INTL("This POKéMON has no egg moves."))
        end
      elsif cmdName>=0 && command==cmdName
        speciesname = pkmn.speciesName
        nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", speciesname),
                                      0, PokeBattle_Pokemon::MAX_POKEMON_NAME_SIZE, "", pkmn)
        nickname = speciesname if nickname == ""
        pkmn.name = nickname
      end
    end
    @scene.pbEndScene
    return nil
  end
end

#Egg Relearner Script
class EggRelearner_Scene
  VISIBLEMOVES = 4

  def pbDisplay(msg,brief=false)
    UIHelper.pbDisplay(@sprites["msgwindow"],msg,brief) { pbUpdate }
  end

  def pbConfirm(msg)
    UIHelper.pbConfirm(@sprites["msgwindow"],msg) { pbUpdate }
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(pokemon,moves)
    @pokemon=pokemon
    @moves=moves
    moveCommands=[]
    moves.each { |m| moveCommands.push(PBMoves.getName(m)) }
    # Create sprite hash
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    addBackgroundPlane(@sprites,"bg","Reminder/reminderbg",@viewport)
    @sprites["pokeicon"]=PokemonIconSprite.new(@pokemon,@viewport)
    @sprites["pokeicon"].setOffset(PictureOrigin::Center)
    @sprites["pokeicon"].x=32
    @sprites["pokeicon"].y=160
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Reminder/reminderSel")
    @sprites["background"].y=172
    @sprites["background"].src_rect=Rect.new(0,16,320,16)
    @sprites["overlay"]=BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["commands"]=Window_CommandPokemon.new(moveCommands,32)
    @sprites["commands"].height=32*(VISIBLEMOVES+1)
    @sprites["commands"].visible=false
    @sprites["msgwindow"]=Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible=false
    @sprites["msgwindow"].viewport=@viewport
    @typebitmap=AnimatedBitmap.new(_INTL("Graphics/Pictures/types"))
    pbDrawMoveList
    pbDeactivateWindows(@sprites)
    # Fade in all sprites
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbDrawMoveList
    movesData = pbLoadMovesData
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    type1rect=Rect.new(0,@pokemon.type1*28,64,28)
    type2rect=Rect.new(0,@pokemon.type2*28,64,28)
    if @pokemon.type1==@pokemon.type2
      overlay.blt(400,70,@typebitmap.bitmap,type1rect)
    else
      overlay.blt(366,70,@typebitmap.bitmap,type1rect)
      overlay.blt(436,70,@typebitmap.bitmap,type2rect)
    end
    textpos=[
       [_INTL("Teach which move?"),320,144,1,Color.new(0,0,0),Color.new(255,255,255,0)]
    ]
    imagepos=[]
    yPos=165
    for i in 0...VISIBLEMOVES
      moveobject=@moves[@sprites["commands"].top_item+i]
      if moveobject
        moveData=movesData[moveobject]
        if moveData
          textpos.push([PBMoves.getName(moveobject),4,yPos,0,
             Color.new(0,0,0),Color.new(255,255,255,0)])
          if moveData[MOVE_TOTAL_PP]>0
            textpos.push([_INTL("{1}/{2}",
               moveData[MOVE_TOTAL_PP],moveData[MOVE_TOTAL_PP]),320,yPos,1,#+16
               Color.new(0,0,0),Color.new(255,255,255,0)])
          end
        else
          textpos.push(["-",80,yPos,0,Color.new(0,0,0),Color.new(255,255,255,0)])
          textpos.push(["--",228,yPos+32,1,Color.new(0,0,0),Color.new(255,255,255,0)])
        end
      end
      yPos+=16
    end
    imagepos.push(["Graphics/Pictures/Reminder/reminderSel",
       0,172+(@sprites["commands"].index-@sprites["commands"].top_item)*16,
       0,0,320,16])
    selMoveData=movesData[@moves[@sprites["commands"].index]]
    basedamage=selMoveData[MOVE_BASE_DAMAGE]
    category=selMoveData[MOVE_CATEGORY]
    accuracy=selMoveData[MOVE_ACCURACY]
    textpos.push([_INTL("CATEG"),8,240,0,Color.new(0,0,0),Color.new(255,255,255,0)])
    textpos.push([_INTL("POWER"),120,240,0,Color.new(0,0,0),Color.new(255,255,255,0)])
    textpos.push([basedamage<=1 ? basedamage==1 ? "???" : "---" : sprintf("%d",basedamage),
          200,260,1,Color.new(0,0,0),Color.new(255,255,255,0)])
    textpos.push([_INTL("ACCUR"),230,240,0,Color.new(0,0,0),Color.new(255,255,255,0)])
    textpos.push([accuracy==0 ? "---" : sprintf("%d",accuracy),
          308,260,1,Color.new(0,0,0),Color.new(255,255,255,0)])
    pbDrawTextPositions(overlay,textpos)
    imagepos.push(["Graphics/Pictures/category",8,268,0,category*14,122,14])
    if @sprites["commands"].index<@moves.length-1
      imagepos.push(["Graphics/Pictures/reminderButtons",48,350,0,0,76,32])
    end
    if @sprites["commands"].index>0
      imagepos.push(["Graphics/Pictures/reminderButtons",134,350,76,0,76,32])
    end
	pbDrawImagePositions(overlay,imagepos)
    drawTextEx(overlay,0,0,320,5,
       pbGetMessage(MessageTypes::MoveDescriptions,@moves[@sprites["commands"].index]),
       Color.new(0,0,0),Color.new(255,255,255,0))
  end

  # Processes the scene
  def pbChooseMove
    oldcmd=-1
    pbActivateWindow(@sprites,"commands") {
      loop do
        oldcmd=@sprites["commands"].index
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["commands"].index!=oldcmd
          @sprites["background"].x=0
          @sprites["background"].y=172+(@sprites["commands"].index-@sprites["commands"].top_item)*16
          pbDrawMoveList
        end
        if Input.trigger?(Input::B)
          return 0
        elsif Input.trigger?(Input::C)
          return @moves[@sprites["commands"].index]
        end
      end
    }
  end

  # End the scene here
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @typebitmap.dispose
    @viewport.dispose
  end
end

class EggRelearnerScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemon)
    moves=pbGetEggMoves(pokemon)
    @scene.pbStartScene(pokemon,moves)
    loop do
      move=@scene.pbChooseMove
      if move<=0
        if @scene.pbConfirmMessage(_INTL("Give up trying to teach a new move to {1}?",pokemon.name))
          @scene.pbEndScene
          return false
        end
      else
        if @scene.pbConfirm(_INTL("Teach {1}?",PBMoves.getName(move)))
          if pbLearnMove(pokemon,move)
            @scene.pbEndScene
            return true
          end
        end
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
def pbEggMoveScreen(pkmn)
  retval = true
  pbFadeOutIn {
    scene = EggRelearner_Scene.new
    screen = EggRelearnerScreen.new(scene)
    retval = screen.pbStartScreen(pkmn)
  }
  return retval
end

def pbGetEggMoves(pkmn)
  return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?
  moves = []
  pkmn.getEggMovesList.each do |m|
    next if pkmn.hasMove?(m)
    moves.push(m) if !moves.include?(m)
  end
  egg = moves
  return egg | []  # remove duplicates
end

class PokeBattle_Pokemon
  def getEggMovesList
    baby = PBSpecies.pbGetBabySpecies(species)
    form = @form
    egg = PBSpecies.pbGetSpeciesEggMoves(baby,form)
    return egg
  end
  def has_egg_move?
    return false if egg? || shadowPokemon?
    getEggMovesList.each { |m| return true if !hasMove?(m[1]) }
    return false
  end
end


def change_Stats(pokemon)
  pbMessage(_INTL("Which stat?\\ch[34,7,HP,ATTACK,DEFENSE,SPATK,SPDEF,SPEED,Cancel]"))
  stat = $game_variables[34]
  stats = [PBStats::HP,PBStats::ATTACK,PBStats::DEFENSE,PBStats::SPATK,PBStats::SPDEF,PBStats::SPEED]
  pkmn = $Trainer.pokemonParty[pokemon]
  if pbConfirmMessage(_INTL("Are you sure?"))
    pkmn.iv[stats[stat]] = 31
    pkmn.calcStats
    return true
  else
    return false
  end
end
  

def change_Nature(pokemon)
  commands = []
  pkmn = $Trainer.pokemonParty[pokemon]
  for i in 0...PBNatures.getCount
    text = _INTL("{1}",PBNatures.getName(i))
    commands.push(text)
  end
  cmd = pkmn.nature
  loop do
    oldnature = PBNatures.getName(pkmn.nature)
    cmd = pbShowCommands(nil,commands,cmd)
    break if cmd<0
    if cmd>=0 && cmd<PBNatures.getCount   # Set nature override
      pkmn.setNature(cmd)
      pkmn.calcStats
      return true
    else
      return false
    end
  end
  return false
end

def pbHeartScaleGuy
  pbMessage(_INTL("I can change your Pokémon's NATURE or IVs!"))
  if !$PokemonBag.pbHasItem?(:HEARTSCALE)
    pbMessage(_INTL("Please come back with a HEART SCALE."))
  else
    if pbConfirmMessage(_INTL("Would you like me to do that?"))
      pbChooseNonEggPokemon(1,3)
      if pbGet(1) > -1
        pbMessage(_INTL("What would you like to change?\\ch[34,3,NATURE: 2 SCALES,IVs: 1 SCALE EACH,Cancel]"))
        var = pbGet(34)
        case var
        when 0
          if $PokemonBag.pbQuantity(:HEARTSCALE) < 2
            pbMessage(_INTL("You need more HEART SCALES."))
            ret = false
          else
            ret = change_Nature(pbGet(1))
            amt = 2 if ret
          end
        when 1
          ret = change_Stats(pbGet(1))
          amt = 1 if ret
        else
          ret = false
        end
      else
        ret = false
      end
      if ret == false
        pbMessage(_INTL("Some other time then."))
      else
        $PokemonBag.pbDeleteItem(:HEARTSCALE,amt)
        pbMessage(_INTL("All set! Come again!"))
      end
    else
      pbMessage(_INTL("Some other time then."))
    end
  end
end