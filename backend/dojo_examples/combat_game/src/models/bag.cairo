use starknet::ContractAddress;

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct Bag {
    pub bag_id: u256,  
    pub player: ContractAddress,  
    pub quantity: u32,  
}

#[cfg(test)]
mod tests {
    use super::Bag;
    use starknet::ContractAddress;
    
    #[test]
    #[available_gas(300000)]
    fn test_bag_initialization() {
        let bag_id: u256 = 1_u256;
        let player_id: ContractAddress = 0.try_into().unwrap();
        let quantity: u32 = 5;
        
        let bag = Bag {
            bag_id: bag_id,
            player: player_id,
            quantity: quantity,
        };
        
        assert(bag.bag_id == bag_id, 'Bag ID should match');
        assert(bag.player == player_id, 'Player ID should match');
        assert(bag.quantity == quantity, 'Quantity should be 5');
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_bag_with_different_item_types() {
        let address: ContractAddress = 0.try_into().unwrap();

        let weapon_bag = Bag {
            bag_id: 1_u256,
            player: address,
            quantity: 1,
        };

        let armor_bag = Bag {
            bag_id: 2_u256,
            player: address,
            quantity: 1,
        };

        let potion_bag = Bag {
            bag_id: 3_u256,
            player: address,
            quantity: 5,
        };

        assert(weapon_bag.quantity == 1, 'Weapon bag should have 1 item');
        assert(armor_bag.quantity == 1, 'Armor bag should have 1 item');
        assert(potion_bag.quantity == 5, 'Potion bag should have 5 items');
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_zero_quantity_bag() {
        let address: ContractAddress = 0.try_into().unwrap();

        let empty_bag = Bag {
            bag_id: 1_u256,
            player: address,
            quantity: 0,
        };

        assert(empty_bag.quantity == 0, 'Quantity should be zero');
    }
}