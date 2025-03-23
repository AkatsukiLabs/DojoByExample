use starknet::ContractAddress;
use combat_game::types::beast::BeastType;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub beast_id: u256,
    #[key]
    pub player: ContractAddress,
    pub beast_type: BeastType,
}

