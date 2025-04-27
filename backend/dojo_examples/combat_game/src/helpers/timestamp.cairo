use combat_game::constants;
use core::panic::panic_with_felt252;

#[generate_trait]
pub impl Timestamp of TimestampTrait {
    fn unix_timestamp_to_day(timestamp: u64) -> u32 {
        // calculate convertion
        let days: u64 = timestamp / constants::SECONDS_PER_DAY;

        match days.try_into() {
            Result::Ok(day_u32) => day_u32,
            // handle error of overflow in size
            Result::Err(_) => {
                panic_with_felt252('Timestamp conversion overflow');
            }
        }
    }
}