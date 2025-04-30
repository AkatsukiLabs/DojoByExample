#[cfg(test)]
mod tests {
    use super::super::utils::experience_utils::{ExperienceCalculator, IExperienceCalculator, ExperienceCalculatorImpl};

    #[test]
    fn test_basic_experience() {
        // Test level 1 experience calculation
        assert(ExperienceCalculatorImpl::calculate_exp_needed_for_level(1_u8) == 10_u16, 'Level 1 exp incorrect');
        
        // Test if we should level up
        assert(ExperienceCalculatorImpl::should_level_up(1_u8, 40_u16), 'Should level up at 40 exp');
        
        // Test remaining experience
        assert(ExperienceCalculatorImpl::remaining_exp_after_level_up(1_u8, 50_u16) == 10_u16, 'Remaining exp incorrect');
    }
}
