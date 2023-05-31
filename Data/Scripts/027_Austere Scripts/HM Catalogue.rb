def pbHMCatalogue
  commands = []
  done = false
  cmdCut = -1
  cmdRockSmash = -1
  cmdStrength = -1
  cmdFlash = -1
  cmdSurf = -1
  cmdFly = -1
  cmdDive = -1
  cmdRockClimb = -1
  cmdWaterfall = -1
  commands[cmdCut = commands.length]       = _INTL("Cut") if HM_Catalogue.cut
  commands[cmdRockSmash = commands.length]       = _INTL("Rock Smash") if HM_Catalogue.rock_smash
  commands[cmdStrength = commands.length]       = _INTL("Strength") if HM_Catalogue.strength
  commands[cmdFlash = commands.length]       = _INTL("Flash") if HM_Catalogue.flash
  commands[cmdSurf = commands.length]       = _INTL("Surf") if HM_Catalogue.surf
  commands[cmdFly = commands.length]       = _INTL("Fly") if HM_Catalogue.fly
  commands[cmdDive = commands.length]       = _INTL("Dive") if HM_Catalogue.dive
  commands[cmdRockClimb = commands.length]       = _INTL("Rock Climb") if HM_Catalogue.rock_climb
  commands[cmdWaterfall = commands.length]       = _INTL("Waterfall") if HM_Catalogue.waterfall
  commands[commands.length]                      = _INTL("Cancel")
  command = pbShowCommands(nil,commands)
  loop do
    if cmdCut>=0 && command==cmdCut
      useMoveCut if canUseMoveCut?
      done = true
    elsif cmdRockSmash>=0 && command==cmdRockSmash
      useMoveRockSmash if canUseMoveRockSmash?
      done = true
    elsif cmdStrength>=0 && command==cmdStrength
      useMoveStrength if canUseMoveStrength?
      done = true
    elsif cmdFlash>=0 && command==cmdFlash
      useMoveFlash if canUseMoveFlash?
      done = true
    elsif cmdSurf>=0 && command==cmdSurf
      useMoveSurf if canUseMoveSurf?
      done = true
    elsif cmdFly>=0 && command==cmdFly
      useMoveFly if canUseMoveFly?
      done = true
    elsif cmdDive>=0 && command==cmdDive
      useMoveDive if canUseMoveDive?
      done = true
    elsif cmdRockClimb>=0 && command==cmdRockClimb
      useMoveRockClimb if canUseMoveRockClimb?
      done = true
    elsif cmdWaterfall>=0 && command==cmdWaterfall
      useMoveWaterfall if canUseMoveWaterfall?
      done = true
    elsif command==commands.length
      pbPlayCloseMenuSE
      done = true
    else
      pbPlayCloseMenuSE
      done = true
    end
    break if done
  end
end


def pbGiveHMCatalogue
  HMCatalogue.setup
  pbMessage(_INTL("\\me[Key item get]\PN added the HM CATALOGUE to the QOL Access!\\wtnp[75]"))
end

module HMCatalogue
  Obtained = 903
  Cut = 904
  RockSmash = 905
  Strength = 906
  Flash = 907
  Surf = 908
  Fly = 909
  Dive = 910
  RockClimb = 911
  Waterfall = 912

  def self.obtained?
    return $game_switches[HMCatalogue::Obtained]
  end

  def self.setup
    $game_switches[HMCatalogue::Obtained] = true
  end
end

