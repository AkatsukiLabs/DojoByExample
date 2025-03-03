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


#[cfg(test)]
mod tests {

    use dojo_starter::{models::{food::FoodTrait}};
    use starknet::{get_caller_address};

    #[test]
    fn test_new_food() {
        let player = get_caller_address();
        let food_id = 1;

        let food = FoodTrait::new_food(food_id, player);

        assert_eq!(food.player, player, "The game id should be the expected");

    }
}