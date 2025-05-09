use core::traits::Into;

#[generate_trait]
pub impl ExperienceCalculator of ExperienceCalculatorTrait {
    
    fn calculate_exp_needed_for_level(level: u8) -> u16 {
        let level_u16: u16 = level.into();
        level_u16 * level_u16 * 10
    }
    
    fn should_level_up(current_level: u8, current_exp: u16) -> bool {
        let exp_needed = Self::calculate_exp_needed_for_level(current_level);
        current_exp >= exp_needed
    }
    
    fn remaining_exp_after_level_up(current_level: u8, current_exp: u16) -> u16 {
        let exp_needed = Self::calculate_exp_needed_for_level(current_level);
        if current_exp >= exp_needed {
            current_exp - exp_needed
        } else {
            current_exp
        }
    }
}

#[cfg(test)]
mod experience_calculator_tests {
    use super::{ExperienceCalculator};

    #[test]
    #[available_gas(1000000)]
    fn test_calculate_exp_needed_for_level() {
        // Test values for different levels to verify the formula level² × 10
        
        // Level 1: 1² × 10 = 10
        let exp_level_1 = ExperienceCalculator::calculate_exp_needed_for_level(1);
        assert(exp_level_1 == 10, 'Level 1 should need 10 exp');
        
        // Level 2: 2² × 10 = 40
        let exp_level_2 = ExperienceCalculator::calculate_exp_needed_for_level(2);
        assert(exp_level_2 == 40, 'Level 2 should need 40 exp');
        
        // Level 5: 5² × 10 = 250
        let exp_level_5 = ExperienceCalculator::calculate_exp_needed_for_level(5);
        assert(exp_level_5 == 250, 'Level 5 should need 250 exp');
        
        // Level 10: 10² × 10 = 1000
        let exp_level_10 = ExperienceCalculator::calculate_exp_needed_for_level(10);
        assert(exp_level_10 == 1000, 'Level 10 should need 1000 exp');
        
        // Level 20: 20² × 10 = 4000
        let exp_level_20 = ExperienceCalculator::calculate_exp_needed_for_level(20);
        assert(exp_level_20 == 4000, 'Level 20 should need 4000 exp');
    }
    
    #[test]
    #[available_gas(1000000)]
    fn test_should_level_up() {
        // Level 1 (needs 10 exp)
        
        // 9 exp: should not level up
        let should_level_up_1_9 = ExperienceCalculator::should_level_up(1, 9);
        assert(!should_level_up_1_9, 'Level 1 with 9 exp not level up');
        
        // 10 exp: should level up
        let should_level_up_1_10 = ExperienceCalculator::should_level_up(1, 10);
        assert(should_level_up_1_10, 'Level 1 with 10 exp level up');
        
        // 15 exp: should level up
        let should_level_up_1_15 = ExperienceCalculator::should_level_up(1, 15);
        assert(should_level_up_1_15, 'Level 1 with 15 exp level up');
        
        // Level 5 (needs 250 exp)
        
        // 249 exp: should not level up
        let should_level_up_5_249 = ExperienceCalculator::should_level_up(5, 249);
        assert(!should_level_up_5_249, 'Level 5 249 exp not level up');
        
        // 250 exp: should level up
        let should_level_up_5_250 = ExperienceCalculator::should_level_up(5, 250);
        assert(should_level_up_5_250, 'Level 5 with 250 exp level up');
        
        // 300 exp: should level up
        let should_level_up_5_300 = ExperienceCalculator::should_level_up(5, 300);
        assert(should_level_up_5_300, 'Level 5 with 300 exp level up');
    }
    
    #[test]
    #[available_gas(1000000)]
    fn test_remaining_exp_after_level_up() {
        // Level 1 (needs 10 exp)
        
        // 9 exp: should remain at 9 (no level up)
        let remaining_1_9 = ExperienceCalculator::remaining_exp_after_level_up(1, 9);
        assert(remaining_1_9 == 9, 'Level 1 with 9 exp keep 9');
        
        // 10 exp: should remain at 0 (level up)
        let remaining_1_10 = ExperienceCalculator::remaining_exp_after_level_up(1, 10);
        assert(remaining_1_10 == 0, 'Level 1 with 10 exp 0 remaining');
        
        // 15 exp: should remain at 5 (level up)
        let remaining_1_15 = ExperienceCalculator::remaining_exp_after_level_up(1, 15);
        assert(remaining_1_15 == 5, 'Level 1 with 15 exp 5 remaining');
        
        // Level 5 (needs 250 exp)
    
        // 300 exp: should remain at 50 (level up)
        let remaining_5_300 = ExperienceCalculator::remaining_exp_after_level_up(5, 300);
        assert(remaining_5_300 == 50, 'Level 5 300 exp 50 remaining');
    }
    
    #[test]
    #[available_gas(1000000)]
    fn test_multiple_level_ups_simulation() {
        // Simulate a scenario where a beast levels up multiple times
        
        // Beast level 1 with 0 initial exp
        let mut current_level = 1_u8;
        let mut current_exp = 0_u16;
        
        // Earned 20 exp
        current_exp += 20;
        
        // Validate if it should level up
        let should_level = ExperienceCalculator::should_level_up(current_level, current_exp);
        assert(should_level, 'Level up after more 20 exp');
        
        // Level up and update remaining exp
        if should_level {
            current_exp = ExperienceCalculator::remaining_exp_after_level_up(current_level, current_exp);
            current_level += 1;
        }
        
        // Verify final values
        assert(current_level == 2, 'Should now be level 2');
        assert(current_exp == 10, 'Should have 10 exp remaining');
        
        // Earned 50 more exp
        current_exp += 50;
        
        // Validate if it should level up again
        let should_level_again = ExperienceCalculator::should_level_up(current_level, current_exp);
        assert(should_level_again, 'Level up 60 exp at level 2');
        
        // Level up again
        if should_level_again {
            current_exp = ExperienceCalculator::remaining_exp_after_level_up(current_level, current_exp);
            current_level += 1;
        }
        
        // Verify final values
        assert(current_level == 3, 'Should now be level 3');
        assert(current_exp == 20, 'Should have 20 exp remaining');
        
        // Should not level up to level 4 yet
        let not_enough_for_level4 = ExperienceCalculator::should_level_up(current_level, current_exp);
        assert(!not_enough_for_level4, 'Should not reach level 4 yet');
    }
}