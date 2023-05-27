FIELD_EFFECTS = {
		PBFieldEffects::None => {
			:field_name => "None",
			:intro_message => nil,
			:field_gfx => nil,
			:nature_power => PBMoves::TRIATTACK,
			:mimicry => :NORMAL,
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {},
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {},
			:type_messages => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {PBTypes::WATER => PBTypes::ICE}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {"The lava melted the ice and weakened the attack!" => [PBTypes::ICE]},
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
			:type_type_mod => {PBTypes::POISON => PBTypes::WATER}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {"The fumes corroded and strengthened the attack!" => [PBTypes::WATER]},
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
			:type_type_mod => {PBTypes::FIRE => PBTypes::GRASS}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {"The grass caught fire!" => [PBTypes::GRASS]},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:field_change_conditions => {PBFieldEffects::Wildfire => Fields.ignite?}
		},
		PBFieldEffects::Ruins => {
			:field_name => "Ruins",
			:intro_message => "The ruins feel strange...",
			:field_gfx => "Ruins",
			:nature_power => PBMoves::DRAGONPULSE,
			:mimicry => PBTypes::DRAGON,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {
			2.0 => [PBTypes::GHOST,"fullhp"]
			},
			:type_damage_change => {
			1.2 => [PBTypes::DRAGON,PBTypes::GHOST,PBTypes::GRASS,PBTypes::FIRE,PBTypes::WATER]
			},
			:type_messages => {"The ruins boosted the attack!" => [PBTypes::DRAGON,PBTypes::GHOST,PBTypes::GRASS,PBTypes::FIRE,PBTypes::WATER]},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::DRAGONDANCE],
			:field_changers => {},
			:change_message => {},
			:field_change_conditions => {}
		}, 
		PBFieldEffects::Grassy => {
			:field_name => "Grassy",
			:intro_message => "Grass covers the field.",
			:field_gfx => "Grassy",
			:nature_power => PBMoves::ENERGYBALL,
			:mimicry => PBTypes::GRASS,
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::GROWTH],
			:field_changers => {PBFieldEffects::Wildfire => Fields::IGNITE_MOVES},
			:change_message => {"The grass caught fire!" => Fields::IGNITE_MOVES},
			:field_change_conditions => {PBFieldEffects::Wildfire => Fields.ignite?}
		}, 
		PBFieldEffects::JetStream => {
			:field_name => "Jet Stream",
			:intro_message => "A strong wind blows through.",
			:field_gfx => "Jet Stream",
			:nature_power => PBMoves::AIRSLASH,
			:mimicry => PBTypes::FLYING,
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:field_gfx => "Mountain",
			:nature_power => PBMoves::ROCKSLIDE,
			:mimicry => PBTypes::ROCK,
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {
			:ROCK => [Fields::SOUND_MOVES]
			}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ROCK]
			},
			:type_messages => {"Rocks from the mountain joined in." => PBTypes::ROCK},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {
			:ICE => [Fields::SOUND_MOVES,PBTypes::ROCK]
			}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::ICE]
			},
			:type_messages => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:abilities => [PBAbilities::WATERABSORB,PBAbilities::DRYSKIN,::PBAbilities::WATERCOMPACTION,PBAbilities::WATERVEIL],
			:ability_effects => {
			PBAbilities::WATERVEIL => [PBStats::EVASION,1]
			},
			:move_damage_boost => {
			1.2 => [PBTypes::WATER],
			0.8 => [PBTypes::FIRE]
			},
			:move_messages => {
			"The attack rode the current." => [PBTypes::WATER],
			"The water weakened the attack." => [PBTypes::FIRE]
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {},
			:type_messages => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:abilities => [PBAbilities::WATERABSORB,PBAbilities::DRYSKIN,::PBAbilities::WATERCOMPACTION,PBAbilities::WATERVEIL],
			:ability_effects => {
			PBAbilities::WATERVEIL => [PBStats::EVASION,1]
			},
			:move_damage_boost => {
			1.2 => [PBTypes::WATER,Fields::PULSE_MOVES,Fields::SOUND_MOVES],
			0.0 => [PBTypes::FIRE]
			},
			:move_messages => {
			"The depths boosted the attack." => [PBTypes::WATER,Fields::PULSE_MOVES,Fields::SOUND_MOVES],
			"The water put the fire out." => [PBTypes::FIRE]
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {},
			:type_messages => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:abilities => [],
			:ability_effects => {},
			:move_damage_boost => {
			1.2 => [PBTypes::PSYCHIC]
			},
			:move_messages => {
			"The psychic terrain boosted the attack." => [PBTypes::PSYCHIC]
			},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {},
			:type_messages => {},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:abilities => [PBAbilities::AROMAVEIL,PBAbilities::SWEETVEIL],
			:ability_effects => {
			PBAbilities::AROMAVEIL => [PBStats::DEFENSE,1],
			PBAbilities::SWEETVEIL => [PBStats::SPDEF,1]
			},
			:move_damage_boost => {},
			:move_messages => {},
			:move_type_mod => {}, #if a move adds a second type to the damage done
			:move_type_change => {},
			:move_accuracy_change => {},
			:defensive_modifiers => {},
			:type_damage_change => {
			1.2 => [PBTypes::FAIRY,Fields::LIGHT_MOVES],
			0.8 => [PBTypes::DRAGON]
			},
			:type_messages => {
			"The misty terrain boosted the attack." => [PBTypes::FAIRY],
			"The misty terrain weakened the attack." => [PBTypes::DRAGON]
			},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:field_gfx => nil,
			:nature_power => PBMoves::CHARGEBEAM,
			:mimicry => PBTypes::ELECTRIC,
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
			1.2 => [PBTypes::ELECTRIC,PBTypes::STEEL]
			},
			:type_messages => {
			"The attack drew power from the machines!" => [PBTypes::ELECTRIC],
			"The machinery joined the attack!" => [PBTypes::STEEL]
			},
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::ShortOut => Fields::OUTAGE_MOVES},
			:change_message => {"The field shorted out!" => Fields::OUTAGE_MOVES},
			:field_change_conditions => {}
		},
		PBFieldEffects::ShortOut => {
			:field_name => "Short Out",
			:intro_message => "The machines are silent.",
			:field_gfx => nil,
			:nature_power => PBMoves::DARKPULSE,
			:mimicry => PBTypes::DARK,
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::City => Fields::CHARGE_MOVES},
			:change_message => {"The electricity powered up the city!" => Fields::CHARGE_MOVES},
			:field_change_conditions => {}
		},
		PBFieldEffects::Outage => {
			:field_name => "Outage",
			:intro_message => "The city is dark.",
			:field_gfx => "City_Night",
			:nature_power => PBMoves::DARKPULSE,
			:mimicry => PBTypes::DARK,
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {},
			:side_effect_message => {},
			:status_move_boost => [],
			:field_changers => {PBFieldEffects::City => Fields::CHARGE_MOVES},
			:change_message => {"The electricity powered up the city!" => Fields::CHARGE_MOVES},
			:field_change_conditions => {}
		},
		PBFieldEffects::Space => {
			:field_name => "Space",
			:intro_message => "The stars glimmer dimly.",
			:field_gfx => "Space",
			:nature_power => PBMoves::DARKPULSE,
			:mimicry => PBTypes::DARK,
			:abilities => [PBAbilities::JUSTIFIED,PBAbilities::RATTLED],
			:ability_effects => {},
			:move_damage_boost => {
			1.2 => [Fields::LIGHT_MOVES]
			},
			:move_messages => {
			"The light is blinding!" => [Fields::LIGHT_MOVES]
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {},
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
			:abilities => [PBAbilities::STEELWORKER,PBAbilities::IRONFIST,PBAbilities::HEATPROOF,PBAbilities::FLASHFIRE,PBAbilities::FLAMEBODY,PBAbilities::MAGMAARMOR],
			:ability_effects => {
			PBAbilities::STEELWORKER => [PBStats::ATTACK,1],
			PBAbilities::IRONFIST => [PBStats::ATTACK,1],
			PBAbilities::HEATPROOF => [PBStats::SPDEF,1],
			PBAbilities::MAGMAARMOR => [PBStats::DEFENSE,1],
			PBAbilities::FLAMEBODY => [PBStats::DEFENSE,1],
			},
			:move_damage_boost => {
			1.2 => [Fields::LIGHT_MOVES]
			},
			:move_messages => {
			"The light is blinding!" => [Fields::LIGHT_MOVES]
			},
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
			:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
			:type_change_message => {},
			:side_effects => {"disturb" => Fields::KICKING_MOVES},
			:side_effect_message => {},
			:status_move_boost => [PBMoves::MOONLIGHT],
			:field_changers => {PBFieldEffects::Lava => Fields::QUAKE_MOVES},
			:change_message => {"The foundry collapsed and molten metal spilled!" => Fields::QUAKE_MOVES},
			:field_change_conditions => {}
		}
	}
	
