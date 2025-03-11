//
// Status Condition enum
//
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
            StatusCondition::None => 0_u8,
            StatusCondition::Poisoned => 1_u8,
            StatusCondition::Paralyzed => 2_u8,
            StatusCondition::Asleep => 3_u8,
            StatusCondition::Confused => 4_u8,
            StatusCondition::Burned => 5_u8,
            StatusCondition::Frozen => 6_u8,
            StatusCondition::Cursed => 7_u8,
        }
    }
}

impl IntoU8StatusCondition of Into<u8, StatusCondition> {
    fn into(self: u8) -> StatusCondition {
        match self {
            0_u8 => StatusCondition::None,
            1_u8 => StatusCondition::Poisoned,
            2_u8 => StatusCondition::Paralyzed,
            3_u8 => StatusCondition::Asleep,
            4_u8 => StatusCondition::Confused,
            5_u8 => StatusCondition::Burned,
            6_u8 => StatusCondition::Frozen,
            7_u8 => StatusCondition::Cursed,
            _ => StatusCondition::None // Default to None for invalid values
        }
    }
}

