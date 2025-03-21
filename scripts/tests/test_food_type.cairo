#[cfg(test)]
mod tests {
    use super::*;

    #[cfg(test)]
    fn test_food_type_instantiation() {
        let apple = FoodType::Apple;
        let bread = FoodType::Bread;
        let meat = FoodType::Meat;
        let fish = FoodType::Fish;
        let potion = FoodType::Potion;
        let undefined = FoodType::Undefined;

        assert_eq!(apple, FoodType::Apple);
        assert_eq!(bread, FoodType::Bread);
        assert_eq!(meat, FoodType::Meat);
        assert_eq!(fish, FoodType::Fish);
        assert_eq!(potion, FoodType::Potion);
        assert_eq!(undefined, FoodType::Undefined);
    }

    #[cfg(test)]
    fn test_food_type_into_felt252() {
        assert_eq!(FoodType::Apple.into(), 1);
        assert_eq!(FoodType::Bread.into(), 2);
        assert_eq!(FoodType::Meat.into(), 3);
        assert_eq!(FoodType::Fish.into(), 4);
        assert_eq!(FoodType::Potion.into(), 5);
        assert_eq!(FoodType::Undefined.into(), 0);
    }

    #[cfg(test)]
    fn test_food_type_into_u8() {
        assert_eq!(FoodType::Apple.into(), 1_u8);
        assert_eq!(FoodType::Bread.into(), 2_u8);
        assert_eq!(FoodType::Meat.into(), 3_u8);
        assert_eq!(FoodType::Fish.into(), 4_u8);
        assert_eq!(FoodType::Potion.into(), 5_u8);
        assert_eq!(FoodType::Undefined.into(), 0_u8);
    }

    #[cfg(test)]
    fn test_u8_into_food_type() {
        assert_eq!(1_u8.into(), FoodType::Apple);
        assert_eq!(2_u8.into(), FoodType::Bread);
        assert_eq!(3_u8.into(), FoodType::Meat);
        assert_eq!(4_u8.into(), FoodType::Fish);
        assert_eq!(5_u8.into(), FoodType::Potion);
        assert_eq!(0_u8.into(), FoodType::Undefined);
        assert_eq!(99_u8.into(), FoodType::Undefined); 
    }
}