#Saving these methods in case stuff doesn't work
=begin
	#Old FE Methods
    if hasConst?(PBTypes,:WATER)
      if @battle.field.field_effects == PBFieldEffects::Lava && isConst?(ret,PBTypes,:ICE)
        @battle.field.field_effects = PBFieldEffects::None
        ret = getConst(PBTypes,:WATER)
        $orig_type_ice = true
        @powerBoost = false
      end
    end
    if hasConst?(PBTypes,:POISON)
      if @battle.field.field_effects == PBFieldEffects::ToxicFumes && isConst?(ret,PBTypes,:WATER)
        ret = getConst(PBTypes,:POISON)
        $orig_water = true
        @powerBoost = false
      end
    end
    if hasConst?(PBTypes,:FIRE)
      if @battle.field.field_effects == PBFieldEffects::Wildfire && isConst?(ret,PBTypes,:GRASS)
        ret = getConst(PBTypes,:FIRE)
        $orig_flying = false
        $orig_grass = true
        @powerBoost = false
      end
      if @battle.field.field_effects == PBFieldEffects::Wildfire && isConst?(ret,PBTypes,:FLYING) && specialMove?
        ret = getConst(PBTypes,:FIRE)
        $orig_grass = false
        $orig_flying = true
        @powerBoost = false
      end
	  				
 case @battle.field.field_effects
 when PBFieldEffects::Desert
   priority = @battle.pbPriority(true)
   if Fields::WIND_MOVES.include?(self.id)
     if user.effectiveWeather != PBWeather::Sandstorm
       @battle.field.weather = PBWeather::Sandstorm
       @battle.field.weatherDuration = user.hasActiveItem?(:SMOOTHROCK) ? 8 : 5
       @battle.pbDisplay(_INTL("The winds kicked up a Sandstorm!")) if $test_trigger == false
     end
   end
 when PBFieldEffects::ToxicFumes
   priority = @battle.pbPriority(true)
 when PBFieldEffects::Wildfire
   priority = @battle.pbPriority(true)
   case type
   when getConst(PBTypes,:FIRE)
     if Fields::WIND_MOVES.include?(self.id)
       @battle.pbDisplay(_INTL("The winds kicked up cinders!")) if $test_trigger == false
       if target.effects[PBEffects::Cinders] == 0 && target.affectedByCinders?
         target.effects[PBEffects::Cinders] = 3
       end
     end
   when getConst(PBTypes,:WATER)
   end
 when PBFieldEffects::Swamp
   priority = @battle.pbPriority(true)
   case type
   when getConst(PBTypes,:ROCK)
   when getConst(PBTypes,:FIRE),getConst(PBTypes,:FIGHTING)
   when getConst(PBTypes,:POISON),getConst(PBTypes,:WATER),getConst(PBTypes,:GRASS)
   end
 when PBFieldEffects::City
   priority = @battle.pbPriority(true)
   case type
   when getConst(PBTypes,:NORMAL),getConst(PBTypes,:POISON)
   when getConst(PBTypes,:FIRE)
   when getConst(PBTypes,:GROUND)
   when getConst(PBTypes,:ELECTRIC)
       user.eachOpposing do |pkmn|
         pkmn.pbLowerStatStage(PBStats::ACCURACY,1,user) if !pkmn.pbHasType?(:ELECTRIC)
       end
     end
	if soundMove?
     priority.each do |pkmn|
       next if pkmn.hasActiveAbility?(:SOUNDPROOF)
       confuse = rand(100)
       if confuse > 85
         @battle.pbDisplay(_INTL("The noise of the city was too much for {1}!",pkmn.name))
         pkmn.pbConfuse if pkmn.pbCanConfuse?
       end
     end
   end
  when PBFieldEffects::Outage
	case type
	when getConst(PBTypes,:DARK),getConst(PBTypes,:GHOST)
	end
 when PBFieldEffects::Ruins
   priority = @battle.pbPriority(true)
   case type
   when getConst(PBTypes,:FIRE), getConst(PBTypes,:WATER), getConst(PBTypes,:GRASS)
   when getConst(PBTypes,:DRAGON)
   when getConst(PBTypes,:GHOST)
   end
   if target.pbHasType?(:GHOST) && target.hp == target.totalhp
     multipliers[FINAL_DMG_MULT] /= 2
   end
 when PBFieldEffects::Grassy
   priority = @battle.pbPriority(true)
   if target.pbHasType?(:BUG)
     multipliers[DEF_MULT] *= 1.2
   end
   if Fields::WIND_MOVES.include?(self.id)
     if @battle.pbWeather != PBWeather::Rain && @battle.pbWeather != PBWeather::HeavyRain && @battle.pbWeather != PBWeather::AcidRain
       @battle.pbDisplay(_INTL("The attack kicked up spores!")) if $test_trigger == false
       spore = rand(10)
       spore2 = rand(10)
       if user.status == PBStatuses::NONE && user.affectedByPowder?
         case spore
         when 0
           user.status = PBStatuses::PARALYSIS if user.pbCanParalyze?(user,true)
           @battle.pbDisplay(_INTL("{1} was paralyzed!",user.pbThis)) if user.pbCanParalyze?(user,true)
           @battle.pbDisplay(_INTL("The spores did not affect {1}!",user.pbThis)) if !user.pbCanParalyze?(user,true)
         when 3
           user.status = PBStatuses::POISON if user.pbCanPoison?(user,true)
           @battle.pbDisplay(_INTL("{1} was poisoned!",user.pbThis)) if user.pbCanPoison?(user,true)
           @battle.pbDisplay(_INTL("The spores did not affect {1}!",user.pbThis)) if !user.pbCanPoison?(user,true)
         when 6
           user.status = PBStatuses::SLEEP if user.pbCanSleep?(user,true)
           @battle.pbDisplay(_INTL("{1} fell asleep!",user.pbThis)) if user.pbCanSleep?(user,true)
           @battle.pbDisplay(_INTL("The spores did not affect {1}!",user.pbThis)) if !user.pbCanSleep?(user,true)
         when 1,2,4,5,7,8,9
           @battle.pbDisplay(_INTL("The spores had no effect on {1}!",user.pbThis)) if $test_trigger == false
         end
       else
         @battle.pbDisplay(_INTL("But {1} was already statused.",user.pbThis)) if $test_trigger == false
       end
       if target.status == PBStatuses::NONE && target.affectedByPowder?
         case spore2
         when 0
           target.status = PBStatuses::PARALYSIS if target.pbCanParalyze?(target,true)
           @battle.pbDisplay(_INTL("{1} was paralyzed!",target.pbThis)) if target.pbCanParalyze?(target,true)
           @battle.pbDisplay(_INTL("The spores did not affect {1}!",target.pbThis)) if !target.pbCanParalyze?(target,true)
         when 3
           target.status = PBStatuses::POISON if target.pbCanPoison?(target,true)
           @battle.pbDisplay(_INTL("{1} was poisoned!",target.pbThis)) if target.pbCanPoison?(target,true)
           @battle.pbDisplay(_INTL("The spores did not affect {1}!",target.pbThis)) if !target.pbCanPoison?(target,true)
         when 6
           target.status = PBStatuses::SLEEP if target.pbCanSleep?(target,true)
           @battle.pbDisplay(_INTL("{1} fell asleep!",target.pbThis)) if target.pbCanSleep?(target,true)
           @battle.pbDisplay(_INTL("The spores did not affect {1}!",target.pbThis)) if !target.pbCanSleep?(target,true)
         when 1,2,4,5,7,8,9
           @battle.pbDisplay(_INTL("The spores had no effect on {1}!",target.pbThis)) if $test_trigger == false
         end
       else
         @battle.pbDisplay(_INTL("But {1} was already statused.",target.pbThis)) if $test_trigger == false
       end
     end
   end
 when PBFieldEffects::JetStream
   priority = @battle.pbPriority(true)
   if target.affectedByJetStream?
     multipliers[DEF_MULT] *= 1.2 if physicalMove?
   end
   case type
   when getConst(PBTypes,:FIRE),getConst(PBTypes,:ELECTRIC),getConst(PBTypes,:ICE),getConst(PBTypes,:ROCK)
   end
 end
 if $effect_flag[:sand] == true && @battle.field.weather != PBWeather::Sandstorm
		    @battle.field.weather = PBWeather::Sandstorm
		    @battle.field.weatherDuration = user.hasActiveItem?(:SMOOTHROCK) ? 8 : 5
			@battle.pbDisplay(_INTL("The wind kicked up sand!")) if $test_trigger == false
		end
		if $effect_flag[:cinders] == true
			priority = @battle.pbPriority(true)
			priority.each do |target|
				target.effects[PBEffects::Cinders] = 3 if target.effects[PBEffects::Cinders] == 0 && target.affectedByCinders?
			end
			@battle.pbDisplay(_INTL("The wind kicked up cinders!")) if $test_trigger == false
		end
		if $effect_flag[:spore] == true
			priority = @battle.pbPriority(true)
			if @battle.pbWeather != PBWeather::Rain && @battle.pbWeather != PBWeather::HeavyRain && @battle.pbWeather != PBWeather::AcidRain
			   @battle.pbDisplay(_INTL("The attack kicked up spores!")) if $test_trigger == false
			   spore = rand(10)
			   spore2 = rand(10)
			   priority.each do |pkmn|
				   if pkmn.status == PBStatuses::NONE && pkmn.affectedByPowder?
					 case spore
					 when 0
					   pkmn.status = PBStatuses::PARALYSIS if pkmn.pbCanParalyze?(@battler,true)
					   @battle.pbDisplay(_INTL("{1} was paralyzed!",pkmn.pbThis)) if pkmn.pbCanParalyze?(pkmn,true)
					   @battle.pbDisplay(_INTL("The spores did not affect {1}!",pkmn.pbThis)) if !pkmn.pbCanParalyze?(pkmn,true)
					 when 3
					   pkmn.status = PBStatuses::POISON if pkmn.pbCanPoison?(pkmn,true)
					   @battle.pbDisplay(_INTL("{1} was poisoned!",pkmn.pbThis)) if pkmn.pbCanPoison?(pkmn,true)
					   @battle.pbDisplay(_INTL("The spores did not affect {1}!",pkmn.pbThis)) if !pkmn.pbCanPoison?(pkmn,true)
					 when 6
					   pkmn.status = PBStatuses::SLEEP if pkmn.pbCanSleep?(pkmn,true)
					   @battle.pbDisplay(_INTL("{1} fell asleep!",pkmn.pbThis)) if pkmn.pbCanSleep?(pkmn,true)
					   @battle.pbDisplay(_INTL("The spores did not affect {1}!",pkmn.pbThis)) if !pkmn.pbCanSleep?(pkmn,true)
					 when 1,2,4,5,7,8,9
					   @battle.pbDisplay(_INTL("The spores had no effect on {1}!",pkmn.pbThis)) if $test_trigger == false
					 end
				   else
					 @battle.pbDisplay(_INTL("But {1} was already statused.",pkmn.pbThis)) if $test_trigger == false
				   end
				end
			end
		 end
		 if $effect_flag[:outage] == true
			priority = @battle.pbPriority(true)
			priority.each do |pkmn|
			  pkmn.pbLowerStatStage(PBStats::ACCURACY,1,user) if !pkmn.pbHasType?(:ELECTRIC)
			end
		 end
		 if $effect_flag[:sound_confuse] == true
			priority = @battle.pbPriority(true)
			priority.each do |pkmn|
			   next if pkmn.hasActiveAbility?(:SOUNDPROOF)
			   confuse = rand(100)
			   if confuse > 85
				 @battle.pbDisplay(_INTL("The noise of the city was too much for {1}!",pkmn.name))
				 pkmn.pbConfuse if pkmn.pbCanConfuse?
			   end
			 end
		 end
	  end
=end