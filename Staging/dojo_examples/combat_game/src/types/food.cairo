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