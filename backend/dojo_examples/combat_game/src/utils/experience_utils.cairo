use traits::Into;

#[derive(Drop)]
struct ExperienceCalculator {}

trait IExperienceCalculator {
    fn calculate_exp_needed_for_level(level: u8) -> u16;
    fn should_level_up(current_level: u8, current_exp: u16) -> bool;
    fn remaining_exp_after_level_up(current_level: u8, current_exp: u16) -> u16;
}

impl ExperienceCalculatorImpl of IExperienceCalculator {
    // Calculates experience needed for a given level using formula: level² × 10
    fn calculate_exp_needed_for_level(level: u8) -> u16 {
        // Convert level to u16 for multiplication
        let level_u16: u16 = level.into();
        // Calculate level squared * 10
        level_u16 * level_u16 * 10_u16
    }

    // Determines if current experience is enough for a level up
    fn should_level_up(current_level: u8, current_exp: u16) -> bool {
        let needed_exp = ExperienceCalculatorImpl::calculate_exp_needed_for_level(current_level + 1_u8);
        current_exp >= needed_exp
    }

    // Calculates remaining experience after level up
    fn remaining_exp_after_level_up(current_level: u8, current_exp: u16) -> u16 {
        let needed_exp = ExperienceCalculatorImpl::calculate_exp_needed_for_level(current_level + 1_u8);
        if current_exp >= needed_exp {
            current_exp - needed_exp
        } else {
            current_exp
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{ExperienceCalculator, IExperienceCalculator, ExperienceCalculatorImpl};

    #[test]
    fn test_calculate_exp_needed_for_level() {
        // Test experience needed for different levels
        assert(ExperienceCalculatorImpl::calculate_exp_needed_for_level(1_u8) == 10_u16, 'Level 1 should need 10 exp');
        assert(ExperienceCalculatorImpl::calculate_exp_needed_for_level(2_u8) == 40_u16, 'Level 2 should need 40 exp');
        assert(ExperienceCalculatorImpl::calculate_exp_needed_for_level(5_u8) == 250_u16, 'Level 5 should need 250 exp');
        assert(ExperienceCalculatorImpl::calculate_exp_needed_for_level(10_u8) == 1000_u16, 'Level 10 should need 1000 exp');
        assert(ExperienceCalculatorImpl::calculate_exp_needed_for_level(20_u8) == 4000_u16, 'Level 20 should need 4000 exp');
    }

    #[test]
    fn test_should_level_up() {
        // Test various level up scenarios
        assert(ExperienceCalculatorImpl::should_level_up(1_u8, 40_u16) == true, 'Should level up from 1 to 2');
        assert(ExperienceCalculatorImpl::should_level_up(1_u8, 39_u16) == false, 'Should not level up with insufficient exp');
        assert(ExperienceCalculatorImpl::should_level_up(5_u8, 360_u16) == true, 'Should level up from 5 to 6');
        assert(ExperienceCalculatorImpl::should_level_up(5_u8, 359_u16) == false, 'Should not level up from 5 with insufficient exp');
    }

    #[test]
    fn test_remaining_exp_after_level_up() {
        // Test remaining experience calculations
        assert(ExperienceCalculatorImpl::remaining_exp_after_level_up(1_u8, 50_u16) == 10_u16, 'Should have 10 exp remaining');
        assert(ExperienceCalculatorImpl::remaining_exp_after_level_up(1_u8, 39_u16) == 39_u16, 'Should keep all exp if not leveling');
        assert(ExperienceCalculatorImpl::remaining_exp_after_level_up(5_u8, 400_u16) == 40_u16, 'Should have 40 exp remaining from level 5');
    }

    #[test]
    fn test_multiple_level_ups() {
        // Test scenario for multiple level ups
        let mut level = 1_u8;
        let mut exp = 1000_u16;

        // First level up (1 -> 2)
        assert(ExperienceCalculatorImpl::should_level_up(level, exp), 'Should level up from 1');
        exp = ExperienceCalculatorImpl::remaining_exp_after_level_up(level, exp);
        level += 1_u8;
        assert(exp == 960_u16, 'Should have 960 exp remaining');

        // Second level up (2 -> 3)
        assert(ExperienceCalculatorImpl::should_level_up(level, exp), 'Should level up from 2');
        exp = ExperienceCalculatorImpl::remaining_exp_after_level_up(level, exp);
        level += 1_u8;
        assert(exp == 870_u16, 'Should have 870 exp remaining');

        // Third level up (3 -> 4)
        assert(ExperienceCalculatorImpl::should_level_up(level, exp), 'Should level up from 3');
        exp = ExperienceCalculatorImpl::remaining_exp_after_level_up(level, exp);
        level += 1_u8;
        assert(exp == 710_u16, 'Should have 710 exp remaining');
    }
}
