/// A module for generating pseudo-random numbers using block data for entropy.
pub mod PseudoRandom {
    use super::*;
    use core::pedersen::PedersenTrait;
    use core::hash::HashStateTrait;
    use core::starknet::{get_block_timestamp, get_block_number};

    /// Generates a pseudo-random `u8` value within a specified range `[min, max]`.
    ///
    /// The randomness is derived from block timestamp and block number, using a Pedersen hash
    /// function to generate a pseudo-random value. This value is then reduced to an `u8` within
    /// the provided range.
    ///
    /// # Arguments
    ///
    /// * `min`: The minimum value (inclusive) of the random number range.
    /// * `max`: The maximum value (inclusive) of the random number range.
    ///
    /// # Panics
    ///
    /// This function will panic if `min >= max`.
    ///
    /// # Returns
    ///
    /// A pseudo-random `u8` value within the specified range.
    pub fn generate_random_u8(min: u8, max: u8) -> u8 {
        // Ensure min is less than max
        assert!(min < max, "min must be less than max");

        // Get Starknet block data for entropy
        let timestamp: felt252 = get_block_timestamp().into();
        let block_number: felt252 = get_block_number().into();

        // Create a Pedersen hash
        let mut state = PedersenTrait::new(timestamp);
        state = state.update(block_number);
        let hash: felt252 = state.finalize();

        // Convert the hash to u256
        let random_u256: u256 = hash.into();

        // Calculate the range
        let range: u256 = (max.into() - min.into() + 1_u8.into());
        let random_in_range: u256 = random_u256 % range;
        let random_u8: u8 = (random_in_range + min.into()).try_into().unwrap();

        // Ensure the random value is within the specified range
        assert!(random_u8 >= min && random_u8 <= max, "Random value out of range");

        random_u8
    }
}

#[cfg(test)]
mod tests {
    use super::PseudoRandom::generate_random_u8;

    /// Tests the `generate_random_u8` function to ensure it returns a value within the specified range.
    ///
    /// This test ensures that the random value generated is always between `min` and `max`, inclusive.
    #[test]
    #[available_gas(1000000)]
    fn test_generate_random_u8() {
        let min: u8 = 5;
        let max: u8 = 10;
        let result = generate_random_u8(min, max);

        // Assert the result is within the specified range
        assert!(result >= min && result <= max, "Random number out of range");
    }

    /// Tests the `generate_random_u8` function for a broader range of values.
    ///
    /// This test ensures that the function behaves correctly when the range is larger (10 to 100).
    #[test]
    #[available_gas(1000000)]
    fn test_random_in_range() {
        let min: u8 = 10;
        let max: u8 = 100;
        let result = generate_random_u8(min, max);

        // Assert the result is within the specified range
        assert!(result >= min && result <= max, "Random u8 out of range");
    }

    /// Tests the `generate_random_u8` function to ensure it produces deterministic outputs within a block.
    ///
    /// This test verifies that the random number generated is consistent when called multiple times
    /// within the same block (i.e., using the same timestamp and block number).
    #[test]
    #[available_gas(1000000)]
    fn test_deterministic_output_same_block() {
        let min: u8 = 20;
        let max: u8 = 50;
        let result1 = generate_random_u8(min, max);
        let result2 = generate_random_u8(min, max);

        // Assert that the random numbers are the same within the same block
        assert!(result1 == result2, "Expected same result");
    }

    /// Tests the `generate_random_u8` function with an invalid range where `min` is equal to `max`.
    ///
    /// This test ensures the function panics when `min` is not less than `max`.
    #[test]
    #[available_gas(1000000)]
    #[should_panic(expected: "min must be less than max")]
    fn test_invalid_range_equal_min_max() {
        let _ = generate_random_u8(50, 50); // should panic
    }

    /// Tests the `generate_random_u8` function with the full `u8` range.
    ///
    /// This test ensures the function works across the entire range of `u8` values, from 0 to 255.
    #[test]
    #[available_gas(1000000)]
    fn test_full_u8_range() {
        let min: u8 = 0;
        let max: u8 = 255;
        let result = generate_random_u8(min, max);

        // Assert the result is within the full `u8` range
        assert!(result >= min && result <= max, "Value should be in [0, 255]");
    }
}