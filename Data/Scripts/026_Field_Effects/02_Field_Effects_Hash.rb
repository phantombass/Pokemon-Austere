Events.onStartBattle+=proc {|_sender,e|
  $fields.update
}
FIELD_EFFECTS = {
		PBFieldEffects::None => {
			:field_name => "None",
			:intro_message => nil,
			:field_gfx => nil,
			:nature_power => PBMoves::TRIATTACK,
			:mimicry => :NORMAL,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {}, #structure = modifier => [type,flag] where flag sets the kind of modifier.
			#flags are: physical, special, fullhp. fullhp flag cuts damage by the 1/modifier. other flags multiply def mods.
			:type_damage_change => {},
			:type_messages => {},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::EchoChamber => {
			:field_name => "Echo Chamber",
			:intro_message => "A dull echo hums.",
			:field_gfx => "Cave",
			:nature_power => PBMoves::HYPERVOICE,
			:mimicry => :NORMAL,
			:intro_script => nil,
			:abilities => [PBAbilities::SOUNDPROOF,PBAbilities::PUNKROCK],
			:ability_effects => {
				PBAbilities::SOUNDPROOF => [PBStats::SPDEF,1],
				PBAbilities::PUNKROCK => [PBStats::SPATK,1]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {},
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {},
			:type_messages => {},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::HELPINGHAND,PBMoves::ENCORE],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Forest => {
			:field_name => "Forest",
			:intro_message => "Bugs resound through the trees.",
			:field_gfx => "Forest",
			:nature_power => PBMoves::SILVERWIND,
			:mimicry => PBTypes::BUG,
			:intro_script => nil,
			:abilities => [PBAbilities::SWARM],
			:ability_effects => {
			PBAbilities::SWARM => [PBStats::ATTACK,1]
			},
			:move_damage_boost => {},
			:move_messages => {"Bugs caught the wind!" => Fields::WIND_MOVES},
			:move_type_mod => {Fields::WIND_MOVES => PBTypes::BUG},
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {
			1.5 => [PBTypes::BUG,nil]
			},
			:type_damage_change => {
			1.2 => [PBTypes::GRASS,PBTypes::DARK],
			1.3 => [PBTypes::BUG]
			},
			:type_messages => {
			"The forest boosted the attack!" => [PBTypes::GRASS,PBTypes::DARK],
			"It's a swarm!" => [PBTypes::BUG]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::Wildfire => Fields::Fields::IGNITE_MOVES},
			:change_message => {"The forest caught fire!" => Fields::IGNITE_MOVES},
			:field_change_conditions => {PBFieldEffects::Wildfire => Fields.ignite?}
		},
		PBFieldEffects::Desert => {
			:field_name => "Desert",
			:intro_message => "Sand...it gets everywhere...",
			:field_gfx => "Desert",
			:nature_power => PBMoves::EARTHPOWER,
			:mimicry => PBTypes::GROUND,
			:intro_script => nil,
			:abilities => [PBAbilities::SANDRUSH,PBAbilities::SANDFORCE,PBAbilities::SANDVEIL],
			:ability_effects => {},
			:move_damage_boost => {
			1.2 => [Fields::WIND_MOVES]
			},
			:move_messages => {"The desert boosted the wind!" => Fields::WIND_MOVES},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::GROUND,PBTypes::FIRE],
			0.8 => [PBTypes::GRASS,PBTypes::WATER]
			},
			:type_messages => {
			"The desert boosted the attack!" => [PBTypes::FIRE,PBTypes::GROUND],
			"The desert weakened the attack" => [PBTypes::GRASS,PBTypes::WATER]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {"sand" => Fields::WIND_MOVES},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::SHOREUP],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Lava => {
			:field_name => "Lava",
			:intro_message => "Lava flows at your feet.",
			:field_gfx => "Lava",
			:nature_power => PBMoves::LAVAPLUME,
			:mimicry => PBTypes::FIRE,
			:intro_script => nil,
			:abilities => [PBAbilities::FLASHFIRE,PBAbilities::HEATPROOF,PBAbilities::FLASHFIRE,PBAbilities::FLAMEBODY,PBAbilities::MAGMAARMOR,PBAbilities::STEAMENGINE],
			:ability_effects => {
			PBAbilities::HEATPROOF => [PBStats::SPDEF,1],
			PBAbilities::FLAMEBODY => [PBStats::DEFENSE,1],
			PBAbilities::MAGMAARMOR => [PBStats::DEFENSE,1]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::FIRE],
			0.8 => [PBTypes::ICE],
			0.0 => [PBTypes::WATER]
			},
			:type_messages => {
			"The lava boosted the attack!" => [PBTypes::FIRE],
			"The water evaporated!" => [PBTypes::WATER]
			},
			:type_type_change => {PBTypes::WATER => PBTypes::ICE}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {"The lava melted the ice and weakened the attack!" => [PBTypes::ICE]},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::None => PBTypes::ICE},
			:change_message => {"The lava cooled and hardened!" => PBTypes::ICE},
			:field_change_conditions => {}
		},
		PBFieldEffects::ToxicFumes => {
			:field_name => "Toxic Fumes",
			:intro_message => "The haze is nauseating.",
			:field_gfx => "ToxicFumes",
			:nature_power => PBMoves::SLUDGEBOMB,
			:mimicry => PBTypes::POISON,
			:intro_script => nil,
			:abilities => [PBAbilities::POISONHEAL,PBAbilities::TOXICBOOST],
			:ability_effects => {
			PBAbilities::TOXICBOOST => [PBStats::SPEED,1]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {
			100 => [PBMoves::POISONGAS]
			},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::POISON]
			},
			:type_messages => {
			"The fumes strengthened the attack!" => [PBTypes::POISON]
			},
			:type_type_change => {PBTypes::POISON => PBTypes::WATER}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {"The fumes corroded and strengthened the attack!" => [PBTypes::WATER]},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {
			PBFieldEffects::None => Fields::WIND_MOVES,
			PBFieldEffects::Wildfire => Fields::IGNITE_MOVES
			},
			:change_message => {
			"The wind blew away the fumes!" => Fields::WIND_MOVES,
			"The fumes combusted!" => Fields::IGNITE_MOVES
			},
			:field_change_conditions => {PBFieldEffects::Wildfire => Fields.ignite?}
		},
		PBFieldEffects::Wildfire => {
			:field_name => "Wildfire",
			:intro_message => "The field is ablaze.",
			:field_gfx => "Wildfire",
			:nature_power => PBMoves::FLAMETHROWER,
			:mimicry => PBTypes::FIRE,
			:intro_script => nil,
			:abilities => [PBAbilities::FLASHFIRE,PBAbilities::HEATPROOF,PBAbilities::FLASHFIRE,PBAbilities::FLAMEBODY,PBAbilities::MAGMAARMOR,PBAbilities::STEAMENGINE],
			:ability_effects => {
			PBAbilities::HEATPROOF => [PBStats::SPDEF,1],
			PBAbilities::FLAMEBODY => [PBStats::DEFENSE,1],
			PBAbilities::MAGMAARMOR => [PBStats::DEFENSE,1]
			},
			:move_damage_boost => {
				1.2 => Fields::WIND_MOVES
			},
			:move_messages => {"The wind fueled the fire!" => Fields::WIND_MOVES},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::FIRE],
			0.8 => [PBTypes::WATER],
			},
			:type_messages => {
			"The fire boosted the attack!" => [PBTypes::FIRE],
			"The fire weakened the attack!" => [PBTypes::WATER]
			},
			:type_type_change => {PBTypes::FIRE => PBTypes::GRASS}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {"The grass caught fire!" => [PBTypes::GRASS]},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {"cinders" => [Fields::WIND_MOVES]},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::None => [PBMoves::RAINDANCE,PBWeather::Rain]},
			:change_message => {"The rain doused the fire!" => [PBMoves::RAINDANCE,PBWeather::Rain]},
			:field_change_conditions => {}
		},
		PBFieldEffects::Swamp => {
			:field_name => "Swamp",
			:intro_message => "The swamp shifts beneath you.",
			:field_gfx => "Swamp",
			:nature_power => PBMoves::POWERWHIP,
			:mimicry => PBTypes::GRASS,
			:intro_script => nil,
			:abilities => [PBAbilities::SAPSIPPER,PBAbilities::POISONHEAL,PBAbilities::WATERABSORB,PBAbilities::DRYSKIN,PBAbilities::WATERCOMPACTION,PBAbilities::POISONHEAL],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::GRASS,PBTypes::WATER,PBTypes::POISON],
			0.8 => [PBTypes::FIRE,PBTypes::FIGHTING,PBTypes::ROCK],
			},
			:type_messages => {
			"The swamp boosted the attack!" => [PBTypes::GRASS,PBTypes::WATER,PBTypes::POISON],
			"The swamp weakened the attack!" => [PBTypes::FIRE,PBTypes::FIGHTING,PBTypes::ROCK]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::None => Fields::SWAMP_CHANGERS},
			:change_message => {"The rocks covered the swamp." => Fields::SWAMP_CHANGERS},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::City => {
			:field_name => "City",
			:intro_message => "The city hums with activity.",
			:field_gfx => "City",
			:nature_power => PBMoves::GEARGRIND,
			:mimicry => PBTypes::STEEL,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.5 => [PBTypes::ELECTRIC]
			},
			:type_messages => {"The attack drew power from the city." => [PBTypes::ELECTRIC]},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {
			"outage" => PBTypes::ELECTRIC,
			"sound_confuse" => Fields::SOUND_MOVES
			},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {
			PBFieldEffects::None => Fields::QUAKE_MOVES,
			PBFieldEffects::Wildfire => Fields::IGNITE_MOVES,
			PBFieldEffects::Outage => Fields::OUTAGE_MOVES
			},
			:change_message => {
			"The city came crashing down!" => Fields::QUAKE_MOVES,
			"The city caught fire!" => Fields::IGNITE_MOVES,
			"Power outage!" => Fields::OUTAGE_MOVES
			},
			:field_change_conditions => {
				PBFieldEffects::Wildfire => Fields.ignite?,
				PBFieldEffects::Outage => nil
			}
		},
		PBFieldEffects::Ruins => {
			:field_name => "Ruins",
			:intro_message => "The ruins feel strange...",
			:field_gfx => "Ruins",
			:nature_power => PBMoves::PSYSHOCK,
			:mimicry => PBTypes::PSYCHIC,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {
			2.0 => [PBTypes::PSYCHIC,"fullhp"]
			},
			:type_damage_change => {
			1.2 => [PBTypes::PSYCHIC,PBTypes::GRASS,PBTypes::FIRE,PBTypes::WATER]
			},
			:type_messages => {"The ruins boosted the attack!" => [PBTypes::PSYCHIC,PBTypes::GRASS,PBTypes::FIRE,PBTypes::WATER]},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {
			PBTypes::ROCK => [PBTypes::PSYCHIC]
			}, #if a type gets added due to the field
			:type_mod_message => {
			"The ruins were added to the attack!" => [PBTypes::PSYCHIC]
			},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::CALMMIND,PBMoves::AMNESIA,PBMoves::MEDITATE,PBMoves::BARRIER],
			:field_changers => {PBFieldEffects::None => Fields::QUAKE_MOVES},
			:change_message => {"The ruins were destroyed!" => Fields::QUAKE_MOVES},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Grassy => {
			:field_name => "Grassy",
			:intro_message => "Grass covers the field.",
			:field_gfx => "Grassy",
			:nature_power => PBMoves::ENERGYBALL,
			:mimicry => PBTypes::GRASS,
			:intro_script => nil,
			:abilities => [PBAbilities::GRASSPELT,PBAbilities::SAPSIPPER,PBAbilities::LEAFGUARD,PBAbilities::FLOWERVEIL],
			:ability_effects => {
			PBAbilities::LEAFGUARD => [PBStats::DEFENSE,1],
			PBAbilities::FLOWERVEIL => [PBStats::DEFENSE,1]
			},
			:move_damage_boost => {
			1.2 => Fields::WIND_MOVES
			},
			:move_messages => {
			"The wind blows through the grass." => Fields::WIND_MOVES
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {
			1.5 => [PBTypes::BUG,nil]
			},
			:type_damage_change => {
			1.2 => [PBTypes::GRASS,PBTypes::FAIRY,PBTypes::BUG]
			},
			:type_messages => {"The grass strengthened the attack!" => [PBTypes::GRASS,PBTypes::FAIRY,PBTypes::BUG]},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::GROWTH],
			:field_changers => {PBFieldEffects::Wildfire => Fields::IGNITE_MOVES},
			:change_message => {"The grass caught fire!" => Fields::IGNITE_MOVES},
			:field_change_conditions => {PBFieldEffects::Wildfire => Fields.ignite?}
		}, 
		PBFieldEffects::JetStream => {
			:field_name => "JetStream",
			:intro_message => "A strong wind blows through.",
			:field_gfx => "Jet Stream",
			:nature_power => PBMoves::AIRSLASH,
			:mimicry => PBTypes::FLYING,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {
			100 => [Fields::WIND_MOVES]
			},
			:defensive_modifiers => {
			1.2 => [PBTypes::FLYING,"physical"]
			},
			:type_damage_change => {
			0.8 => [PBTypes::ELECTRIC,PBTypes::FIRE,PBTypes::ROCK,PBTypes::ICE]
			},
			:type_messages => {"The jet stream weakened the attack." => [PBTypes::ELECTRIC,PBTypes::FIRE,PBTypes::ROCK,PBTypes::ICE]},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::TAILWIND],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Mountain => {
			:field_name => "Mountainside",
			:intro_message => "The mountain air is refreshing.",
			:field_gfx => "Mountainside",
			:nature_power => PBMoves::ROCKSLIDE,
			:mimicry => PBTypes::ROCK,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {
			1.2 => [Fields::WIND_MOVES, Fields::SOUND_MOVES]
			},
			:move_messages => {
			"The mountain gales boosted the wind!" => Fields::WIND_MOVES,
			"The loud noises brought rocks down!" => Fields::SOUND_MOVES
			},
			:move_type_mod => {
			PBTypes::ROCK => [Fields::SOUND_MOVES]
			}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ROCK]
			},
			:type_messages => {"Rocks from the mountain joined in." => PBTypes::ROCK},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::SnowMountain => {
			:field_name => "Snowy Mountainside",
			:intro_message => "Snow covers the mountain.",
			:field_gfx => "Snow Mountain",
			:nature_power => PBMoves::AVALANCHE,
			:mimicry => PBTypes::ICE,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {
			PBTypes::ICE => [Fields::SOUND_MOVES]
			}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ICE]
			},
			:type_messages => {"Avalanche!" => [PBTypes::ICE]},
			:type_type_change => {
			PBTypes::ICE => [PBTypes::ROCK]
			},
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Water => {
			:field_name => "Water",
			:intro_message => "The water is calm.",
			:field_gfx => "Water",
			:nature_power => PBMoves::SURF,
			:mimicry => PBTypes::WATER,
			:intro_script => nil,
			:abilities => [PBAbilities::WATERABSORB,PBAbilities::DRYSKIN,::PBAbilities::WATERCOMPACTION,PBAbilities::WATERVEIL],
			:ability_effects => {
			PBAbilities::WATERVEIL => [PBStats::EVASION,1]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::WATER],
			0.8 => [PBTypes::FIRE]
			},
			:type_messages => {
			"The attack rode the current." => [PBTypes::WATER],
			"The water weakened the attack." => [PBTypes::FIRE]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Underwater => {
			:field_name => "Water",
			:intro_message => "Bloop bloop...",
			:field_gfx => "Underwater",
			:nature_power => PBMoves::WATERPULSE,
			:mimicry => PBTypes::WATER,
			:intro_script => nil,
			:abilities => [PBAbilities::WATERABSORB,PBAbilities::DRYSKIN,::PBAbilities::WATERCOMPACTION,PBAbilities::WATERVEIL],
			:ability_effects => {
			PBAbilities::WATERVEIL => [PBStats::EVASION,1]
			},
			:move_damage_boost => {
			1.2 => [Fields::PULSE_MOVES,Fields::SOUND_MOVES],
			},
			:move_messages => {
			"The depths boosted the attack." => [Fields::PULSE_MOVES,Fields::SOUND_MOVES],
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::WATER],
			0.0 => [PBTypes::FIRE]
			},
			:type_messages => {
			"The depths boosted the attack." => [PBTypes::WATER],
			"The water put the fire out." => [PBTypes::FIRE]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},  
		PBFieldEffects::Psychic => {
			:field_name => "Psychic",
			:intro_message => "The battlefield is weird.",
			:field_gfx => "Psychic",
			:nature_power => PBMoves::PSYCHIC,
			:mimicry => PBTypes::PSYCHIC,
			:intro_script => nil,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::PSYCHIC]
			},
			:type_messages => {
			"The psychic terrain boosted the attack." => [PBTypes::PSYCHIC]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::CALMMIND,PBMoves::MEDITATE,PBMoves::TRICKROOM,Fields::HEALING_MOVES],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Misty => {
			:field_name => "Misty",
			:intro_message => "Mist covers the battlefield.",
			:field_gfx => "Misty",
			:nature_power => PBMoves::MOONBLAST,
			:mimicry => PBTypes::FAIRY,
			:intro_script => nil,
			:abilities => [PBAbilities::AROMAVEIL,PBAbilities::SWEETVEIL],
			:ability_effects => {
			PBAbilities::AROMAVEIL => [PBStats::DEFENSE,1],
			PBAbilities::SWEETVEIL => [PBStats::SPDEF,1]
			},
			:move_damage_boost => {
			1.2 => Fields::LIGHT_MOVES
			},
			:move_messages => {"The misty terrain boosted the attack." => Fields::LIGHT_MOVES},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::FAIRY],
			0.8 => [PBTypes::DRAGON]
			},
			:type_messages => {
			"The misty terrain boosted the attack." => [PBTypes::FAIRY],
			"The misty terrain weakened the attack." => [PBTypes::DRAGON]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Electric => {
			:field_name => "Electric",
			:intro_message => "Electricity runs across the battlefield.",
			:field_gfx => "Electric",
			:nature_power => PBMoves::THUNDERBOLT,
			:mimicry => PBTypes::ELECTRIC,
			:intro_script => nil,
			:abilities => [PBAbilities::VOLTABSORB,PBAbilities::LIGHTNINGROD,PBAbilities::MOTORDRIVE,PBAbilities::PLUS,PBAbilities::MINUS],
			:ability_effects => {
			PBAbilities::PLUS => [PBStats::SPATK,2],
			PBAbilities::MINUS => [PBStats::SPATK,2]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ELECTRIC]
			},
			:type_messages => {
			"The electric terrain boosted the attack." => [PBTypes::ELECTRIC]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Digital => {
			:field_name => "Digital",
			:intro_message => "Battle initializing...",
			:field_gfx => "Digital",
			:nature_power => PBMoves::DISCHARGE,
			:mimicry => PBTypes::ELECTRIC,
			:intro_script => nil,
			:abilities => [PBAbilities::VOLTABSORB,PBAbilities::LIGHTNINGROD,PBAbilities::MOTORDRIVE,PBAbilities::PLUS,PBAbilities::MINUS,PBAbilities::DOWNLOAD],
			:ability_effects => {
			PBAbilities::PLUS => [PBStats::SPATK,2],
			PBAbilities::MINUS => [PBStats::SPATK,2]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ELECTRIC]
			},
			:type_messages => {
			"Register power boost..." => [PBTypes::ELECTRIC]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Machine => {
			:field_name => "Machine",
			:intro_message => "Machines surround the area.",
			:field_gfx => "Machine",
			:nature_power => PBMoves::CHARGEBEAM,
			:mimicry => PBTypes::ELECTRIC,
			:intro_script => "machine",
			:abilities => [PBAbilities::VOLTABSORB,PBAbilities::LIGHTNINGROD,PBAbilities::MOTORDRIVE,PBAbilities::PLUS,PBAbilities::MINUS,PBAbilities::DOWNLOAD],
			:ability_effects => {
			PBAbilities::PLUS => [PBStats::SPATK,2],
			PBAbilities::MINUS => [PBStats::SPATK,2]
			},
			:move_damage_boost => {
			1.2 => Fields::OUTAGE_MOVES,
			1.3 => Fields::MACHINE_MOVES
			},
			:move_messages => {
			"The machines powered the attack!" => Fields::MACHINE_MOVES,
			"The attack drew power from the machinery!" => Fields::OUTAGE_MOVES
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::STEEL]
			},
			:type_messages => {
			"The machinery joined the attack!" => [PBTypes::STEEL]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {
			"short" => Fields::OUTAGE_MOVES
			},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::ShortOut => Fields::OUTAGE_MOVES},
			:change_message => {"The field shorted out!" => Fields::OUTAGE_MOVES},
			:field_change_conditions => {PBFieldEffects::ShortOut => nil}
		},
		PBFieldEffects::ShortOut => {
			:field_name => "Short Out",
			:intro_message => "The machines are silent.",
			:field_gfx => "Short",
			:nature_power => PBMoves::DARKPULSE,
			:mimicry => PBTypes::DARK,
			:intro_script => "shortout",
			:abilities => [PBAbilities::JUSTIFIED,PBAbilities::RATTLED],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::DARK,PBTypes::GHOST]
			},
			:type_messages => {
			"The darkness powered the attack!" => [PBTypes::DARK],
			"The shadows powered the attack!" => [PBTypes::GHOST]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {
			"recharge" => Fields::CHARGE_MOVES
			},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::Machine => Fields::CHARGE_MOVES},
			:change_message => {"The electricity powered up the machinery!" => Fields::CHARGE_MOVES},
			:field_change_conditions => {PBFieldEffects::Machine => nil}
		},
		PBFieldEffects::Outage => {
			:field_name => "Outage",
			:intro_message => "The city is dark.",
			:field_gfx => "City_Night",
			:nature_power => PBMoves::DARKPULSE,
			:mimicry => PBTypes::DARK,
			:intro_script => nil,
			:abilities => [PBAbilities::JUSTIFIED,PBAbilities::RATTLED],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::DARK,PBTypes::GHOST]
			},
			:type_messages => {
			"The city's darkness powered the attack!" => [PBTypes::DARK],
			"The shadows powered the attack!" => [PBTypes::GHOST]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::City => Fields::CHARGE_MOVES},
			:change_message => {"The electricity powered up the city!" => Fields::CHARGE_MOVES},
			:field_change_conditions => {PBFieldEffects::City => nil}
		},
		PBFieldEffects::Space => {
			:field_name => "Space",
			:intro_message => "The stars glimmer dimly.",
			:field_gfx => "Space",
			:nature_power => PBMoves::DARKPULSE,
			:mimicry => PBTypes::DARK,
			:intro_script => nil,
			:abilities => [PBAbilities::JUSTIFIED,PBAbilities::RATTLED],
			:ability_effects => {},
			:move_damage_boost => {
			1.2 => [Fields::LIGHT_MOVES]
			},
			:move_messages => {
			"The light is blinding!" => Fields::LIGHT_MOVES
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::DARK,PBTypes::GHOST],
			0.0 => [PBTypes::GROUND,Fields::SOUND_MOVES]
			},
			:type_messages => {
			"The darkness powered the attack!" => [PBTypes::DARK,PBTypes::GHOST]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::MOONLIGHT],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Monsoon => {
			:field_name => "Monsoon",
			:intro_message => "The storm is howling.",
			:field_gfx => "Monsoon",
			:nature_power => PBMoves::HURRICANE,
			:mimicry => PBTypes::FLYING,
			:intro_script => nil,
			:abilities => [PBAbilities::RAINDISH,PBAbilities::STORMDRAIN,PBAbilities::DRYSKIN,PBAbilities::WATERABSORB,PBAbilities::WATERCOMPACTION],
			:ability_effects => {},
			:move_damage_boost => {
			1.2 => Fields::WIND_MOVES
			},
			:move_messages => {
			"The winds picked up!" => Fields::WIND_MOVES
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {
			100 => [PBMoves::HURRICANE,PBMoves::THUNDER]
			},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::WATER,PBTypes::ROCK],
			0.0 => [PBTypes::FIRE]
			},
			:type_messages => {
			"The rocks flew around!" => [PBTypes::ROCK],
			"The water whipped in the wind!" => [PBTypes::WATER],
			"The fire fizzled out!" => [PBTypes::FIRE]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		}, 
	    PBFieldEffects::Graveyard => {
			:field_name => "Graveyard",
			:intro_message => "The headstones are creepy...",
			:field_gfx => "Graveyard",
			:nature_power => PBMoves::SHADOWBALL,
			:mimicry => PBTypes::GHOST,
			:intro_script => nil,
			:abilities => [PBAbilities::CURSEDBODY,PBAbilities::RATTLED,PBAbilities::PERISHBODY,PBAbilities::SHADOWSHIELD],
			:ability_effects => {
			PBAbilities::CURSEDBODY => [PBStats::DEFENSE,1],
			PBAbilities::PERISHBODY => [PBStats::DEFENSE,1],
			PBAbilities::SHADOWSHIELD => [PBStats::DEFENSE,1]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {
			2.0 => [PBTypes::GHOST,"fullhp"]
			},
			:type_damage_change => {
			1.2 => [PBTypes::GHOST]
			},
			:type_messages => {
			"The spirits joined the attack!" => [PBTypes::GHOST]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {"disturb" => Fields::KICKING_MOVES},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::MOONLIGHT],
			:field_changers => {PBFieldEffects::None => Fields::QUAKE_MOVES},
			:change_message => {"The graves were razed!" => Fields::QUAKE_MOVES},
			:field_change_conditions => {}
		}, 
	    PBFieldEffects::Foundry => {
			:field_name => "Foundry",
			:intro_message => "Machinery hums in the background.",
			:field_gfx => "Foundry",
			:nature_power => PBMoves::FLASHCANNON,
			:mimicry => PBTypes::STEEL,
			:intro_script => nil,
			:abilities => [PBAbilities::STEELWORKER,PBAbilities::IRONFIST,PBAbilities::HEATPROOF,PBAbilities::FLASHFIRE,PBAbilities::FLAMEBODY,PBAbilities::MAGMAARMOR],
			:ability_effects => {
			PBAbilities::STEELWORKER => [PBStats::ATTACK,1],
			PBAbilities::IRONFIST => [PBStats::ATTACK,1],
			PBAbilities::HEATPROOF => [PBStats::SPDEF,1],
			PBAbilities::MAGMAARMOR => [PBStats::DEFENSE,1],
			PBAbilities::FLAMEBODY => [PBStats::DEFENSE,1],
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::STEEL,PBTypes::FIRE],
			0.8 => [PBTypes::WATER]
			},
			:type_messages => {
			"The foundry fortfied the attack!" => [PBTypes::STEEL],
			"The foundry intensified the heat!" => [PBTypes::FIRE],
			"The heat from the foundry weakened the attack!" => [PBTypes::WATER]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::Lava => Fields::QUAKE_MOVES},
			:change_message => {"The foundry collapsed and molten metal spilled!" => Fields::QUAKE_MOVES},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Dojo => {
			:field_name => "Dojo",
			:intro_message => "En garde!",
			:field_gfx => "Dojo",
			:nature_power => PBMoves::BRICKBREAK,
			:mimicry => PBTypes::FIGHTING,
			:intro_script => nil,
			:abilities => [PBAbilities::INNERFOCUS,PBAbilities::STEADFAST,PBAbilities::IRONFIST,PBAbilities::SCRAPPY],
			:ability_effects => {
				PBAbilities::INNERFOCUS => [PBStats::ATTACK,1],
				PBAbilities::STEADFAST => [PBStats::SPEED,1],
				PBAbilities::IRONFIST => [PBStats::ATTACK,1],
				PBAbilities::SCRAPPY => [PBStats::ATTACK,1]
			},
			:move_damage_boost => {
			1.2 => [Fields::KICKING_MOVES,Fields::PUNCHING_MOVES,Fields::SLICING_MOVES]
			},
			:move_messages => {
			"Hyah!" => [Fields::KICKING_MOVES,Fields::PUNCHING_MOVES,Fields::SLICING_MOVES]
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::FIGHTING,PBTypes::PSYCHIC]
			},
			:type_messages => {
			"With great focus!" => [PBTypes::FIGHTING,PBTypes::PSYCHIC]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::CALMMIND,PBMoves::BULKUP,PBMoves::MEDITATE,PBMoves::AGILITY],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		},
		PBFieldEffects::Castle => {
			:field_name => "Castle",
			:intro_message => "The kingdom stands strong.",
			:field_gfx => "Castle",
			:nature_power => PBMoves::IRONHEAD,
			:mimicry => PBTypes::STEEL,
			:intro_script => nil,
			:abilities => [PBAbilities::BATTLEARMOR,PBAbilities::SHELLARMOR,PBAbilities::STANCECHANGE,PBAbilities::SHADOWSHIELD,PBAbilities::LEAFGUARD,PBAbilities::MAGICGUARD],
			:ability_effects => {
				PBAbilities::BATTLEARMOR => [PBStats::DEFENSE,1],
				PBAbilities::SHELLARMOR => [PBStats::DEFENSE,1],
				PBAbilities::SHADOWSHIELD => [PBStats::DEFENSE,1],
				PBAbilities::LEAFGUARD => [PBStats::DEFENSE,1],
				PBAbilities::MAGICGUARD => [PBStats::SPDEF,1],
				PBAbilities::STANCECHANGE => [PBStats::SPEED,1]
			},
			:move_damage_boost => {
			1.2 => [Fields::BOMB_MOVES,Fields::SLICING_MOVES],
			0.8 => [Fields::WIND_MOVES]
			},
			:move_messages => {
			"For the kingdom!" => [Fields::PUNCHING_MOVES,Fields::SLICING_MOVES],
			"The wall weakened the wind!" => [Fields::WIND_MOVES]
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ROCK,PBTypes::STEEL,PBTypes::FAIRY],
			0.8 => [PBTypes::FIGHTING,PBTypes::FLYING]
			},
			:type_messages => {
			"All for one!" => [PBTypes::ROCK,PBTypes::STEEL,PBTypes::FAIRY],
			"The castle's defenses weakened the attack!" => [PBTypes::FIGHTING,PBTypes::FLYING]
			},
			:type_type_change => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_mod_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::SWORDSDANCE,PBMoves::IRONDEFENSE,PBMoves::KINGSSHIELD],
			:field_changers => {PBFieldEffects::None => Fields::QUAKE_MOVES},
			:change_message => {"The castle crumbled to the ground!" => Fields::QUAKE_MOVES},
			:field_change_conditions => {}
		}
	}
	
