//
// Ranking Criteria enum
//
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum RankingCriteria {
    Wins,
    WinRatio,
    Points,
    BattlesWon,
    BeastsDefeated,
    TournamentsWon,
    AverageScore,
    Custom,
    Undefined,
}

impl IntoRankingCriteriaFelt252 of Into<RankingCriteria, felt252> {
    fn into(self: RankingCriteria) -> felt252 {
        match self {
            RankingCriteria::Wins => 1,
            RankingCriteria::WinRatio => 2,
            RankingCriteria::Points => 3,
            RankingCriteria::BattlesWon => 4,
            RankingCriteria::BeastsDefeated => 5,
            RankingCriteria::TournamentsWon => 6,
            RankingCriteria::AverageScore => 7,
            RankingCriteria::Custom => 8,
            RankingCriteria::Undefined => 0,
        }
    }
}

impl IntoRankingCriteriaU8 of Into<RankingCriteria, u8> {
    fn into(self: RankingCriteria) -> u8 {
        match self {
            RankingCriteria::Wins => 1_u8,
            RankingCriteria::WinRatio => 2_u8,
            RankingCriteria::Points => 3_u8,
            RankingCriteria::BattlesWon => 4_u8,
            RankingCriteria::BeastsDefeated => 5_u8,
            RankingCriteria::TournamentsWon => 6_u8,
            RankingCriteria::AverageScore => 7_u8,
            RankingCriteria::Custom => 8_u8,
            RankingCriteria::Undefined => 0_u8,
        }
    }
}

impl IntoU8RankingCriteria of Into<u8, RankingCriteria> {
    fn into(self: u8) -> RankingCriteria {
        match self {
            1_u8 => RankingCriteria::Wins,
            2_u8 => RankingCriteria::WinRatio,
            3_u8 => RankingCriteria::Points,
            4_u8 => RankingCriteria::BattlesWon,
            5_u8 => RankingCriteria::BeastsDefeated,
            6_u8 => RankingCriteria::TournamentsWon,
            7_u8 => RankingCriteria::AverageScore,
            8_u8 => RankingCriteria::Custom,
            _ => RankingCriteria::Undefined,
        }
    }
}
