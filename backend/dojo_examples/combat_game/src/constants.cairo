// Starknet import
use starknet::{ContractAddress, contract_address_const};

// Status values to init a Beast
pub const MIN_SEARCH: u8 = 1;
pub const MAX_SEARCH: u8 = 3;

// Zero address
pub fn ZERO_ADDRESS() -> ContractAddress {
    contract_address_const::<0x0>()
}

// Seconds per day
pub const SECONDS_PER_DAY: u64 = 86400;

// base level bonus
pub const BASE_LEVEL_BONUS: u8 = 10;

// Attack effectiveness
pub const SUPER_EFFECTIVE: u8 = 150;
pub const NORMAL_EFFECTIVENESS: u8 = 100;
pub const NOT_VERY_EFFECTIVE: u8 = 50;

// Attack multiplier
pub const FAVORED_ATTACK_MULTIPLIER: u8 = 120;
pub const NORMAL_ATTACK_MULTIPLIER: u8 = 100;

// Base battle experience
pub const BASE_BATTLE_EXPERIENCE: u16 = 10;
