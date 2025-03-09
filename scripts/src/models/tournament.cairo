use starknet::ContractAddress;

#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Tournament {
    #[key]
    pub id: u256,
    pub name: ByteArray,
    pub description: ByteArray,
    pub start_date: u64,
    pub end_date: u64,
    pub status: TournamentStatus,
    pub total_participants: u256,
    pub list_of_participants: Array<ContractAddress>,
    pub rules: Array<felt252>,
    pub match_ups: Array<u256>,
    pub available_rewards: Array<u256>,
}

#[derive(Copy, Default, Drop, Introspect, Serde, Debug)]
pub enum TournamentStatus {
    #[default]
    Pending,
    In_Progress,
    Finished,
}
