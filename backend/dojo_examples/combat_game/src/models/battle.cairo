use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Battle {
    #[key]
    pub id: u256,
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub current_turn: ContractAddress,
    pub status: u8,
    pub winner_id: ContractAddress,
    pub battle_type: u8,
}

