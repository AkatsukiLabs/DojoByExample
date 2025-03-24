#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum RankingCriteria {
    Undefined,
    Wins,
    WinRatio,
    Points,
    BattlesWon,
    BeastsDefeated,
    TournamentsWon,
    AverageScore,
    Custom,
}

impl IntoRankingCriteriaFelt252 of Into<RankingCriteria, felt252> {
    fn into(self: RankingCriteria) -> felt252 {
        match self {
            RankingCriteria::Undefined => 0,
            RankingCriteria::Wins => 1,
            RankingCriteria::WinRatio => 2,
            RankingCriteria::Points => 3,
            RankingCriteria::BattlesWon => 4,
            RankingCriteria::BeastsDefeated => 5,
            RankingCriteria::TournamentsWon => 6,
            RankingCriteria::AverageScore => 7,
            RankingCriteria::Custom => 8,
        }
    }
}

impl IntoRankingCriteriaU8 of Into<RankingCriteria, u8> {
    fn into(self: RankingCriteria) -> u8 {
        match self {
            RankingCriteria::Undefined => 0,
            RankingCriteria::Wins => 1,
            RankingCriteria::WinRatio => 2,
            RankingCriteria::Points => 3,
            RankingCriteria::BattlesWon => 4,
            RankingCriteria::BeastsDefeated => 5,
            RankingCriteria::TournamentsWon => 6,
            RankingCriteria::AverageScore => 7,
            RankingCriteria::Custom => 8,
        }
    }
}

impl IntoU8RankingCriteria of Into<u8, RankingCriteria> {
    fn into(self: u8) -> RankingCriteria {
        match self {
            0 => RankingCriteria::Undefined,
            1 => RankingCriteria::Wins,
            2 => RankingCriteria::WinRatio,
            3 => RankingCriteria::Points,
            4 => RankingCriteria::BattlesWon,
            5 => RankingCriteria::BeastsDefeated,
            6 => RankingCriteria::TournamentsWon,
            7 => RankingCriteria::AverageScore,
            8 => RankingCriteria::Custom,
            _ => RankingCriteria::Undefined,
        }
    }
}
