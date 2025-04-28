/// A module for generating pseudo-random numbers using block data for entropy.
pub mod PseudoRandom {
    use super::*;
    use core::pedersen::PedersenTrait;
    use core::hash::HashStateTrait;
    use core::starknet::{get_block_timestamp, get_block_number};
    use core::num::traits::{WrappingAdd, WrappingMul};

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
    /// * `unique_id`: A unique identifier used to generate entropy for randomness.
    /// * `salt`: An additional value to modify the randomness, ensuring more variation.
    ///
    /// # Panics
    ///
    /// This function will panic if `min >= max`.
    ///
    /// # Returns
    ///
    /// A pseudo-random `u8` value within the specified range.
    pub fn generate_random_u8(
        unique_id: u16, 
        salt: u16,
        min: u8, 
        max: u8
    ) -> u8 {
        assert!(min < max, "min must be less than max");
        
        // Get entropy values
        let block_timestamp = get_block_timestamp();
        let block_number = get_block_number();
        
        // Create unique seeds with your parameters
        let timestamp_seed: felt252 = block_timestamp.into() + salt.into();
        let block_seed: felt252 = block_number.into() + unique_id.into();
        let combined_seed: felt252 = timestamp_seed + (unique_id.wrapping_mul(salt)).into();
        
        // Hash for randomness
        let hash_input = combined_seed + block_seed;
        let hash_state = PedersenTrait::new(0);
        let hash_state = hash_state.update(hash_input);
        let hash = hash_state.finalize();
        
        // Convert to range
        let range: u64 = max.into() - min.into() + 1_u64.into();
        let hash_u256: u256 = hash.into();
        let mod_value: u64 = (hash_u256 % range.into()).try_into().unwrap();
        let mod_value_u8: u8 = mod_value.try_into().unwrap();
        let random_value: u8 = mod_value_u8.wrapping_add(min);

        assert!(random_value >= min && random_value <= max, "Random value out of range");

        random_value
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
        let unique_id: u16 = 12345;
        let salt: u16 = 6789;
        let result = generate_random_u8(unique_id, salt, min, max);

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
        let unique_id: u16 = 12345;
        let salt: u16 = 6789;
        let result = generate_random_u8(unique_id, salt, min, max);

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
        let unique_id: u16 = 12345;
        let salt: u16 = 6789;
        let result1 = generate_random_u8(unique_id, salt, min, max);
        let result2 = generate_random_u8(unique_id, salt, min, max);

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
        let _ = generate_random_u8(12, 34, 50, 50); // should panic
    }

    /// Tests the `generate_random_u8` function with the full `u8` range.
    ///
    /// This test ensures the function works across the entire range of `u8` values, from 0 to 255.
    #[test]
    #[available_gas(1000000)]
    fn test_full_u8_range() {
        let min: u8 = 0;
        let max: u8 = 255;
        let unique_id: u16 = 12345;
        let salt: u16 = 6789;
        let result = generate_random_u8(unique_id, salt, min, max);

        // Assert the result is within the full `u8` range
        assert!(result >= min && result <= max, "Value should be in [0, 255]");
    }
}
