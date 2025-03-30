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

#[cfg(test)]
mod tests {
    use super::Bag;
    use dojo_starter::types::item_type::ItemType;
    
    #[test]
    #[available_gas(300000)]
    fn test_bag_initialization() {
        let bag_id = 1_u256;
        let player_id = 42_u256;
        let item_type = ItemType::Weapon;
        let quantity = 5_u32;
        
        let bag = Bag {
            bag_id: bag_id,
            player: player_id,
            item_type: item_type,
            quantity: quantity,
        };
        
        assert_eq!(bag.bag_id, bag_id, "Bag ID should match");
        assert_eq!(bag.player, player_id, "Player ID should match");
        assert_eq!(bag.item_type, item_type, "Item type should be Weapon");
        assert_eq!(bag.quantity, quantity, "Quantity should be 5");
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_bag_with_different_item_types() {
        let weapon_bag = Bag {
            bag_id: 1_u256,
            player: 42_u256,
            item_type: ItemType::Weapon,
            quantity: 1_u32,
        };

        let armor_bag = Bag {
            bag_id: 2_u256,
            player: 42_u256,
            item_type: ItemType::Armor,
            quantity: 1_u32,
        };

        let potion_bag = Bag {
            bag_id: 3_u256,
            player: 42_u256,
            item_type: ItemType::Potion,
            quantity: 5_u32,
        };

        assert_eq!(weapon_bag.item_type, ItemType::Weapon, "Should be Weapon type");
        assert_eq!(armor_bag.item_type, ItemType::Armor, "Should be Armor type");
        assert_eq!(potion_bag.item_type, ItemType::Potion, "Should be Potion type");
        
        assert!(weapon_bag.item_type != armor_bag.item_type, "Weapon and armor should differ");
        assert!(weapon_bag.item_type != potion_bag.item_type, "Weapon and potion should differ");
        assert!(armor_bag.item_type != potion_bag.item_type, "Armor and potion should differ");
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_zero_quantity_bag() {
        let empty_bag = Bag {
            bag_id: 5_u256,
            player: 100_u256,
            item_type: ItemType::Weapon,
            quantity: 0_u32,
        };

        assert_eq!(empty_bag.quantity, 0_u32, "Quantity should be zero");
    }
    
    #[test]
    #[available_gas(300000)]
    fn test_large_values() {
        let large_bag_id = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF_u256;
        let large_player_id = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF_u256;
        let large_quantity = 0xFFFFFFFF_u32;
        
        let large_bag = Bag {
            bag_id: large_bag_id,
            player: large_player_id,
            item_type: ItemType::Armor,
            quantity: large_quantity,
        };

        assert_eq!(
            large_bag.bag_id, 
            large_bag_id,
            "Large bag_id should match"
        );
        assert_eq!(
            large_bag.player, 
            large_player_id,
            "Large player should match"
        );
        assert_eq!(
            large_bag.quantity, 
            large_quantity, 
            "Large quantity should match"
        );
    }
}