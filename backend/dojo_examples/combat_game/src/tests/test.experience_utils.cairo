use core::debug::PrintTrait;
use core::traits::Into;
use core::test::test_utils::assert_eq;

use combat_game::helpers::experience_utils::{ExperienceCalculator, ExperienceCalculatorTrait, ExperienceCalculatorImpl};

#[test]
fn test_calculate_exp_needed_for_level() {
    // Test level 1
    let exp_needed = ExperienceCalculatorImpl::calculate_exp_needed_for_level(1);
    assert_eq(exp_needed, 10, 'Level 1 should need 10 exp');

    // Test level 2
    let exp_needed = ExperienceCalculatorImpl::calculate_exp_needed_for_level(2);
    assert_eq(exp_needed, 40, 'Level 2 should need 40 exp');

    // Test level 5
    let exp_needed = ExperienceCalculatorImpl::calculate_exp_needed_for_level(5);
    assert_eq(exp_needed, 250, 'Level 5 should need 250 exp');

    // Test level 10
    let exp_needed = ExperienceCalculatorImpl::calculate_exp_needed_for_level(10);
    assert_eq(exp_needed, 1000, 'Level 10 should need 1000 exp');

    // Test level 20
    let exp_needed = ExperienceCalculatorImpl::calculate_exp_needed_for_level(20);
    assert_eq(exp_needed, 4000, 'Level 20 should need 4000 exp');
}

#[test]
fn test_should_level_up() {
    // Test level 1 with enough exp
    let should_level = ExperienceCalculatorImpl::should_level_up(1, 10);
    assert_eq(should_level, true, 'Should level up with exact exp needed');

    // Test level 1 with not enough exp
    let should_level = ExperienceCalculatorImpl::should_level_up(1, 9);
    assert_eq(should_level, false, 'Should not level up with insufficient exp');

    // Test level 2 with more than enough exp
    let should_level = ExperienceCalculatorImpl::should_level_up(2, 50);
    assert_eq(should_level, true, 'Should level up with excess exp');

    // Test level 5 with exact exp needed
    let should_level = ExperienceCalculatorImpl::should_level_up(5, 250);
    assert_eq(should_level, true, 'Should level up with exact exp needed');
}

#[test]
fn test_remaining_exp_after_level_up() {
    // Test level 1 with exact exp needed
    let remaining = ExperienceCalculatorImpl::remaining_exp_after_level_up(1, 10);
    assert_eq(remaining, 0, 'Should have 0 exp remaining after level up');

    // Test level 1 with excess exp
    let remaining = ExperienceCalculatorImpl::remaining_exp_after_level_up(1, 15);
    assert_eq(remaining, 5, 'Should have 5 exp remaining after level up');

    // Test level 2 with not enough exp
    let remaining = ExperienceCalculatorImpl::remaining_exp_after_level_up(2, 30);
    assert_eq(remaining, 30, 'Should keep current exp if not enough for level up');

    // Test level 5 with excess exp
    let remaining = ExperienceCalculatorImpl::remaining_exp_after_level_up(5, 300);
    assert_eq(remaining, 50, 'Should have 50 exp remaining after level up');
}

#[test]
fn test_multiple_sequential_level_ups() {
    let mut current_level: u8 = 1;
    let mut current_exp: u16 = 100;

    // First level up
    let should_level = ExperienceCalculatorImpl::should_level_up(current_level, current_exp);
    assert_eq(should_level, true, 'Should level up first time');
    let remaining = ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level, current_exp);
    current_exp = remaining;
    current_level += 1;

    // Second level up
    let should_level = ExperienceCalculatorImpl::should_level_up(current_level, current_exp);
    assert_eq(should_level, true, 'Should level up second time');
    let remaining = ExperienceCalculatorImpl::remaining_exp_after_level_up(current_level, current_exp);
    current_exp = remaining;
    current_level += 1;

    // Check final state
    assert_eq(current_level, 3, 'Should be level 3 after two level ups');
    assert_eq(current_exp, 20, 'Should have 20 exp remaining after two level ups');
} 