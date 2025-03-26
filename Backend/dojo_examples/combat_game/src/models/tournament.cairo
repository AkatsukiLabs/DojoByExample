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

#[cfg(test)]
mod tests {
    use combat_game::models::tournament::*;
    use starknet::{contract_address_const, ContractAddress};

    fn USER1() -> ContractAddress {
        contract_address_const::<'USER1'>()
    }

    fn init_default_tournament() -> Tournament {
        let init_params = TournamentParams {
            name: "My Tournament",
            creator: Option::None,
            description: "Description",
            start_date: 0,
            end_date: 500,
            rules: array![],
            available_rewards: array![],
        };

        let tournament = TournamentTrait::new(1, init_params);

        assert(tournament.id == 1, 'INCORRECT ID');
        assert(tournament.name == "My Tournament", 'INCORRECT NAME');
        assert(tournament.description == "Description", 'INCORRECT DESCRIPTION');
        assert(tournament.status == TournamentStatus::Pending, 'INCORRECT STATUS');

        tournament
    }

    #[test]
    fn test_tournament_creation_success() {
        let _ = init_default_tournament();
    }

    #[test]
    fn test_tournament_should_add_participants_successfully() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1(), USER1()];

        tournament.add_participants(participants.clone());
        assert(tournament.total_participants == 2, 'FIRST FAILED');

        tournament.add_participants(participants);
        assert(tournament.total_participants == 4, 'SECOND FAILED');
    }

    #[test]
    fn test_tournament_start_success() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1(), USER1()];
        tournament.add_participants(participants);
        tournament.start();

        assert(tournament.status == TournamentStatus::In_Progress, 'START FAILED');
    }

    #[test]
    #[should_panic]
    fn test_tournament_should_panic_on_invalid_number_of_participants() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1()];
        tournament.add_participants(participants);
        tournament.start();
    }

    #[test]
    #[should_panic(expected: "TOURNAMENT ALREADY IN PROGRESS.")]
    fn test_tournament_should_panic_on_start_already_in_progress() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1(), USER1()];
        tournament.add_participants(participants);
        tournament.start();

        // start tournament again
        tournament.start();
    }

    #[test]
    fn test_tournament_should_end_successfully() {
        let mut tournament = init_default_tournament();
        tournament.end();

        assert(tournament.status == TournamentStatus::Finished, 'END FAILED');
    }

    #[test]
    #[should_panic(expected: "TOURNAMENT ALREADY ENDED.")]
    fn test_tournament_should_panic_on_restarting_of_finished_tournament() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1(), USER1()];
        tournament.add_participants(participants);
        tournament.start();
        tournament.end();

        tournament.start();
    }

    #[test]
    #[should_panic(expected: "CANNOT ADD PARTICIPANT. TOURNAMENT NOT PENDING.")]
    fn test_tournament_should_panic_on_addition_of_participants_to_started_tournament() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1(), USER1()];
        tournament.add_participants(participants.clone());
        tournament.start();

        tournament.add_participants(participants);
    }

    #[test]
    fn test_tournament_should_add_matchups_successfully() {
        let mut tournament = init_default_tournament();
        let participants = array![USER1(), USER1()];
        tournament.add_participants(participants.clone());
        let matchups = array![1, 2];
        tournament.add_matchups(matchups);

        tournament.start();
    }
}
