use dojo_starter::models::beast::Beast;

//
// Type Effectiveness, (how effective/resistant the beast is to each type)
//
#[derive(Copy, Drop, Serde, Debug, Default)]
pub struct TypeEffectiveness {
    pub fire: u8,
    pub water: u8,
    pub earth: u8,
    pub electric: u8,
    pub dragon: u8,
    pub ice: u8,
    pub magic: u8,
    pub rock: u8,
}

//
// Potential values (IV/EV equivalents)
//
#[derive(Copy, Drop, Serde, Debug, Default)]
pub struct Potential {
    pub hp: u8,
    pub attack: u8,
    pub defense: u8,
    pub special_attack: u8,
    pub special_defense: u8,
    pub speed: u8,
}

//
// BeastStats model
//
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct BeastStats {
    #[key]
    pub beast_id: u256,
    // Base stats
    pub base_hp: u16,
    pub attack: u16,
    pub defense: u16,
    pub special_attack: u16,
    pub special_defense: u16,
    pub speed: u16,
    pub accuracy: u8, //100%
    pub evasion: u8, //100%
    pub critical_hit_rate: u8, //100%
    pub type_effectiveness: TypeEffectiveness,
    pub growth_rate: u8,
    pub potential: Potential,
}
