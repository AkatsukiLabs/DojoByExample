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

