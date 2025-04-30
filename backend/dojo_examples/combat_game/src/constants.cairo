
// Starknet import
use starknet::ContractAddress;
use core::traits::Into;

// Status values to init a Beast
pub const MIN_SEARCH: u8 = 1;
pub const MAX_SEARCH: u8 = 3;

// Zero address
pub fn ZERO_ADDRESS() -> ContractAddress {
    0.into()
}

// Seconds per day
pub const SECONDS_PER_DAY: u64 = 86400;


