=begin
FIELD_EFFECTS = {
	PBFieldEffects::None => {
		:field_name => "None",
		:intro_message => nil,
		:field_gfx => nil,
		:nature_power => PBMoves::TRIATTACK,
		:mimicry => :NORMAL,
		:move_damage_boost => {},
		:move_messages => {},
		:move_type_mod => {},
		:move_type_change => {},
		:move_accuracy_change => {},
		:type_damage_change => {},
		:type_messsages => {},
		:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:field_changers => {},
		:field_change_conditions => {}
	}
    PBFieldEffects::EchoChamber => {
		:field_name => "Echo Chamber",
		:intro_message => "A dull echo hums",
		:field_gfx => "Cave",
		:nature_power => PBMoves::HYPERVOICE,
		:mimicry => :NORMAL,
		:move_damage_boost => {},
		:move_messages => {},
		:move_type_mod => {},
		:move_type_change => {},
		:move_accuracy_change => {},
		:type_damage_change => {},
		:type_messsages => {},
		:type_type_mod => {}, #if a type changes due to the field, i.e. Ice => Water in Lava Field
		:field_changers => {},
		:field_change_conditions => {}
	}
    Desert 
    Lava
    ToxicFumes
    Wildfire
    Swamp 
    City 
    Ruins 
    Grassy 
    JetStream 
    Mountain
    SnowMountain
    Water 
    Underwater 
    Psychic 
    Misty
    Electric
    Digital
    Space 
    Monsoon
    Graveyard
    Foundry
    Forest
}
=end