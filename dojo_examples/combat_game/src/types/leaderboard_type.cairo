//
// Leaderboard Type enum
//
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum LeaderboardType {
    Global,
    Tournament,
    Seasonal,
    Weekly,
    Monthly,
    Custom,
    Undefined,
}

impl IntoLeaderboardTypeFelt252 of Into<LeaderboardType, felt252> {
    fn into(self: LeaderboardType) -> felt252 {
        match self {
            LeaderboardType::Global => 1,
            LeaderboardType::Tournament => 2,
            LeaderboardType::Seasonal => 3,
            LeaderboardType::Weekly => 4,
            LeaderboardType::Monthly => 5,
            LeaderboardType::Custom => 6,
            LeaderboardType::Undefined => 0,
        }
    }
}

impl IntoLeaderboardTypeU8 of Into<LeaderboardType, u8> {
    fn into(self: LeaderboardType) -> u8 {
        match self {
            LeaderboardType::Global => 1_u8,
            LeaderboardType::Tournament => 2_u8,
            LeaderboardType::Seasonal => 3_u8,
            LeaderboardType::Weekly => 4_u8,
            LeaderboardType::Monthly => 5_u8,
            LeaderboardType::Custom => 6_u8,
            LeaderboardType::Undefined => 0_u8,
        }
    }
}

impl IntoU8LeaderboardType of Into<u8, LeaderboardType> {
    fn into(self: u8) -> LeaderboardType {
        match self {
            1_u8 => LeaderboardType::Global,
            2_u8 => LeaderboardType::Tournament,
            3_u8 => LeaderboardType::Seasonal,
            4_u8 => LeaderboardType::Weekly,
            5_u8 => LeaderboardType::Monthly,
            6_u8 => LeaderboardType::Custom,
            _ => LeaderboardType::Undefined,
        }
    }
}
