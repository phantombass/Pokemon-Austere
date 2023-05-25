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
        :type_damage_change => {},
        :type_messages => {},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :type_damage_change => {},
        :type_messages => {},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
		:status_move_boost => [],
        :field_changers => {PBFieldEffects::Wildfire => Fields::IGNITE_MOVES},
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
		:abilities => [PBAbilities::FLASHFIRE],
		:ability_effects => {},
        :move_damage_boost => {},
        :move_messages => {},
        :move_type_mod => {}, #if a move adds a second type to the damage done
        :move_type_change => {},
        :move_accuracy_change => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::POISON]
		},
        :type_messages => {
		"The fumes strengthened the attack!" => [PBTypes::POISON]
		},
        :type_type_mod => {PBTypes::POISON => PBTypes::WATER}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {"The fumes corroded and strengthened the attack!" => [PBTypes::WATER]},
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
		:abilities => [PBAbilities::FLASHFIRE],
		:ability_effects => {},
        :move_damage_boost => {},
        :move_messages => {"The wind fueled the fire!" => Fields::WIND_MOVES},
        :move_type_mod => {:FIRE => [Fields::WIND_MOVES]}, #if a move adds a second type to the damage done
        :move_type_change => {},
        :move_accuracy_change => {},
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
        :type_damage_change => {
		1.5 => [PBTypes::ELECTRIC]
		},
        :type_messages => {"The attack drew power from the city." => [PBTypes::ELECTRIC]},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
		:status_move_boost => [],
        :field_changers => {
		PBFieldEffects::None => Fields::QUAKE_MOVES,
		PBFieldEffects::Wildfire => Fields::IGNITE_MOVES,
		PBFieldEffects::Outage => :ELECTRIC
		},
		:change_message => {
		"The city came crashing down!" => Fields::QUAKE_MOVES,
		"The city caught fire!" => Fields::IGNITE_MOVES,
		"Power outage!" => PBTypes::ELECTRIC
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
        :type_damage_change => {
		1.2 => [PBTypes::DRAGON,PBTypes::GHOST,PBTypes::GRASS,PBTypes::FIRE,PBTypes::WATER]
		},
        :type_messages => {"The ruins boosted the attack!" => [PBTypes::DRAGON,PBTypes::GHOST,PBTypes::GRASS,PBTypes::FIRE,PBTypes::WATER]},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :move_damage_boost => {},
        :move_messages => {},
        :move_type_mod => {}, #if a move adds a second type to the damage done
        :move_type_change => {},
        :move_accuracy_change => {},
        :type_damage_change => {
		1.2 => [PBTypes::GRASS,PBTypes::FAIRY,PBTypes::BUG]
		},
        :type_messages => {"The grass strengthened the attack!" => [PBTypes::GRASS,PBTypes::FAIRY,PBTypes::BUG]},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
		:status_move_boost => [PBMoves::GROWTH],
        :field_changers => {PBFieldEffects::None => Fields::IGNITE_MOVES},
		:change_message => {"The grass caught fire!" => Fields::IGNITE_MOVES},
        :field_change_conditions => {PBFieldEffects::Wildfire => Fields.ignite?}
    }, 
    PBFieldEffects::JetStream => {
        :field_name => "Jet Stream",
        :intro_message => "A strong wind blows through.",
        :field_gfx => "Jet Stream",
        :nature_power => PBMoves::HURRICANE,
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
        :type_damage_change => {
		0.8 => [PBTypes::ELECTRIC,PBTypes::FIRE,PBTypes::ROCK,PBTypes::ICE]
		},
        :type_messages => {"The jet stream weakened the attack." => [PBTypes::ELECTRIC,PBTypes::FIRE,PBTypes::ROCK,PBTypes::ICE]},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::ROCK]
		},
        :type_messages => {"Rocks from the mountain joined in." => PBTypes::ROCK},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::ICE]
		},
        :type_messages => {},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
		"The water's surface boosted the attack." => [PBTypes::WATER],
		"The water weakened the attack." => [PBTypes::FIRE]
		},
        :move_type_mod => {}, #if a move adds a second type to the damage done
        :move_type_change => {},
        :move_accuracy_change => {},
        :type_damage_change => {},
        :type_messages => {},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
		"The water boosted the attack." => [PBTypes::WATER,Fields::PULSE_MOVES,Fields::SOUND_MOVES],
		"The water put the fire out." => [PBTypes::FIRE]
		},
        :move_type_mod => {}, #if a move adds a second type to the damage done
        :move_type_change => {},
        :move_accuracy_change => {},
        :type_damage_change => {},
        :type_messages => {},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :type_damage_change => {},
        :type_messages => {},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::ELECTRIC]
		},
        :type_messages => {
		"The electric terrain boosted the attack." => [PBTypes::ELECTRIC]
		},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::ELECTRIC]
		},
        :type_messages => {
		"Register power boost..." => [PBTypes::ELECTRIC]
		},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
		:status_move_boost => [],
        :field_changers => {},
		:change_message => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::DARK,PBTypes::GHOST]
		},
        :type_messages => {
		"The city's darkness powered the attack!" => [PBTypes::DARK],
		"The shadows powered the attack!" => [PBTypes::GHOST]
		},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
		:status_move_boost => [],
        :field_changers => {},
		:change_message => {},
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
        :type_damage_change => {
		1.2 => [PBTypes::DARK,PBTypes::GHOST]
		},
        :type_messages => {
		"The city's darkness powered the attack!" => [PBTypes::DARK],
		"The shadows powered the attack!" => [PBTypes::GHOST]
		},
        :type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:type_change_message => {},
		:status_move_boost => [PBMoves::MOONLIGHT],
        :field_changers => {},
		:change_message => {},
        :field_change_conditions => {}
    }, 
   # Monsoon
   # Graveyard
   # Foundry
   # Forest
#	Outage
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
=end