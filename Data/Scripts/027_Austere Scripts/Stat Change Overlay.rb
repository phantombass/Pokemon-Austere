class Bitmap
  attr_accessor :storedPath
end

class PokemonDataBox < SpriteWrapper
  def initializeOtherGraphics(viewport)
    # Create other bitmaps
    @numbersBitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/icon_numbers"))
    @hpBarBitmap   = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/overlay_hp"))
    @expBarBitmap  = AnimatedBitmap.new(_INTL("Graphics/Pictures/Battle/overlay_exp"))
    @sprites["Atk"]  = Sprite.new(viewport)
    @sprites["Def"]  = Sprite.new(viewport)
    @sprites["SpAtk"]  = Sprite.new(viewport)
    @sprites["SpDef"]  = Sprite.new(viewport)
    @sprites["Spe"]  = Sprite.new(viewport)
    @sprites["Eva"]  = Sprite.new(viewport)
    @sprites["Acc"]  = Sprite.new(viewport)
    @sprites["Atk"].visible = false
    @sprites["Def"].visible = false
    @sprites["SpAtk"].visible = false
    @sprites["SpDef"].visible = false
    @sprites["Spe"].visible = false
    @sprites["Eva"].visible = false
    @sprites["Acc"].visible = false
    @sprites["Atk"].z = 99999
    @sprites["Def"].z = 99999
    @sprites["SpAtk"].z = 99999
    @sprites["SpDef"].z = 99999
    @sprites["Spe"].z = 99999
    @sprites["Eva"].z = 99999
    @sprites["Acc"].z = 99999
    # Create sprite to draw HP numbers on
    @hpNumbers = BitmapSprite.new(124,16,viewport)
    pbSetSmallFont(@hpNumbers.bitmap)
    @sprites["hpNumbers"] = @hpNumbers
    # Create sprite wrapper that displays HP bar
    @hpBar = SpriteWrapper.new(viewport)
    @hpBar.bitmap = @hpBarBitmap.bitmap
    @hpBar.src_rect.height = @hpBarBitmap.height/3
    @sprites["hpBar"] = @hpBar
    # Create sprite wrapper that displays Exp bar
    @expBar = SpriteWrapper.new(viewport)
    @expBar.bitmap = @expBarBitmap.bitmap
    @sprites["expBar"] = @expBar
    # Create sprite wrapper that displays everything except the above
    @contents = BitmapWrapper.new(@databoxBitmap.width,@databoxBitmap.height)
    self.bitmap  = @contents
    self.visible = false
    self.z       = 150+((@battler.index)/2)*5
    pbSetSystemFont(self.bitmap)
  end

  def pbBitmap(name)
    begin
      dir = name.split("/")[0...-1].join("/") + "/"
      file = name.split("/")[-1]
      bmp = RPG::Cache.load_bitmap(dir, file)
      bmp.storedPath = name
    rescue
      Console.echo _INTL("Image located at '#{name}' was not found!")
      bmp = Bitmap.new(2,2)
    end
    return bmp
  end

  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    textPos = []
    imagePos = []
    stat_boost = []
    $stages = stat_boost
    # Draw background panel
    self.bitmap.blt(0,0,@databoxBitmap.bitmap,Rect.new(0,0,@databoxBitmap.width,@databoxBitmap.height))
    # Draw Pokémon's name
    nameWidth = self.bitmap.text_size(@battler.name).width
    nameOffset = 0
    nameOffset = nameWidth-116 if nameWidth>116
    if @showHP
      textPos.push([@battler.name,@spriteBaseX+0,-8,false,NAME_BASE_COLOR,NAME_SHADOW_COLOR])
    else
      textPos.push([@battler.name,@spriteBaseX-12,-8,false,NAME_BASE_COLOR,NAME_SHADOW_COLOR])
    end
    # Draw Pokémon's gender symbol
    case @battler.displayGender
    when 0   # Male
      if @showHP
        textPos.push([_INTL("♂"),@spriteBaseX+112,10,false,MALE_BASE_COLOR,MALE_SHADOW_COLOR])
      else
        textPos.push([_INTL("♂"),@spriteBaseX+116,10,false,MALE_BASE_COLOR,MALE_SHADOW_COLOR])
      end
    when 1   # Female
      if @showHP
        textPos.push([_INTL("♀"),@spriteBaseX+114,10,false,FEMALE_BASE_COLOR,FEMALE_SHADOW_COLOR])
      else
        textPos.push([_INTL("♀"),@spriteBaseX+122,10,false,FEMALE_BASE_COLOR,FEMALE_SHADOW_COLOR])
      end
    end
    pbDrawTextPositions(self.bitmap,textPos)
    # Draw shiny icon
    if @battler.shiny?
      shinyX = (@battler.opposes?(0)) ? 206 : 0   # Foe's/player's
      imagePos.push(["Graphics/Pictures/shiny",@spriteBaseX+shinyX,16])
    end
    # Draw Mega Evolution/Primal Reversion icon
    if @battler.mega?
      if @battler.shiny?
        imagePos.push(["Graphics/Pictures/Battle/icon_mega",@spriteBaseX+18,16])
      else
        imagePos.push(["Graphics/Pictures/Battle/icon_mega",@spriteBaseX+0,16])
      end
    elsif @battler.primal?
      if @battler.shiny?
        if @battler.isSpecies?(:KYOGRE)
          imagePos.push(["Graphics/Pictures/Battle/icon_primal_Kyogre",@spriteBaseX+18,16])
        elsif @battler.isSpecies?(:GROUDON)
          imagePos.push(["Graphics/Pictures/Battle/icon_primal_Groudon",@spriteBaseX+18,16])
        end
      else
        if @battler.isSpecies?(:KYOGRE)
          imagePos.push(["Graphics/Pictures/Battle/icon_primal_Kyogre",@spriteBaseX+0,16])
        elsif @battler.isSpecies?(:GROUDON)
          imagePos.push(["Graphics/Pictures/Battle/icon_primal_Groudon",@spriteBaseX+0,16])
        end
      end
    end
    # Draw owned icon (foe Pokémon only)
    if @battler.owned? && @battler.opposes?(0)
      imagePos.push(["Graphics/Pictures/Battle/icon_own",@spriteBaseX-12,16])
    end
    if @sideSize < 2
      i = @battler.stages[PBStats::ATTACK]
      j = @battler.stages[PBStats::DEFENSE]
      k = @battler.stages[PBStats::SPATK]
      l = @battler.stages[PBStats::SPDEF]
      m = @battler.stages[PBStats::SPEED]
      n = @battler.stages[PBStats::EVASION]
      o = @battler.stages[PBStats::ACCURACY]
      stat_boost.push(i)
      stat_boost.push(j)
      stat_boost.push(k)
      stat_boost.push(l)
      stat_boost.push(m)
      stat_boost.push(n)
      stat_boost.push(o)
      @stat_path_atk =  "Graphics/Pictures/Stat Overlay/Atk#{$stages[0]}"
      @stat_path_def = "Graphics/Pictures/Stat Overlay/Def#{$stages[1]}"
      @stat_path_spatk = "Graphics/Pictures/Stat Overlay/SpAtk#{$stages[2]}"
      @stat_path_spdef = "Graphics/Pictures/Stat Overlay/SpDef#{$stages[3]}"
      @stat_path_spe = "Graphics/Pictures/Stat Overlay/Spe#{$stages[4]}"
      @stat_path_eva = "Graphics/Pictures/Stat Overlay/Eva#{$stages[5]}"
      @stat_path_acc = "Graphics/Pictures/Stat Overlay/Acc#{$stages[6]}"
      statX = (@battler.opposes?) ? @spriteX + 265 : @spriteX - 120
      statY = (@battler.opposes?) ? @spriteY + 2 : @spriteY - 30
      if !pbInSafari?
        @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
        @sprites["Atk"].visible = $stages[0] != 0 ? true : false
        @sprites["Atk"].x = statX
        @sprites["Atk"].y = statY
        @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
        @sprites["Def"].visible = $stages[1] != 0 ? true : false
        @sprites["Def"].x = statX
        @sprites["Def"].y = statY + 16
        @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
        @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
        @sprites["SpAtk"].x = statX
        @sprites["SpAtk"].y = statY + 32
        @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
        @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
        @sprites["SpDef"].x = statX
        @sprites["SpDef"].y = statY + 48
        @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
        @sprites["Spe"].visible = $stages[4] != 0 ? true : false
        @sprites["Spe"].x = statX
        @sprites["Spe"].y = statY + 64
        @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
        @sprites["Eva"].visible = $stages[5] != 0 ? true : false
        @sprites["Eva"].x = statX
        @sprites["Eva"].y = statY + 80
        @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
        @sprites["Acc"].visible = $stages[6] != 0 ? true : false
        @sprites["Acc"].x = statX
        @sprites["Acc"].y = statY + 96
      end
    end
    # Draw status icon if status, otherwise the level is shown
    if @battler.status>0
      s = @battler.status
      s = 6 if s==PBStatuses::POISON && @battler.statusCount>0   # Badly poisoned
      imagePos.push(["Graphics/Pictures/Battle/icon_statuses",@spriteBaseX+60,16, #0,16
         0,(s-1)*STATUS_ICON_HEIGHT,-1,STATUS_ICON_HEIGHT])
	else
	  if @showHP
	    if @battler.level != 100
          imagePos.push(["Graphics/Pictures/Battle/overlay_lv",@spriteBaseX+66,20])
		end
		if @battler.level == 100
          pbDrawNumber(@battler.level,self.bitmap,@spriteBaseX+64,18)
		else
		  pbDrawNumber(@battler.level,self.bitmap,@spriteBaseX+80,18)
		end
      else
	    if @battler.level != 100
          imagePos.push(["Graphics/Pictures/Battle/overlay_lv",@spriteBaseX+70,20])
		end
		if @battler.level == 100
		  pbDrawNumber(@battler.level,self.bitmap,@spriteBaseX+68,18)
		else
          pbDrawNumber(@battler.level,self.bitmap,@spriteBaseX+84,18)
		end
      end
    end
    pbDrawImagePositions(self.bitmap,imagePos)
    refreshHP
    refreshExp
  end

  def overlay_refresh
    stat_boost = []
    $stages = stat_boost
    i = @battler.stages[PBStats::ATTACK]
    j = @battler.stages[PBStats::DEFENSE]
    k = @battler.stages[PBStats::SPATK]
    l = @battler.stages[PBStats::SPDEF]
    m = @battler.stages[PBStats::SPEED]
    n = @battler.stages[PBStats::EVASION]
    o = @battler.stages[PBStats::ACCURACY]
    stat_boost.push(i)
    stat_boost.push(j)
    stat_boost.push(k)
    stat_boost.push(l)
    stat_boost.push(m)
    stat_boost.push(n)
    stat_boost.push(o)
    @stat_path_atk =  "Graphics/Pictures/Stat Overlay/Atk#{$stages[0]}"
    @stat_path_def = "Graphics/Pictures/Stat Overlay/Def#{$stages[1]}"
    @stat_path_spatk = "Graphics/Pictures/Stat Overlay/SpAtk#{$stages[2]}"
    @stat_path_spdef = "Graphics/Pictures/Stat Overlay/SpDef#{$stages[3]}"
    @stat_path_spe = "Graphics/Pictures/Stat Overlay/Spe#{$stages[4]}"
    @stat_path_eva = "Graphics/Pictures/Stat Overlay/Eva#{$stages[5]}"
    @stat_path_acc = "Graphics/Pictures/Stat Overlay/Acc#{$stages[6]}"
    statX = (@battler.opposes?) ? @spriteX + 265 : @spriteX - 120
    statY = (@battler.opposes?) ? @spriteY + 2 : @spriteY - 30
    if !pbInSafari?
      @sprites["Atk"].bitmap = $stages[0] != 0 ? pbBitmap(@stat_path_atk) : nil
      @sprites["Atk"].visible = $stages[0] != 0 ? true : false
      @sprites["Atk"].x = statX
      @sprites["Atk"].y = statY
      @sprites["Def"].bitmap = $stages[1] != 0 ? pbBitmap(@stat_path_def) : nil
      @sprites["Def"].visible = $stages[1] != 0 ? true : false
      @sprites["Def"].x = statX
      @sprites["Def"].y = statY + 16
      @sprites["SpAtk"].bitmap = $stages[2] != 0 ? pbBitmap(@stat_path_spatk) : nil
      @sprites["SpAtk"].visible = $stages[2] != 0 ? true : false
      @sprites["SpAtk"].x = statX
      @sprites["SpAtk"].y = statY + 32
      @sprites["SpDef"].bitmap = $stages[3] != 0 ? pbBitmap(@stat_path_spdef) : nil
      @sprites["SpDef"].visible = $stages[3] != 0 ? true : false
      @sprites["SpDef"].x = statX
      @sprites["SpDef"].y = statY + 48
      @sprites["Spe"].bitmap = $stages[4] != 0 ? pbBitmap(@stat_path_spe) : nil
      @sprites["Spe"].visible = $stages[4] != 0 ? true : false
      @sprites["Spe"].x = statX
      @sprites["Spe"].y = statY + 64
      @sprites["Eva"].bitmap = $stages[5] != 0 ? pbBitmap(@stat_path_eva) : nil
      @sprites["Eva"].visible = $stages[5] != 0 ? true : false
      @sprites["Eva"].x = statX
      @sprites["Eva"].y = statY + 80
      @sprites["Acc"].bitmap = $stages[6] != 0 ? pbBitmap(@stat_path_acc) : nil
      @sprites["Acc"].visible = $stages[6] != 0 ? true : false
      @sprites["Acc"].x = statX
      @sprites["Acc"].y = statY + 96
    end
  end

  def update(frameCounter=0)
    super()
    # Animate HP bar
    updateHPAnimation
    # Animate Exp bar
    updateExpAnimation
    # Update coordinates of the data box
    updatePositions(frameCounter)
    overlay_refresh if @sideSize < 2
    pbUpdateSpriteHash(@sprites)
  end
end
