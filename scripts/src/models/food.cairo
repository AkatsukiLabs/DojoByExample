use starknet::{ContractAddress};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Food {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub id: u8,
    pub amount: u8,
    pub healt_points: u8,
    pub name: felt252,
    pub healing_value: u8,
    pub stamina_recovery: u8,
    pub duration: u8
}

#[cfg(test)]
mod tests {

    use super::Food;
    use starknet::{ContractAddress, contract_address_const};

    #[test]
    #[available_gas(300000)]
    fn test_food_initialization() {
        let player_address: ContractAddress = contract_address_const::<0x0>();

        let food = Food { 
            player: player_address,
            id: 1_u8,
            amount: 5_u8,
            healt_points: 5_u8,
            name:'Apple',
            healing_value: 5_u8,
            stamina_recovery: 5_u8,
            duration: 10_u8
        };

        assert_eq!(food.player, player_address, "Player address should match");
        assert_eq!(food.id, 1_u8, "Food ID should be 1");
        assert_eq!(food.amount, 5_u8, "Food amount should be 5");
        assert_eq!(food.healt_points, 5_u8, "Food health");
        assert_eq!(food.name, 'Apple', "Food should be an Apple");
        assert_eq!(food.healing_value, 5_u8, "Food healing value should be 5");
        assert_eq!(food.stamina_recovery, 5_u8, "Food stamina recovery value should be 5");
        assert_eq!(food.duration, 10_u8, "Food duration should be 10s");
    }
}