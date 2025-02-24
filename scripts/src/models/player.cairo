use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Player {
    #[key]
    address: ContractAddress,
    current_beast: felt252, // TODO: Change to the BeastType enum when added
    arena: felt252, // TODO: Change to Arena enum when added
    trophies: usize,
}