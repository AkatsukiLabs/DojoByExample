#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum TimePeriod {
    Undefined,
    AllTime,
    CurrentSeason,
    Weekly,
    Monthly,
    Yearly,
    Custom,
}

impl IntoTimePeriodFelt252 of Into<TimePeriod, felt252> {
    fn into(self: TimePeriod) -> felt252 {
        match self {
            TimePeriod::Undefined => 0,
            TimePeriod::AllTime => 1,
            TimePeriod::CurrentSeason => 2,
            TimePeriod::Weekly => 3,
            TimePeriod::Monthly => 4,
            TimePeriod::Yearly => 5,
            TimePeriod::Custom => 6,
        }
    }
}

impl IntoTimePeriodU8 of Into<TimePeriod, u8> {
    fn into(self: TimePeriod) -> u8 {
        match self {
            TimePeriod::Undefined => 0,
            TimePeriod::AllTime => 1,
            TimePeriod::CurrentSeason => 2,
            TimePeriod::Weekly => 3,
            TimePeriod::Monthly => 4,
            TimePeriod::Yearly => 5,
            TimePeriod::Custom => 6,
        }
    }
}

impl IntoU8TimePeriod of Into<u8, TimePeriod> {
    fn into(self: u8) -> TimePeriod {
        match self {
            0 => TimePeriod::Undefined,
            1 => TimePeriod::AllTime,
            2 => TimePeriod::CurrentSeason,
            3 => TimePeriod::Weekly,
            4 => TimePeriod::Monthly,
            5 => TimePeriod::Yearly,
            6 => TimePeriod::Custom,
            _ => TimePeriod::Undefined,
        }
    }
}
