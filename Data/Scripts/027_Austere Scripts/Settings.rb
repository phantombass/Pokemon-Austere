GAME_VERSION = "0.6.1"
FISHING_AUTO_HOOK = true
DISABLE_EVS = true

def write_version
  File.open("version.txt", "wb") { |f|
    #$DEBUG = false
    version = GAME_VERSION
    f.write("#{version}")
  }
end

def reset_custom_variables
  $qol_toggle = true if $Trainer.pokedex == true
  $PokemonGlobal.repel = 0
  SetTime.clear
  Mission_Database.setup
  $time_update = false
  $eeveelution = nil
end

def reset_all_custom_variables
  $qol_toggle = false
  $PokemonGlobal.repel = 0
  SetTime.clear
  $time_update = false
  $hm_catalogue = false
  $eeveelution = nil
end

def PokemonOption_Scene
  def pbStartScene(inloadscreen=false)
    @sprites = {}
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
       _INTL("OPTIONS"),0,0,Graphics.width,64,@viewport)
    @sprites["textbox"] = pbCreateMessageWindow
    @sprites["textbox"].text           = _INTL("Speech frame {1}.",1+$PokemonSystem.textskin)
    @sprites["textbox"].letterbyletter = false
    pbSetSystemFont(@sprites["textbox"].contents)
    # These are the different options in the game. To add an option, define a
    # setter and a getter for that option. To delete an option, comment it out
    # or delete it. The game's options may be placed in any order.
    @PokemonOptions = [
       SliderOption.new(_INTL("MUSIC"),0,100,5,
         proc { $PokemonSystem.bgmvolume },
         proc { |value|
           if $PokemonSystem.bgmvolume!=value
             $PokemonSystem.bgmvolume = value
             if $game_system.playing_bgm!=nil && !inloadscreen
               $game_system.playing_bgm.volume = value
               playingBGM = $game_system.getPlayingBGM
               $game_system.bgm_pause
               $game_system.bgm_resume(playingBGM)
             end
           end
         }
       ),
       SliderOption.new(_INTL("SFX"),0,100,5,
         proc { $PokemonSystem.sevolume },
         proc { |value|
           if $PokemonSystem.sevolume!=value
             $PokemonSystem.sevolume = value
             if $game_system.playing_bgs!=nil
               $game_system.playing_bgs.volume = value
               playingBGS = $game_system.getPlayingBGS
               $game_system.bgs_pause
               $game_system.bgs_resume(playingBGS)
             end
             pbPlayCursorSE
           end
         }
       ),
       EnumOption.new(_INTL("SPEED"),[_INTL("x1"),_INTL("x2"),_INTL("x3")],
         proc { $PokemonSystem.textspeed },
         proc { |value|
           $PokemonSystem.textspeed = value
           MessageConfig.pbSetTextSpeed(pbSettingToTextSpeed(value))
         }
       ),
       EnumOption.new(_INTL("ANIM."),[_INTL("ON"),_INTL("OFF")],
         proc { $PokemonSystem.battlescene },
         proc { |value| $PokemonSystem.battlescene = value }
       ),
#       EnumOption.new(_INTL("STYLE"),[_INTL("SWITCH"),_INTL("SET")],
#         proc { $PokemonSystem.battlestyle },
#         proc { |value| $PokemonSystem.battlestyle = value }
#       ),
       NumberOption.new(_INTL("SPEECH"),1,$SpeechFrames.length,
         proc { $PokemonSystem.textskin },
         proc { |value|
           $PokemonSystem.textskin = value
           MessageConfig.pbSetSpeechFrame("Graphics/Windowskins/"+$SpeechFrames[value])
         }
       ),
       NumberOption.new(_INTL("MENU"),1,$TextFrames.length,
         proc { $PokemonSystem.frame },
         proc { |value|
           $PokemonSystem.frame = value
           MessageConfig.pbSetSystemFrame($TextFrames[value])
         }
       ),
       EnumOption.new(_INTL("SCREEN"),[_INTL("x1"),_INTL("x2"),_INTL("x3"),_INTL("Full")],
         proc { [$PokemonSystem.screensize,3].min },
         proc { |value|
           oldvalue = $PokemonSystem.screensize
           $PokemonSystem.screensize = value
           if value!=oldvalue
             pbSetResizeFactor($PokemonSystem.screensize)
             ObjectSpace.each_object(TilemapLoader) { |o| o.updateClass if !o.disposed? }
           end
         }
       )
    ]
    @PokemonOptions = pbAddOnOptions(@PokemonOptions)
    @sprites["option"] = Window_PokemonOption.new(@PokemonOptions,0,
       @sprites["title"].height,Graphics.width,
       Graphics.height-@sprites["title"].height-@sprites["textbox"].height)
    @sprites["option"].viewport = @viewport
    @sprites["option"].visible  = true
    # Get the values of each option
    for i in 0...@PokemonOptions.length
      @sprites["option"].setValueNoRefresh(i,(@PokemonOptions[i].get || 0))
    end
    @sprites["option"].refresh
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
end
