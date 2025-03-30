use starknet::ContractAddress;
use dojo_starter::models::player::Player;
use dojo_starter::types::item_type::ItemType;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Bag {
    #[key]
    pub bag_id: u256,  // Unique identifier for the bag
    #[key]
    pub player: u256,  // The player who owns the bag
    pub item_type: ItemType,  // The type of item stored in the bag
    pub quantity: u32,  // The quantity of the item in the bag
}