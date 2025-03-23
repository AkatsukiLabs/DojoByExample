#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum LeaderboardType {
    Undefined,
    Global,
    Tournament,
    Seasonal,
    Weekly,
    Monthly,
    Custom,
}

impl IntoLeaderboardTypeFelt252 of Into<LeaderboardType, felt252> {
    fn into(self: LeaderboardType) -> felt252 {
        match self {
            LeaderboardType::Undefined => 0,
            LeaderboardType::Global => 1,
            LeaderboardType::Tournament => 2,
            LeaderboardType::Seasonal => 3,
            LeaderboardType::Weekly => 4,
            LeaderboardType::Monthly => 5,
            LeaderboardType::Custom => 6,
        }
    }
}

impl IntoLeaderboardTypeU8 of Into<LeaderboardType, u8> {
    fn into(self: LeaderboardType) -> u8 {
        match self {
            LeaderboardType::Undefined => 0,
            LeaderboardType::Global => 1,
            LeaderboardType::Tournament => 2,
            LeaderboardType::Seasonal => 3,
            LeaderboardType::Weekly => 4,
            LeaderboardType::Monthly => 5,
            LeaderboardType::Custom => 6,
        }
    }
}

impl IntoU8LeaderboardType of Into<u8, LeaderboardType> {
    fn into(self: u8) -> LeaderboardType {
        match self {
            0 => LeaderboardType::Undefined,
            1 => LeaderboardType::Global,
            2 => LeaderboardType::Tournament,
            3 => LeaderboardType::Seasonal,
            4 => LeaderboardType::Weekly,
            5 => LeaderboardType::Monthly,
            6 => LeaderboardType::Custom,
            _ => LeaderboardType::Undefined,
        }
    }
}
