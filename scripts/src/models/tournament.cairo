use core::fmt::Debug;
use starknet::{ContractAddress};

#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Tournament {
    #[key]
    pub id: u256,
    pub name: ByteArray,
    pub creator: Option<ContractAddress>,
    pub description: ByteArray,
    pub start_date: u64,
    pub end_date: u64,
    pub status: TournamentStatus,
    pub total_participants: u256,
    pub list_of_participants: Array<ContractAddress>,
    pub rules: Array<felt252>,
    pub matchups: Array<u256>,
    pub available_rewards: Array<u256>,
}

#[derive(Copy, Default, Drop, Introspect, Serde, Debug, PartialEq)]
pub enum TournamentStatus {
    #[default]
    Pending,
    In_Progress,
    Finished,
}

#[derive(Drop)]
pub struct TournamentParams {
    pub name: ByteArray,
    pub creator: Option<ContractAddress>,
    pub description: ByteArray,
    pub start_date: u64,
    pub end_date: u64,
    pub rules: Array<felt252>,
    pub available_rewards: Array<u256>,
}

pub trait TournamentTrait {
    fn new(id: u256, init_params: TournamentParams) -> Tournament;
    fn start(ref self: Tournament);
    fn end(ref self: Tournament);
    fn add_participants(ref self: Tournament, participants: Array<ContractAddress>);
    fn add_matchups(ref self: Tournament, matchups: Array<u256>);
}

pub impl TournamentImpl of TournamentTrait {
    fn new(id: u256, init_params: TournamentParams) -> Tournament {
        let mut tournament: Tournament = Default::default();
        tournament.id = id;
        tournament.name = init_params.name;
        tournament.creator = init_params.creator;
        tournament.description = init_params.description;
        tournament.start_date = init_params.start_date;
        tournament.end_date = init_params.end_date;
        tournament.rules = init_params.rules;
        tournament.available_rewards = init_params.available_rewards;

        tournament
    }

    fn start(ref self: Tournament) {
        assert!(
            self.total_participants > 1,
            "CANNOT START TOURNAMENT WITH {} PARTICIPANTS",
            self.total_participants,
        );
        match self.status {
            TournamentStatus::Pending => self.status = TournamentStatus::In_Progress,
            TournamentStatus::In_Progress => panic!("TOURNAMENT ALREADY IN PROGRESS."),
            TournamentStatus::Finished => panic!("TOURNAMENT ALREADY ENDED."),
        };
    }

    fn end(ref self: Tournament) {
        assert!(self.status != TournamentStatus::Finished, "TOURNAMENT ALREADY ENDED.");
        self.status = TournamentStatus::Finished;
    }

    fn add_participants(ref self: Tournament, participants: Array<ContractAddress>) {
        assert!(
            self.status == TournamentStatus::Pending,
            "CANNOT ADD PARTICIPANT. TOURNAMENT NOT PENDING.",
        );
        for participant in participants {
            self.list_of_participants.append(participant);
            self.total_participants += 1;
        };
    }

    fn add_matchups(ref self: Tournament, matchups: Array<u256>) {
        assert!(
            self.status == TournamentStatus::Pending, "CANNOT ADD MATCHUP. TOURNAMENT NOT PENDING.",
        );
        for matchup in matchups {
            self.matchups.append(matchup);
        };
    }
}

