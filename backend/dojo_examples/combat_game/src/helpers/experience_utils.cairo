pub trait ExperienceCalculator {
    fn calculate_exp_needed_for_level(level: u8) -> u16;

    fn should_level_up(current_level: u8, current_exp: u16) -> bool;
    
    fn remaining_exp_after_level_up(current_level: u8, current_exp: u16) -> u16;
}

pub impl ExperienceCalculatorImpl of ExperienceCalculator {
    fn calculate_exp_needed_for_level(level: u8) -> u16 {
        let x: u16 = level.into() * level.into() * 10_u16;
        x
    }

    fn should_level_up(current_level: u8, current_exp: u16) -> bool {
        current_exp >= (current_level.into() * current_level.into() * 10_u16)
    }

    fn remaining_exp_after_level_up(current_level: u8, current_exp: u16) -> u16 {
        if current_exp >= (current_level.into() * current_level.into() * 10_u16) {
            current_exp - (current_level.into() * current_level.into() * 10_u16)
        }

        else {
            current_exp
        }
    }
}

#[cfg(test)]
mod test {
    
    use super::ExperienceCalculatorImpl;

    #[test]
    fn test_calculate_exp_needed_for_level(){
        let level_1: u8 = 1;
        let level_2: u8 = 2;
        let level_5: u8 = 5;
        let level_10: u8 = 10;
        let level_20: u8 = 20;

        let exp_needed_for_level_1: u16 = 10;
        let exp_needed_for_level_2: u16 = 40;
        let exp_needed_for_level_5: u16 = 250;
        let exp_needed_for_level_10: u16 = 1000;
        let exp_needed_for_level_20: u16 = 4000;

        assert_eq!(ExperienceCalculatorImpl::calculate_exp_needed_for_level(level_1), exp_needed_for_level_1, "Experience needed for level 1 should be 10");
        assert_eq!(ExperienceCalculatorImpl::calculate_exp_needed_for_level(level_2), exp_needed_for_level_2, "Experience needed for level 2 should be 40");
        assert_eq!(ExperienceCalculatorImpl::calculate_exp_needed_for_level(level_5), exp_needed_for_level_5, "Experience needed for level 5 should be 250");
        assert_eq!(ExperienceCalculatorImpl::calculate_exp_needed_for_level(level_10), exp_needed_for_level_10, "Experience needed for level 10 should be 1000");
        assert_eq!(ExperienceCalculatorImpl::calculate_exp_needed_for_level(level_20), exp_needed_for_level_20, "Experience needed for level 10 should be 1000");
    }

    #[test]
    fn should_level_up_test(){
        let level_1: u8 = 1;
        let level_2: u8 = 2;
        let level_5: u8 = 5;
        let level_10: u8 = 10;
        let level_20: u8 = 20;


        ///For each level instance test  there is an instance of the exact exp needed to level up, currentexp greater the exp needed to level up, 
        ///currentexp is less than what is needed.

        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_1, current_exp: 10), true, "Should pass, exp needed to level up is 10");
        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_1, current_exp: 11), true, "Should pass, exp needed to level up is 10");
        assert_ne!(ExperienceCalculatorImpl::should_level_up(current_level: level_1, current_exp: 9), true, "Should pass, exp needed to level up is 10");

        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_2, current_exp: 41), true, "Should pass, exp needed to level up is 40");
        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_2, current_exp: 40), true, "Should pass, exp needed to level up is 40");
        assert_ne!(ExperienceCalculatorImpl::should_level_up(current_level: level_2, current_exp: 39), true, "Should pass, exp needed to level up is 40");

        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_5, current_exp: 250), true, "Should pass, exp needed to level up is 250");
        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_5, current_exp: 251), true, "Should pass, exp needed to level up is 250");
        assert_ne!(ExperienceCalculatorImpl::should_level_up(current_level: level_5, current_exp: 249), true, "Should pass, exp needed to level up is 250");

        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_10, current_exp: 1000), true, "Should pass, exp needed to level up is 100");
        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_10, current_exp: 1001), true, "Should pass, exp needed to level up is 100");
        assert_ne!(ExperienceCalculatorImpl::should_level_up(current_level: level_10, current_exp: 999), true, "Should pass, exp needed to level up is 100");

        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_20, current_exp: 4000), true, "Should pass, exp needed to level up is 4000");
        assert_eq!(ExperienceCalculatorImpl::should_level_up(current_level: level_20, current_exp: 4001), true, "Should pass, exp needed to level up is 4000");
        assert_ne!(ExperienceCalculatorImpl::should_level_up(current_level: level_20, current_exp: 3999), true, "Should pass, exp needed to level up is 4000");         
    }

    #[test]
    fn remaining_exp_after_level_up_test(){
        let level_1: u8 = 1;
        let level_2: u8 = 2;
        let level_5: u8 = 5;
        let level_10: u8 = 10;
        let level_20: u8 = 20;

    

        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_1, current_exp: 12), 2, "The remaining exp should be current_exp - exp_needed"); 
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_1, current_exp: 17), 7, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_1, current_exp:8), 8, "The remaining exp should be current_exp - exp_needed");
        
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_2, current_exp:44), 4, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_2, current_exp:160), 120, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_2, current_exp: 32), 32, "The remaining exp should be current_exp - exp_needed");

        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_5, current_exp: 260), 10, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_5, current_exp: 400), 150, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_5, current_exp: 200), 200, "The remaining exp should be current_exp - exp_needed");

        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_10, current_exp:  1020), 20, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_10, current_exp:  2000), 1000, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_10, current_exp:  950), 950, "The remaining exp should be current_exp - exp_needed");

        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_20, current_exp:  4100), 100, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_20, current_exp:  4700), 700, "The remaining exp should be current_exp - exp_needed");
        assert_eq!(ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level: level_20, current_exp:  3800), 3800, "The remaining exp should be current_exp - exp_needed");
        
    }
}
