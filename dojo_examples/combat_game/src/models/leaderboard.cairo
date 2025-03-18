use starknet::ContractAddress;
use dojo_starter::models::player::Player;
use dojo_starter::types::{
    leaderboard_type::LeaderboardType, time_period_type::TimePeriod, ranking_criteria_type::RankingCriteria
}


//
// Player Ranking entry
//
#[derive(Copy, Drop, Serde, Debug)]
pub struct PlayerRanking {
    #[key]
    pub player: Player<ContractAddress>,
    pub rank: u32,
    pub score: u64,
    pub stats: Array<u64>, // Additional stats relevant to the ranking criteria
    pub last_updated: u64 // Timestamp of when this player's ranking was last updated
}

//
// Main Leaderboard model
//
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Leaderboard {
    #[key]
    pub leaderboard_id: u256,
    pub name: felt252, // Leaderboard name/title
    pub leaderboard_type: LeaderboardType,
    pub ranking_criteria: RankingCriteria,
    pub time_period: TimePeriod,
    pub start_timestamp: u64, // When this leaderboard period started
    pub end_timestamp: u64, // When this leaderboard period ends (0 for ongoing)
    pub rankings: Array<PlayerRanking>, // List of ranked players with their scores
    pub last_updated: u64, // Timestamp of when the leaderboard was last updated
}

//
// Player Ranking model - for individual player lookup
//
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerLeaderboardRanking {
    #[key]
    pub player: Player<ContractAddress>,
    #[key]
    pub leaderboard_id: u256,
    pub rank: u32,
    pub score: u64,
    pub stats: Array<u64>, // Additional stats relevant to the ranking criteria
    pub last_updated: u64 // Timestamp of when this player's ranking was last updated
}
