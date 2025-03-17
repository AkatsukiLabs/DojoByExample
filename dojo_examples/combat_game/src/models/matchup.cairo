use starknet::ContractAddress;

#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Matchup {
    #[key]
    pub id: u256,
    pub alias: felt252,
    pub players: Array<ContractAddress>,
    pub current_score: u256,
    pub total_rewards: Array<u256>,
}
