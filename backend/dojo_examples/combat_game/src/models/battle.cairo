use combat_game::helpers::pseudo_random::PseudoRandom::generate_random_u8;
use combat_game::types::battle_status::BattleStatus;
use core::num::traits::zero::Zero;
use starknet::{ContractAddress, get_block_timestamp};

#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
#[dojo::model]
pub struct Battle {
    #[key]
    pub id: u256,
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub current_turn: ContractAddress,
    pub status: BattleStatus,
    pub winner_id: ContractAddress,
    pub battle_type: u8,
    pub timestamp_start: u64,
    pub timestamp_last_action: u64,
}

#[generate_trait]
pub impl BattleImpl of BattleTrait {
    fn new(
        id: u256, player1: ContractAddress, player2: ContractAddress, battle_type: u8,
    ) -> Battle {
        let current_timestamp = get_block_timestamp();
        let players = array![player1, player2];
        Battle {
            id: id,
            player1: player1,
            player2: player2,
            current_turn: *players
                .at(
                    generate_random_u8(
                        id.try_into().unwrap(), 0, 0, players.len().try_into().unwrap() - 1,
                    )
                        .into(),
                ),
            status: BattleStatus::Waiting,
            winner_id: Zero::zero(),
            battle_type: battle_type,
            timestamp_start: current_timestamp,
            timestamp_last_action: current_timestamp,
        }
    }

    fn end(ref self: Battle, winner: ContractAddress) {
        self.status = BattleStatus::Finished.into();
        self.winner_id = winner;
        self.timestamp_last_action = get_block_timestamp();
    }

    fn update_timestamp(ref self: Battle) {
        self.timestamp_last_action = get_block_timestamp();
    }

    fn is_active(ref self: Battle) -> bool {
        self.status == BattleStatus::Active
    }

    fn is_finished(ref self: Battle) -> bool {
        self.status == BattleStatus::Finished
    }

    fn switch_turn(ref self: Battle) {
        self
            .current_turn =
                if self.current_turn == self.player1 {
                    self.player2
                } else {
                    self.player1
                };
    }
}

#[cfg(test)]
mod tests {
    use combat_game::types::battle_status::BattleStatus;
    use core::num::traits::zero::Zero;
    use starknet::contract_address_const;
    use super::{Battle, BattleTrait};

    #[test]
    fn test_end() {
        let mut battle = testing_battle();
        let winner = contract_address_const::<0x1>();
        battle.end(winner);

        assert!(battle.winner_id == winner);
        assert!(battle.status == BattleStatus::Finished);
    }

    // #[test]
    // fn test_update_timestamp() {
    //     let mut battle = testing_battle();
    //     let timestamp_before = battle.timestamp_last_action;
    //     let winner = contract_address_const::<0x1>();
    //     battle.end(winner);
    //     let timestamp_after = battle.timestamp_last_action;

    //     println!("timestamp_before: {}", timestamp_before);
    //     println!("timestamp_after: {}", timestamp_after);

    //     assert!(timestamp_after > timestamp_before);
    // }

    #[test]
    fn test_is_active() {
        let mut battle = testing_battle();

        assert!(battle.is_active() == false, "Wrong battle status");
    }

    #[test]
    fn test_is_finished() {
        let mut battle = testing_battle();

        assert!(battle.is_finished() == false, "Wrong battle status");
    }

    #[test]
    fn test_is_finished_after_end() {
        let mut battle = testing_battle();

        assert!(battle.is_finished() == false, "Wrong battle status");
        let winner = contract_address_const::<0x1>();
        battle.end(winner);

        assert!(battle.is_finished() == true, "Battle should be finished after end");
        assert!(battle.status == BattleStatus::Finished, "Battle status should be Finished");
    }

    #[test]
    fn test_switch_turn_multiple_times() {
        let mut battle = testing_battle();
        let initial_turn = battle.current_turn;

        // First switch
        battle.switch_turn();
        let after_first_switch = battle.current_turn;
        assert!(after_first_switch != initial_turn, "Turn should switch");

        // Second switch - should return to original player
        battle.switch_turn();
        let after_second_switch = battle.current_turn;
        assert!(after_second_switch == initial_turn, "Turn should switch back");
        assert!(after_second_switch != after_first_switch, "Turn should be different");
    }

    #[test]
    fn test_switch_turn() {
        let mut battle = testing_battle();

        let current_turn = battle.current_turn;

        battle.switch_turn();
        assert!(battle.current_turn != current_turn);
    }

    #[test]
    fn test_switch_turn_alternates_correctly() {
        let mut battle = testing_battle();
        let player1 = battle.player1;
        let player2 = battle.player2;

        // Ensure we know the starting turn
        if battle.current_turn == player1 {
            battle.switch_turn();
            assert!(battle.current_turn == player2, "Switch to player2");
            battle.switch_turn();
            assert!(battle.current_turn == player1, "Switch to player1");
        } else {
            battle.switch_turn();
            assert!(battle.current_turn == player1, "Switch to player1");
            battle.switch_turn();
            assert!(battle.current_turn == player2, "Switch to player2");
        }
    }

    #[test]
    fn test_battle_status_transitions() {
        let mut battle = testing_battle();

        // Initial status should be Waiting
        assert!(battle.status == BattleStatus::Waiting, "Initial status Waiting");

        // End the battle
        let winner = battle.player1;
        battle.end(winner);

        // Status should now be Finished
        assert!(battle.status == BattleStatus::Finished, "Status should be Finished");
        assert!(battle.is_finished(), "is_finished should return true");
        assert!(!battle.is_active(), "is_active should return false");
    }

    #[test]
    fn test_battle_with_zero_addresses() {
        let zero_address = Zero::zero();
        let battle = BattleTrait::new(1, zero_address, zero_address, 1);

        assert!(battle.player1 == zero_address, "Player1 should be zero");
        assert!(battle.player2 == zero_address, "Player2 should be zero");
        assert!(battle.current_turn == zero_address, "Current turn should be zero");
    }


    #[test]
    fn test_battle_consistency_after_operations() {
        let mut battle = testing_battle();
        let original_id = battle.id;
        let original_player1 = battle.player1;
        let original_player2 = battle.player2;
        let original_battle_type = battle.battle_type;
        let original_timestamp_start = battle.timestamp_start;

        // Perform various operations
        battle.switch_turn();
        battle.update_timestamp();
        battle.end(battle.player1);

        // Verify that core properties remain unchanged
        assert!(battle.id == original_id, "ID should remain unchanged");
        assert!(battle.player1 == original_player1, "Player1 should remain unchanged");
        assert!(battle.player2 == original_player2, "Player2 should remain unchanged");
        assert!(battle.battle_type == original_battle_type, "Battle type should remain unchanged");
        assert!(
            battle.timestamp_start == original_timestamp_start,
            "Start timestamp should remain unchanged",
        );
    }

    // MOCK
    fn testing_battle() -> Battle {
        BattleTrait::new(1, contract_address_const::<0x1>(), contract_address_const::<0x2>(), 1)
    }
}

