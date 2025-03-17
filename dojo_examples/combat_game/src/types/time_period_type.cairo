//
// Time Period enum
//
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum TimePeriod {
    AllTime,
    CurrentSeason,
    Weekly,
    Monthly,
    Yearly,
    Custom,
    Undefined,
}

impl IntoTimePeriodFelt252 of Into<TimePeriod, felt252> {
    fn into(self: TimePeriod) -> felt252 {
        match self {
            TimePeriod::AllTime => 1,
            TimePeriod::CurrentSeason => 2,
            TimePeriod::Weekly => 3,
            TimePeriod::Monthly => 4,
            TimePeriod::Yearly => 5,
            TimePeriod::Custom => 6,
            TimePeriod::Undefined => 0,
        }
    }
}

impl IntoTimePeriodU8 of Into<TimePeriod, u8> {
    fn into(self: TimePeriod) -> u8 {
        match self {
            TimePeriod::AllTime => 1_u8,
            TimePeriod::CurrentSeason => 2_u8,
            TimePeriod::Weekly => 3_u8,
            TimePeriod::Monthly => 4_u8,
            TimePeriod::Yearly => 5_u8,
            TimePeriod::Custom => 6_u8,
            TimePeriod::Undefined => 0_u8,
        }
    }
}

impl IntoU8TimePeriod of Into<u8, TimePeriod> {
    fn into(self: u8) -> TimePeriod {
        match self {
            1_u8 => TimePeriod::AllTime,
            2_u8 => TimePeriod::CurrentSeason,
            3_u8 => TimePeriod::Weekly,
            4_u8 => TimePeriod::Monthly,
            5_u8 => TimePeriod::Yearly,
            6_u8 => TimePeriod::Custom,
            _ => TimePeriod::Undefined,
        }
    }
}
