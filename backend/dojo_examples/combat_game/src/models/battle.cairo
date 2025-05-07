use starknet::ContractAddress;
use combat_game::types::battle_status::BattleStatus;

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
}

