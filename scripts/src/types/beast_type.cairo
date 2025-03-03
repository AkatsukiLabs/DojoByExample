use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug, PartialEq)]
pub enum BeastType {
    Fire,
    Water,
    Earth,
    Electric,
    Dragon,
    Ice,
    Magic,
    Rock,
    Undefined,
}

impl IntoBeastTypeFelt252 of Into<BeastType, felt252> {
    fn into(self: BeastType) -> felt252 {
        match self {
            BeastType::Fire => 1,
            BeastType::Water => 2,
            BeastType::Earth => 3,
            BeastType::Electric => 4,
            BeastType::Dragon => 5,
            BeastType::Ice => 6,
            BeastType::Magic => 7,
            BeastType::Rock => 8,
        }
    }
}

impl IntoBeastTypeU8 of Into<BeastType, u8> {
    fn into(self: BeastType) -> u8 {
        match self {
            BeastType::Fire => 1_u8,
            BeastType::Water => 2_u8,
            BeastType::Earth => 3_u8,
            BeastType::Electric => 4_u8,
            BeastType::Dragon => 5_u8,
            BeastType::Ice => 6_u8,
            BeastType::Magic => 7_u8,
            BeastType::Rock => 8_u8,
        }
    }
}

impl IntoU8BeastType of Into<u8, BeastType> {
    fn into(self: u8) -> BeastType {
        match self {
            1_u8 => BeastType::Fire,
            2_u8 => BeastType::Water,
            3_u8 => BeastType::Earth,
            4_u8 => BeastType::Electric,
            5_u8 => BeastType::Dragon,
            6_u8 => BeastType::Ice,
            7_u8 => BeastType::Magic,
            8_u8 => BeastType::Rock,
            _ => BeastType::Undefined,
        }
    }
}
