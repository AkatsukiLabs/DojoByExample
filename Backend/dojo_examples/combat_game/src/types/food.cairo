#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
pub enum FoodType {
    Apple,
    Bread,
    Meat,
    Fish,
    Potion,
    Undefined,
}

impl IntoFoodTypeFelt252 of Into<FoodType, felt252> {
    #[inline(always)]
    fn into(self: FoodType) -> felt252 {
        match self {
            FoodType::Undefined => 0,
            FoodType::Apple => 1,
            FoodType::Bread => 2,
            FoodType::Meat => 3,
            FoodType::Fish => 4,
            FoodType::Potion => 5,
        }
    }
}

impl IntoFoodTypeU8 of Into<FoodType, u8> {
    #[inline(always)]
    fn into(self: FoodType) -> u8 {
        match self {
            FoodType::Undefined => 0,
            FoodType::Apple => 1,
            FoodType::Bread => 2,
            FoodType::Meat => 3,
            FoodType::Fish => 4,
            FoodType::Potion => 5,
        }
    }
}

impl IntoU8FoodType of Into<u8, FoodType> {
    #[inline(always)]
    fn into(self: u8) -> FoodType {
        let food_type: u8 = self.into();
        match food_type {
            0 => FoodType::Undefined,
            1 => FoodType::Apple,
            2 => FoodType::Bread,
            3 => FoodType::Meat,
            4 => FoodType::Fish,
            5 => FoodType::Potion,
            _ => FoodType::Undefined,
        }
    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[available_gas(1000000)]
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

    #[test]
    #[available_gas(1000000)]
    fn test_food_type_into_felt252() {
        assert_eq!(FoodType::Apple.into(), 1);
        assert_eq!(FoodType::Bread.into(), 2);
        assert_eq!(FoodType::Meat.into(), 3);
        assert_eq!(FoodType::Fish.into(), 4);
        assert_eq!(FoodType::Potion.into(), 5);
        assert_eq!(FoodType::Undefined.into(), 0);
    }

    #[test]
    #[available_gas(1000000)]
    fn test_food_type_into_u8() {
        assert_eq!(FoodType::Apple.into(), 1_u8);
        assert_eq!(FoodType::Bread.into(), 2_u8);
        assert_eq!(FoodType::Meat.into(), 3_u8);
        assert_eq!(FoodType::Fish.into(), 4_u8);
        assert_eq!(FoodType::Potion.into(), 5_u8);
        assert_eq!(FoodType::Undefined.into(), 0_u8);
    }

    #[test]
    #[available_gas(1000000)]
    fn test_u8_into_food_type() {
        assert_eq!(1_u8.into(), FoodType::Apple);
        assert_eq!(2_u8.into(), FoodType::Bread);
        assert_eq!(3_u8.into(), FoodType::Meat);
        assert_eq!(4_u8.into(), FoodType::Fish);
        assert_eq!(5_u8.into(), FoodType::Potion);
        assert_eq!(0_u8.into(), FoodType::Undefined);
        assert_eq!(99_u8.into(), FoodType::Undefined); // Edge case for unknown values
    }
}