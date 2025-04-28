#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum StatusCondition {
    None,
    Poisoned,
    Paralyzed,
    Asleep,
    Confused,
    Burned,
    Frozen,
    Cursed,
}

impl IntoStatusConditionFelt252 of Into<StatusCondition, felt252> {
    fn into(self: StatusCondition) -> felt252 {
        match self {
            StatusCondition::None => 0,
            StatusCondition::Poisoned => 1,
            StatusCondition::Paralyzed => 2,
            StatusCondition::Asleep => 3,
            StatusCondition::Confused => 4,
            StatusCondition::Burned => 5,
            StatusCondition::Frozen => 6,
            StatusCondition::Cursed => 7,
        }
    }
}

impl IntoStatusConditionU8 of Into<StatusCondition, u8> {
    fn into(self: StatusCondition) -> u8 {
        match self {
            StatusCondition::None => 0,
            StatusCondition::Poisoned => 1,
            StatusCondition::Paralyzed => 2,
            StatusCondition::Asleep => 3,
            StatusCondition::Confused => 4,
            StatusCondition::Burned => 5,
            StatusCondition::Frozen => 6,
            StatusCondition::Cursed => 7,
        }
    }
}

impl IntoU8StatusCondition of Into<u8, StatusCondition> {
    fn into(self: u8) -> StatusCondition {
        match self {
            0 => StatusCondition::None,
            1 => StatusCondition::Poisoned,
            2 => StatusCondition::Paralyzed,
            3 => StatusCondition::Asleep,
            4 => StatusCondition::Confused,
            5 => StatusCondition::Burned,
            6 => StatusCondition::Frozen,
            7 => StatusCondition::Cursed,
            _ => StatusCondition::None // Default to None for invalid values
        }
    }
}

#[test]
#[available_gas(1000000)]
fn test_status_condition_to_u8() {
    let none = StatusCondition::None;
    let poisoned = StatusCondition::Poisoned;
    let paralyzed = StatusCondition::Paralyzed;
    let asleep = StatusCondition::Asleep;
    let confused = StatusCondition::Confused;
    let burned = StatusCondition::Burned;
    let frozen = StatusCondition::Frozen;
    let cursed = StatusCondition::Cursed;
    
    assert_eq!(none.into(), 0_u8, "StatusCondition::None should convert to 0");
    assert_eq!(poisoned.into(), 1_u8, "StatusCondition::Poisoned should convert to 1");
    assert_eq!(paralyzed.into(), 2_u8, "StatusCondition::Paralyzed should convert to 2");
    assert_eq!(asleep.into(), 3_u8, "StatusCondition::Asleep should convert to 3");
    assert_eq!(confused.into(), 4_u8, "StatusCondition::Confused should convert to 4");
    assert_eq!(burned.into(), 5_u8, "StatusCondition::Burned should convert to 5");
    assert_eq!(frozen.into(), 6_u8, "StatusCondition::Frozen should convert to 6");
    assert_eq!(cursed.into(), 7_u8, "StatusCondition::Cursed should convert to 7");
}

#[test]
fn test_status_condition_to_felt252() {
    let none = StatusCondition::None;
    let poisoned = StatusCondition::Poisoned;
    let paralyzed = StatusCondition::Paralyzed;
    let asleep = StatusCondition::Asleep;
    let confused = StatusCondition::Confused;
    let burned = StatusCondition::Burned;
    let frozen = StatusCondition::Frozen;
    let cursed = StatusCondition::Cursed;
    
    assert_eq!(none.into(), 0_felt252, "StatusCondition::None should convert to 0_felt252");
    assert_eq!(poisoned.into(), 1_felt252, "StatusCondition::Poisoned should convert to 1_felt252");
    assert_eq!(paralyzed.into(), 2_felt252, "StatusCondition::Paralyzed should convert to 2_felt252");
    assert_eq!(asleep.into(), 3_felt252, "StatusCondition::Asleep should convert to 3_felt252");
    assert_eq!(confused.into(), 4_felt252, "StatusCondition::Confused should convert to 4_felt252");
    assert_eq!(burned.into(), 5_felt252, "StatusCondition::Burned should convert to 5_felt252");
    assert_eq!(frozen.into(), 6_felt252, "StatusCondition::Frozen should convert to 6_felt252");
    assert_eq!(cursed.into(), 7_felt252, "StatusCondition::Cursed should convert to 7_felt252");
}

#[test]
fn test_u8_to_status_condition_valid() {
    let zero = 0_u8;
    let one = 1_u8;
    let two = 2_u8;
    let three = 3_u8;
    let four = 4_u8;
    let five = 5_u8;
    let six = 6_u8;
    let seven = 7_u8;
    
    assert_eq!(zero.into(), StatusCondition::None, "0 should convert to StatusCondition::None");
    assert_eq!(one.into(), StatusCondition::Poisoned, "1 should convert to StatusCondition::Poisoned");
    assert_eq!(two.into(), StatusCondition::Paralyzed, "2 should convert to StatusCondition::Paralyzed");
    assert_eq!(three.into(), StatusCondition::Asleep, "3 should convert to StatusCondition::Asleep");
    assert_eq!(four.into(), StatusCondition::Confused, "4 should convert to StatusCondition::Confused");
    assert_eq!(five.into(), StatusCondition::Burned, "5 should convert to StatusCondition::Burned");
    assert_eq!(six.into(), StatusCondition::Frozen, "6 should convert to StatusCondition::Frozen");
    assert_eq!(seven.into(), StatusCondition::Cursed, "7 should convert to StatusCondition::Cursed");
}

#[test]
fn test_u8_to_status_condition_invalid() {
    let eight = 8_u8;
    let hundred = 100_u8;
    let two_fifty_five = 255_u8;
    let two_hundred = 200_u8;
    
    assert_eq!(eight.into(), StatusCondition::None, "8 should default to StatusCondition::None");
    assert_eq!(hundred.into(), StatusCondition::None, "100 should default to StatusCondition::None");
    assert_eq!(two_fifty_five.into(), StatusCondition::None, "255 should default to StatusCondition::None");
    assert_eq!(two_hundred.into(), StatusCondition::None, "200 should default to StatusCondition::None");
}