class HM_Catalogue
  attr_accessor :cut
  attr_accessor :rock_smash
  attr_accessor :strength
  attr_accessor :flash
  attr_accessor :surf
  attr_accessor :fly
  attr_accessor :dive
  attr_accessor :rock_climb
  attr_accessor :waterfall

  def initialize
    @cut = false
    @rock_smash = false
    @strength = false
    @flash = false
    @surf = false
    @fly = false
    @dive = false
    @rock_climb = false
    @waterfall = false
  end

  def self.cut
    return $game_switches[HMCatalogue::Cut]
  end

  def self.rock_smash
    return $game_switches[HMCatalogue::RockSmash]
  end

  def self.strength
    return $game_switches[HMCatalogue::Strength]
  end

  def self.flash
    return $game_switches[HMCatalogue::Flash]
  end

  def self.surf
    return $game_switches[HMCatalogue::Surf]
  end

  def self.fly
    return $game_switches[HMCatalogue::Fly]
  end

  def self.dive
    return $game_switches[HMCatalogue::Dive]
  end

  def self.rock_climb
    return $game_switches[HMCatalogue::RockClimb]
  end

  def self.waterfall
    return $game_switches[HMCatalogue::Waterfall]
  end

  def self.cut=(value)
    $game_switches[HMCatalogue::Cut] = value
    @cut = $game_switches[HMCatalogue::Cut]
    return @cut
  end

  def self.rock_smash=(value)
    $game_switches[HMCatalogue::RockSmash] = value
    @rock_smash = $game_switches[HMCatalogue::RockSmash]
    return @rock_smash
  end

  def self.strength=(value)
    $game_switches[HMCatalogue::Strength] = value
    @strength = $game_switches[HMCatalogue::Strength]
    return @strength
  end

  def self.flash=(value)
    $game_switches[HMCatalogue::Flash] = value
    @flash = $game_switches[HMCatalogue::Flash]
    return @flash
  end

  def self.surf=(value)
    $game_switches[HMCatalogue::Surf] = value
    @surf = $game_switches[HMCatalogue::Surf]
    return @surf
  end

  def self.fly=(value)
    $game_switches[HMCatalogue::Fly] = value
    @fly = $game_switches[HMCatalogue::Fly]
    return @fly
  end

  def self.dive=(value)
    $game_switches[HMCatalogue::Dive] = value
    @dive = $game_switches[HMCatalogue::Dive]
    return @dive
  end

  def self.rock_climb=(value)
    $game_switches[HMCatalogue::RockClimb] = value
    @rock_climb = $game_switches[HMCatalogue::RockClimb]
    return @rock_climb
  end

  def self.waterfall=(value)
    $game_switches[HMCatalogue::Waterfall] = value
    @waterfall = $game_switches[HMCatalogue::Waterfall]
    return @waterfall
  end
end

def canUseMoveCut?
  showmsg = true
   return false if HM_Catalogue.cut == false
   facingEvent = $game_player.pbFacingEvent
   if !facingEvent || facingEvent.name != "Tree"
     Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end

def useMoveCut
  Kernel.pbMessage(_INTL("{1} used Cut!",$Trainer.name))
   facingEvent = $game_player.pbFacingEvent
   if facingEvent
     pbSmashEvent(facingEvent)
   end
   return true
end

def canUseMoveDive?
   showmsg = true
   return false if !HM_Catalogue.dive
   if $PokemonGlobal.diving
     return true if DIVINGSURFACEANYWHERE
     divemap = nil
     meta = pbLoadMetadata
     for i in 0...meta.length
       if meta[i] && meta[i][MetadataDiveMap] && meta[i][MetadataDiveMap]==$game_map.map_id
         divemap = i; break
       end
     end
     if !PBTerrain.isDeepWater?($MapFactory.getTerrainTag(divemap,$game_player.x,$game_player.y))
       Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
       return false
     end
   else
     if !pbGetMetadata($game_map.map_id,MetadataDiveMap)
       Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
       return false
     end
     if !PBTerrain.isDeepWater?($game_player.terrain_tag)
       Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
       return false
     end
   end
   return true
end

def useMoveDive
   wasdiving = $PokemonGlobal.diving
   if $PokemonGlobal.diving
     divemap = nil
     meta = pbLoadMetadata
     for i in 0...meta.length
       if meta[i] && meta[i][MetadataDiveMap] && meta[i][MetadataDiveMap]==$game_map.map_id
         divemap = i; break
       end
     end
   else
     divemap = pbGetMetadata($game_map.map_id,MetadataDiveMap)
   end
   return false if !divemap
   if !pbHiddenMoveAnimation(nil)
     Kernel.pbMessage(_INTL("{1} used Dive!",$Trainer.name))
   end
   pbFadeOutIn(99999){
      $game_temp.player_new_map_id    = divemap
      $game_temp.player_new_x         = $game_player.x
      $game_temp.player_new_y         = $game_player.y
      $game_temp.player_new_direction = $game_player.direction
      Kernel.pbCancelVehicles
      (wasdiving) ? $PokemonGlobal.surfing = true : $PokemonGlobal.diving = true
      Kernel.pbUpdateVehicle
      $scene.transfer_player(false)
      $game_map.autoplay
      $game_map.refresh
   }
   return true
end

def pbDive
  useMoveDive if canUseMoveDive?
end

def canUseMoveFlash?
   showmsg = true
   return false if !HM_Catalogue.flash
   if !pbGetMetadata($game_map.map_id,MetadataDarkMap)
     Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   if $PokemonGlobal.flashUsed
     Kernel.pbMessage(_INTL("Flash is already being used.")) if showmsg
     return false
   end
   return true
end

def useMoveFlash
   darkness = $PokemonTemp.darknessSprite
   return false if !darkness || darkness.disposed?
   if !pbHiddenMoveAnimation(nil)
     Kernel.pbMessage(_INTL("{1} used Flash!",$Trainer.name))
   end
   $PokemonGlobal.flashUsed = true
   while darkness.radius<176
     Graphics.update
     Input.update
     pbUpdateSceneMap
     darkness.radius += 4
   end
   return true
