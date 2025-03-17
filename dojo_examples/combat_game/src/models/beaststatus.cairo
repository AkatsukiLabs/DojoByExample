use dojo_starter::models::beast::Beast;

//
// Stat Modifier struct to track temporary stat changes during battle
//
#[derive(Copy, Drop, Serde, Debug, Default)]
pub struct StatModifiers {
    pub attack: i8, // Negative values decrease, positive increase
    pub defense: i8,
    pub special_attack: i8,
    pub special_defense: i8,
    pub speed: i8,
    pub accuracy: i8,
    pub evasion: i8,
}

//
// Persistent Effect with duration tracking
//
#[derive(Copy, Drop, Serde, Debug)]
pub struct PersistentEffect {
    pub effect_type: u8, // uint8 for different effect types
    pub duration: u8, // Number of turns remaining
    pub intensity: u8 // Strength of the effect
}

//
// BeastStatus model
//
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct BeastStatus {
    #[key]
    pub beast_id: u256, // Reference to Beast model as primary key
    // Health points
    pub current_hp: u16,
    pub maximum_hp: u16,
    // Status
    pub status_condition: StatusCondition,
    pub stat_modifiers: StatModifiers,
    // Battle resources
    pub move_pp: u8,
    pub fatigue_level: u8, // 0-100 scale, 0 is fresh, 100 is completely fatigued
    pub recovery_rate: u8, // How quickly the beast recovers between battles
    // Effects and timing
    pub persistent_effects: Array<PersistentEffect>, // Array of active effects with durations
    pub last_battle_timestamp: u64, // Unix timestamp of last battle
    // Additional tracking
    pub consecutive_battles: u8, // Count of battles without rest
    pub is_fainted: bool // Whether the beast is knocked out
}
