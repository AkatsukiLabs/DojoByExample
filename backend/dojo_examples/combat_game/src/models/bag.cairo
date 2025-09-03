use starknet::ContractAddress;
use crate::types::potion::Potion;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Bag {
    #[key]
    pub bag_id: u256,
    #[key]
    pub player: ContractAddress,
    pub item: Potion,
}

#[generate_trait]
impl BagActions of BagActionsTrait {
    fn add_item(ref self: Bag, item: Potion) {
        self.item = item;
    }

    fn remove_item(ref self: Bag, item: Potion) -> Result<(), felt252> {
        if self.item == item {
            self.item = Potion::Empty;
            Result::Ok(())
        } else {
            Result::Err('Item not found in bag')
        }
    }

    fn is_empty(self: @Bag) -> bool {
        *self.item == Potion::Empty
    }
}

#[cfg(test)]
mod tests {
    use core::result::ResultTrait;
    use starknet::contract_address_const;
    use crate::types::potion::Potion;
    use super::{Bag, BagActions};

    #[test]
    #[available_gas(300000)]
    fn test_bag_initialization() {
        let bag_id = 1_u256;
        let player_id = contract_address_const::<0x0>();

        let bag = Bag { bag_id, player: player_id, item: Potion::Health };

        assert_eq!(bag.bag_id, bag_id, "Bag ID should match");
        assert_eq!(bag.player, player_id, "Player ID should match");
        assert_eq!(bag.item, Potion::Health, "Initial item should be Health");
    }

    #[test]
    #[available_gas(300000)]
    fn test_bag_with_different_item_types() {
        let address = contract_address_const::<0x0>();

        let stamina_bag = Bag { bag_id: 1_u256, player: address, item: Potion::Stamina };
        let mana_bag = Bag { bag_id: 2_u256, player: address, item: Potion::Mana };
        let health_bag = Bag { bag_id: 3_u256, player: address, item: Potion::Health };

        assert_eq!(stamina_bag.item, Potion::Stamina, "Should be Stamina");
        assert_eq!(mana_bag.item, Potion::Mana, "Should be Mana");
        assert_eq!(health_bag.item, Potion::Health, "Should be Health");
    }

    #[test]
    #[available_gas(300000)]
    fn test_empty_bag() {
        let address = contract_address_const::<0x0>();
        let empty_bag = Bag { bag_id: 4_u256, player: address, item: Potion::Empty };

        assert(BagActions::is_empty(@empty_bag), 0);
    }

    #[test]
    #[available_gas(300000)]
    fn test_add_item() {
        let player = contract_address_const::<0x1>();
        let mut bag = Bag { bag_id: 5_u256, player, item: Potion::Empty };

        BagActions::add_item(ref bag, Potion::Mana);
        assert_eq!(bag.item, Potion::Mana, "Item should be Mana");
    }

    #[test]
    #[available_gas(300000)]
    fn test_remove_item_success() {
        let player = contract_address_const::<0x2>();
        let mut bag = Bag { bag_id: 6_u256, player, item: Potion::Health };

        ResultTrait::unwrap(BagActions::remove_item(ref bag, Potion::Health));
        assert_eq!(bag.item, Potion::Empty, "Item should be removed (Empty)");
    }

    #[test]
    #[available_gas(300000)]
    fn test_remove_item_failure() {
        let player = contract_address_const::<0x3>();
        let mut bag = Bag { bag_id: 7_u256, player, item: Potion::Mana };

        let result = BagActions::remove_item(ref bag, Potion::Health);
        assert(result.is_err(), 'Item not found in bag');
    }

    #[test]
    #[available_gas(300000)]
    fn test_is_empty() {
        let player = contract_address_const::<0x4>();
        let bag = Bag { bag_id: 8_u256, player, item: Potion::Empty };

        assert(BagActions::is_empty(@bag), 0);
    }
}