end
def canUseMoveFly?
  showmsg = true
  return false if !HM_Catalogue.fly
   if $game_player.pbHasDependentEvents?
     Kernel.pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
     return false
   end
   if !pbGetMetadata($game_map.map_id,MetadataOutdoor)
     Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end

def useMoveFly
  scene=PokemonRegionMap_Scene.new(-1,false)
  screen=PokemonRegionMapScreen.new(scene)
  $PokemonTemp.flydata=screen.pbStartFlyScreen
  if !$PokemonTemp.flydata
    Kernel.pbMessage(_INTL("You didn't lift off here."))
    return
  end
  if !pbHiddenMoveAnimation(nil)
    Kernel.pbMessage(_INTL("{1} used Fly!",$Trainer.name))
  end
  pbFadeOutIn(99999){
    Kernel.pbCancelVehicles
    $game_switches[115] = false
    $game_switches[116] = false
    $game_switches[117] = false
    $game_switches[118] = false
    $game_switches[119] = false
    $game_switches[120] = false
    $game_switches[121] = false
    $game_switches[125] = false
    $game_temp.player_new_map_id=$PokemonTemp.flydata[0]
    $game_temp.player_new_x=$PokemonTemp.flydata[1]
    $game_temp.player_new_y=$PokemonTemp.flydata[2]
    $PokemonTemp.flydata=nil
    $game_temp.player_new_direction=2
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  }
  pbEraseEscapePoint
  return true
end
def canMoveUseRockSmash?
  showmsg = true
  return false if !HM_Catalogue.rock_smash
  facingEvent = $game_player.pbFacingEvent
  if !facingEvent || facingEvent.name!="Rock"
    Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
    return false
  end
  return true
end

def useMoveRockSmash
  if !pbHiddenMoveAnimation(nil)
    Kernel.pbMessage(_INTL("{1} used Rock Smash!",$Trainer.name))
  end
  facingEvent = $game_player.pbFacingEvent
  if facingEvent
    pbSmashEvent(facingEvent)
    pbRockSmashRandomEncounter
    pbRockSmashRandomItem
  end
  return true
end
def canUseMoveStrength?
   showmsg = true
   return false if !HM_Catalogue.strength
   if $PokemonMap.strengthUsed
     Kernel.pbMessage(_INTL("Strength already being used.")) if showmsg
     return false
   end
   return true
end

def useMoveStrength
   if !pbHiddenMoveAnimation(nil)
     Kernel.pbMessage(_INTL("{1} used Strength to move boulders!",$Trainer.name))
   end
   $PokemonMap.strengthUsed = true
   return true
end
def canUseMoveSurf?
   showmsg = true
   return false if !HM_Catalogue.surf
   if $PokemonGlobal.surfing
     Kernel.pbMessage(_INTL("You're already surfing.")) if showmsg
     return false
   end
   if $game_player.pbHasDependentEvents?
     Kernel.pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
     return false
   end
   if pbGetMetadata($game_map.map_id,MetadataBicycleAlways)
     Kernel.pbMessage(_INTL("Let's enjoy cycling!")) if showmsg
     return false
   end
   if !PBTerrain.isSurfable?(Kernel.pbFacingTerrainTag) ||
      !$game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
     Kernel.pbMessage(_INTL("No surfing here!")) if showmsg
     return false
   end
   return true
end
def useMoveSurf
   $game_temp.in_menu = false
   Kernel.pbCancelVehicles
   if !pbHiddenMoveAnimation(nil)
     Kernel.pbMessage(_INTL("{1} used Surf!",$Trainer.name))
   end
   surfbgm = pbGetMetadata(0,MetadataSurfBGM)
   pbCueBGM(surfbgm,0.5) if surfbgm
   pbStartSurfing
   return true
end
def canUseMoveWaterfall?
  showmsg = true
  return false if !HM_Catalogue.waterfall
   if Kernel.pbFacingTerrainTag!=PBTerrain::Waterfall
     Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end

def useMoveWaterfall
   if !pbHiddenMoveAnimation(nil)
     Kernel.pbMessage(_INTL("{1} used Waterfall!",$Trainer.name))
   end
   Kernel.pbAscendWaterfall
   return true
end
def canUseMoveRockClimb?
  showmsg = true
  return false if !HM_Catalogue.rock_climb
   if Kernel.pbFacingTerrainTag!=PBTerrain::RockClimb
     Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end

def useMoveRockClimb
   if !pbHiddenMoveAnimation(nil)
     Kernel.pbMessage(_INTL("{1} used Rock Climb!",$Trainer.name))
   end
   if event.direction=8
     Kernel.pbRockClimbUp
   elsif event.direction=2
     Kernel.pbRockClimbDown
   end
   return true
end
