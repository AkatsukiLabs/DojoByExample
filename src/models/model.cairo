use starknet::ContractAddress;

// Base game models will go here
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Player {
    #[key]
    pub player: ContractAddress,
    pub health: u8,
}