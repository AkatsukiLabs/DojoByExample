use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Food {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub id: u8,
    pub amount: u8,
    pub healt_points: u8
}

pub trait FoodTrait {
    fn new_food(id: u8, player: ContractAddress) -> Food;
}

pub impl FoodImpl of FoodTrait {
    fn new_food(id: u8, player: ContractAddress) -> Food {
        let food: Food = Food {
            player: player,
            id: id,
            amount: 0,
            healt_points: 1
        };
        food
    }
}
