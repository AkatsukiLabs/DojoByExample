#[cfg(test)]
mod tests {
    use dojo_starter::models::tournament::*;
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
