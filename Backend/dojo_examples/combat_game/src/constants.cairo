
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


