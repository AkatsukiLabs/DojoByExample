use starknet::ContractAddress;

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
    fn into(self: FoodType) -> felt252 {
        match self {
            FoodType::Apple => 1,
            FoodType::Bread => 2,
            FoodType::Meat => 3,
            FoodType::Fish => 4,
            FoodType::Potion => 5,
            _ => 0, 
        }
    }
}

impl IntoFoodTypeU8 of Into<FoodType, u8> {
    fn into(self: FoodType) -> u8 {
        match self {
            FoodType::Apple => 1_u8,
            FoodType::Bread => 2_u8,
            FoodType::Meat => 3_u8,
            FoodType::Fish => 4_u8,
            FoodType::Potion => 5_u8,
            _ => 0_u8, 
        }
    }
}

impl IntoU8FoodType of Into<u8, FoodType> {
    fn into(self: u8) -> FoodType {
        match self {
            1_u8 => FoodType::Apple,
            2_u8 => FoodType::Bread,
            3_u8 => FoodType::Meat,
            4_u8 => FoodType::Fish,
            5_u8 => FoodType::Potion,
            _ => FoodType::Undefined, 
        }
    }
}