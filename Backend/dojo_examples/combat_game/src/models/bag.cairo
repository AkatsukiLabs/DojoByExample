use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Bag {
    #[key]
    pub bag_id: u256,  
    #[key]
    pub player: ContractAddress,  
    pub quantity: u32,  
}

#[cfg(test)]
mod tests {
    use super::Bag;
    
    #[test]
    #[available_gas(300000)]
    fn test_bag_initialization() {
        let bag_id = 1;
        let player_id = starknet::contract_address_const::<0x0>();
        let quantity = 5;
        
        let bag = Bag {
            bag_id: bag_id,
            player: player_id,
            quantity: quantity,
        };
        
        assert_eq!(bag.bag_id, bag_id, "Bag ID should match");
        assert_eq!(bag.player, player_id, "Player ID should match");
        assert_eq!(bag.quantity, quantity, "Quantity should be 5");
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_bag_with_different_item_types() {

        let address = starknet::contract_address_const::<0x0>();

        let weapon_bag = Bag {
            bag_id: 1,
            player: address,
            quantity: 1,
        };

        let armor_bag = Bag {
            bag_id: 2,
            player: address,
            quantity: 1,
        };

        let potion_bag = Bag {
            bag_id: 3,
            player: address,
            quantity: 5,
        };


    }
    
    #[test]
    #[available_gas(300000)]
    fn test_zero_quantity_bag() {

        let address = starknet::contract_address_const::<0x0>();

        let empty_bag = Bag {
            bag_id: 1,
            player: address,
            quantity: 0,
        };

        assert_eq!(empty_bag.quantity, 0, "Quantity should be zero");
    }
    
}