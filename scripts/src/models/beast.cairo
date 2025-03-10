use dojo_starter::models::player::Player;
use dojo_starter::types::beast_type::BeastType;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub beast_id: u256,
    #[key]
    pub player: Player,
    pub beast_type: BeastType
}

