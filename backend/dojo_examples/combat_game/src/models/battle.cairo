use starknet::{ContractAddress, get_block_timestamp};
use core::num::traits::zero::Zero;
use combat_game::{
    helpers::{pseudo_random::PseudoRandom::generate_random_u8},
    types::{
        battle_status::BattleStatus,
    },
};

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
    pub timestamp_last_action: u64
}

#[generate_trait]
pub impl BattleImpl of BattleTrait {
    fn new(id: u256, player1: ContractAddress, player2: ContractAddress, battle_type: u8) -> Battle {
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
            winner_id:  Zero::zero(),
            battle_type: battle_type,
            timestamp_start: current_timestamp,
            timestamp_last_action: current_timestamp
        }
    }

    fn end(ref self: Battle, winner: ContractAddress ) {
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
        self.current_turn = if self.current_turn == self.player1 { self.player2 } else { self.player1 };
    }

}

#[cfg(test)]
mod tests {
    use starknet::{contract_address_const};
    use super::{Battle, BattleTrait};

    #[test]
    fn test_end() {
        let mut battle = testing_battle();
        let winner = contract_address_const::<0x1>();
        battle.end(winner);

        assert!(battle.winner_id == winner);
    }

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
    fn test_switch_turn() {
        let mut battle = testing_battle();

        let current_turn = battle.current_turn;

        battle.switch_turn();
        assert!(battle.current_turn != current_turn);
    }

    // MOCK
    fn testing_battle() -> Battle {
        BattleTrait::new(1, contract_address_const::<0x1>(), contract_address_const::<0x2>(), 1)
    }
}


