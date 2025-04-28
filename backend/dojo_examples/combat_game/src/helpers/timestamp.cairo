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

#[cfg(test)]
mod tests {
    use super::TimestampTrait;
    use combat_game::constants;
    use core::panic::catch_panic;

    #[test]
    fn test_unix_timestamp_to_day_valid() {
        // 2 days worth of seconds
        let timestamp: u64 = 2 * constants::SECONDS_PER_DAY;
        let day = TimestampTrait::unix_timestamp_to_day(timestamp);
        assert(day == 2, 'Should return 2 days');
    }

    #[test]
    fn test_unix_timestamp_to_day_overflow() {
        // This timestamp will result in days > u32::MAX
        let timestamp: u64 = (u32::MAX as u64 + 1) * constants::SECONDS_PER_DAY;
        let result = catch_panic(|| {
            TimestampTrait::unix_timestamp_to_day(timestamp);
        });
        assert(result.is_err(), 'Should panic on overflow');
    }
}


