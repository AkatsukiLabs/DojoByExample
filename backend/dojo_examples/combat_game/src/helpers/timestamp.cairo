// Core imports

// Constants imports
use combat_game::constants;
use core::traits::TryInto;

#[generate_trait]
pub impl Timestamp of TimestampTrait {
    fn unix_timestamp_to_day(timestamp: u64) -> u32 {
        (timestamp / constants::SECONDS_PER_DAY).try_into().unwrap()
    }
}
