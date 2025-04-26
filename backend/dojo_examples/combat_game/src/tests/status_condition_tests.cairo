use combat_game::types::status_condition::{
    StatusCondition,
}; // Import your enum from the correct path

#[cfg(test)]
mod status_condition_tests {
    use super::*; // Import everything from the parent module (combat_game)


    #[test]
    fn test_status_condition_to_u8() {
        assert_eq!(StatusCondition::None.into(), 0_u8);
        assert_eq!(StatusCondition::Poisoned.into(), 1_u8);
        assert_eq!(StatusCondition::Paralyzed.into(), 2_u8);
        assert_eq!(StatusCondition::Asleep.into(), 3_u8);
        assert_eq!(StatusCondition::Confused.into(), 4_u8);
        assert_eq!(StatusCondition::Burned.into(), 5_u8);
        assert_eq!(StatusCondition::Frozen.into(), 6_u8);
        assert_eq!(StatusCondition::Cursed.into(), 7_u8);
    }

    #[test]
    fn test_status_condition_to_felt252() {
        assert_eq!(StatusCondition::None.into(), 0_felt252);
        assert_eq!(StatusCondition::Poisoned.into(), 1_felt252);
        assert_eq!(StatusCondition::Paralyzed.into(), 2_felt252);
        assert_eq!(StatusCondition::Asleep.into(), 3_felt252);
        assert_eq!(StatusCondition::Confused.into(), 4_felt252);
        assert_eq!(StatusCondition::Burned.into(), 5_felt252);
        assert_eq!(StatusCondition::Frozen.into(), 6_felt252);
        assert_eq!(StatusCondition::Cursed.into(), 7_felt252);
    }

    #[test]
    fn test_u8_to_status_condition_valid() {
        assert_eq!(0_u8.into(), StatusCondition::None);
        assert_eq!(1_u8.into(), StatusCondition::Poisoned);
        assert_eq!(2_u8.into(), StatusCondition::Paralyzed);
        assert_eq!(3_u8.into(), StatusCondition::Asleep);
        assert_eq!(4_u8.into(), StatusCondition::Confused);
        assert_eq!(5_u8.into(), StatusCondition::Burned);
        assert_eq!(6_u8.into(), StatusCondition::Frozen);
        assert_eq!(7_u8.into(), StatusCondition::Cursed);
    }

    #[test]
    fn test_u8_to_status_condition_invalid() {
        assert_eq!(255_u8.into(), StatusCondition::None);
        assert_eq!(100_u8.into(), StatusCondition::None);
        assert_eq!(8_u8.into(), StatusCondition::None); // also a value out of range
        assert_eq!(200_u8.into(), StatusCondition::None);
    }
}
