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
            BeastType::Fire => 'Fire',
            BeastType::Water => 'Water',
            BeastType::Earth => 'Earth',
            BeastType::Electric => 'Electric',
            BeastType::Dragon => 'Dragon',
            BeastType::Ice => 'Ice',
            BeastType::Magic => 'Magic',
            BeastType::Rock => 'Rock',
            BeastType::Undefined => 'Undefined',
        }
    }
}

impl IntoBeastTypeU8 of Into<BeastType, u8> {
    fn into(self: BeastType) -> u8 {
        match self {
            BeastType::Fire => 0,
            BeastType::Water => 1,
            BeastType::Earth => 2,
            BeastType::Electric => 3,
            BeastType::Dragon => 4,
            BeastType::Ice => 5,
            BeastType::Magic => 6,
            BeastType::Rock => 7,
            BeastType::Undefined => 8,
        }
    }
}

impl IntoU8BeastType of Into<u8, BeastType> {
    fn into(self: u8) -> BeastType {
        match self {
            0 => BeastType::Fire,
            1 => BeastType::Water,
            2 => BeastType::Earth,
            3 => BeastType::Electric,
            4 => BeastType::Dragon,
            5 => BeastType::Ice,
            6 => BeastType::Magic,
            7 => BeastType::Rock,
            _ => BeastType::Undefined,
        }
    }
}
