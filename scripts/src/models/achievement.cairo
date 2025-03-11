use core::dict::Felt252Dict;

#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Achievement {
    #[key]
    pub id: u256, 
    pub name: ByteArray, 
    pub description: ByteArray, 
    pub criteria: Felt252Dict<u256>, 
    pub rewards: Array<u256>, 
    pub is_hidden: bool,
}