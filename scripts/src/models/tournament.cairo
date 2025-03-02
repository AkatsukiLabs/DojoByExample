use starknet::ContractAddress;

/// Struct for Tournament
///
/// **fields**
/// - id: Id for the Tournament
/// - name: Name associated with the Tournament
/// - description: Description, further details of the tournament
/// - start_date: start date of the tournament
/// - end_date: end_date of the tournament
/// - status: Takes in a TournamentStatus
/// - max_no_of_participants: The max number of participants the tournament can contain
/// - list_of_participants: the list of users participating (reference to player)
/// - rules: takes in a felt252 of rules constants
/// - matchups: all available duos or groups in the tournament (reference to matchup)
/// - available_rewards: all possible rewards the tournament can offer
#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Tournament {
    #[key]
    pub id: u256,
    pub name: ByteArray,
    pub description: ByteArray,
    pub start_date: u64,
    pub end_date: u64,
    pub status: TournamentStatus,
    pub max_no_of_participants: u256,
    pub list_of_participants: Array<ContractAddress>,
    pub rules: Array<felt252>,
    pub match_ups: Array<u256>,
    pub available_rewards: Array<Reward>,
}

/// Enum for TournamentStatus
///
/// **fields**
/// - Pending: Tournament has not started yet
/// - In_Progress: Tournament is in progress
/// - Finished: Tournament is finished
#[derive(Copy, Default, Drop, Introspect, Serde, Debug)]
pub enum TournamentStatus {
    #[default]
    Pending,
    In_Progress,
    Finished,
}

/// Struct for Player
///
/// **fields**
/// - id: the player model id
/// - current_matchups: Considering that a player can be in various tournaments at once, takes in an
/// array referencing matchups
/// - stats: PlayerStats
#[derive(Clone, Drop, Serde, Debug)]
#[dojo::model]
pub struct Player {
    #[key]
    pub id: ContractAddress,
    pub current_matchups: Array<u256>,
    pub stats: PlayerStats,
}

/// Struct for PlayerStats:
/// Savedd stats history for Players
///
/// **fields**
/// - highest_score: Tuple of Record for highest score gotten, if any, matched to the tournament id
/// - tournaments_participated: Array of references to tournaments participated. For number of
/// tournaments participated in, use `this_array.len()`
/// - rewards: List of all rewards received. Same as above for `this_array.len()`
/// - win_count: Number of wins
/// - matchup_list: List reference to all matchups
#[derive(Clone, Drop, Serde, Introspect, Debug)]
pub struct PlayerStats {
    pub highest_score: (u256, u256),
    pub tournaments_participated: Array<u256>,
    pub rewards: Array<Reward>,
    pub win_count: u64,
    pub matchup_list: Array<u256>,
}

/// Struct for bracket/pair (matchup) for a given tournament
///
/// **fields**
///
/// - id: The id of the Matchup
/// - alias: A fun alias for the team/matchup
/// - players: List of referenced players in the matchup
/// - current_score: Current score of the matchup
/// - total_rewards: total rewards earned from tournament
#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Matchup {
    #[key]
    pub id: u256,
    pub alias: felt252,
    pub players: Array<ContractAddress>,
    pub current_score: u256,
    pub total_rewards: Array<Reward>,
}

/// Struct for Reward
///
/// **fields**
/// - reward_type: the optional type of reward
/// - description: optional description of reward
/// - amount: optional amount for rewards that have an amount
/// - metadata: any further metadata to annotate the reward
#[derive(Clone, Default, Drop, Introspect, Serde, Debug)]
pub struct Reward {
    pub reward_type: Option<RewardType>,
    pub description: Option<ByteArray>,
    pub amount: Option<u256>,
    pub metadata: felt252,
}

/// Enum RewardType:
/// The Type of Reward to be distributed in the Tournament
///
/// **fields**
/// - NFT: Non fungible tokens
/// - Token: Fungible Tokens
/// - In_Game: In game incentives/priviledges
/// - Real_World: Real world assets/merchs
#[derive(Copy, Default, Drop, Introspect, Serde, Debug)]
pub enum RewardType {
    NFT: ContractAddress,
    #[default]
    Token: ContractAddress,
    In_Game,
    Real_World,
}

/// Struct for ID (Identity): An id producer
///
/// **fields**
/// - id: Id of "structure" you wish to produce an id for. Takes a felt. e.g for Game ids, you can
/// use 'GAME ID'
/// - nonce: id produced for entities under a particular "structure"
#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct ID {
    #[key]
    pub id: felt252,
    pub nonce: u256,
}
