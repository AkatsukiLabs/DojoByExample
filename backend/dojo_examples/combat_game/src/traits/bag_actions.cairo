use crate::models::bag::Bag;

pub trait BagActions<T> {
    fn add_quantity(ref self: T, quantity: u32);
    fn remove_quantity(ref self: T, quantity: u32) -> Result::<(), felt252>;
    fn is_empty(self: @T) -> bool;
    fn total_quantity(self: @T) -> u32;
}

impl BagActionsImpl of BagActions<Bag> {
    fn add_quantity(ref self: Bag, quantity: u32) {
        self.quantity += quantity;
    }

    fn remove_quantity(ref self: Bag, quantity: u32) -> Result::<(), felt252> {
        if (self.quantity < quantity) {
            return Result::Err('Not enough items in bag');
        }
        self.quantity -= quantity;
        Result::Ok(())
    }

    fn is_empty(self: @Bag) -> bool {
        *self.quantity == 0_u32
    }

    fn total_quantity(self: @Bag) -> u32 {
        *self.quantity
    }
}

#[cfg(test)]
mod tests {
    use super::{BagActions, BagActionsImpl};
    use crate::models::bag::Bag;
    use starknet::contract_address_const;
    use core::result::ResultTrait;

    #[test]
    #[available_gas(300000)]
    fn test_add_quantity() {
        let player = contract_address_const::<0x1>();
        let mut bag = Bag {
            bag_id: 1,
            player,
            quantity: 5,
        };

        BagActionsImpl::add_quantity(ref bag, 3);
        assert_eq!(bag.quantity, 8, "Quantity should be increased by 3");
    }

    #[test]
    #[available_gas(300000)]
    fn test_remove_quantity_success() {
        let player = contract_address_const::<0x2>();
        let mut bag = Bag {
            bag_id: 2,
            player,
            quantity: 5,
        };

        BagActionsImpl::remove_quantity(ref bag, 3).unwrap();
        assert_eq!(bag.quantity, 2, "Quantity should be decreased by 3");
    }

    #[test]
    #[available_gas(300000)]
    fn test_remove_quantity_failure() {
        let player = contract_address_const::<0x3>();
        let mut bag = Bag {
            bag_id: 3,
            player,
            quantity: 2,
        };

        let result = BagActionsImpl::remove_quantity(ref bag, 5);
        assert(result.is_err(), 'removing more than available');
    }

    #[test]
    #[available_gas(300000)]
    fn test_is_empty() {
        let player = contract_address_const::<0x4>();
        let bag = Bag {
            bag_id: 4,
            player,
            quantity: 0,
        };

        assert(BagActionsImpl::is_empty(@bag), 0);
    }

    #[test]
    #[available_gas(300000)]
    fn test_total_quantity() {
        let player = contract_address_const::<0x5>();
        let bag = Bag {
            bag_id: 5,
            player,
            quantity: 7,
        };

        assert_eq!(BagActionsImpl::total_quantity(@bag), 7, "Total quantity should match");
    }
}
