#[derive(Copy, Drop, Serde, Debug, PartialEq)]
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

#[cfg(test)]
mod tests {
    use super::BeastType;

    #[test]
    fn test_beast_type_to_u8() {
        assert_eq(BeastType::Fire.into(), 0);
        assert_eq(BeastType::Water.into(), 1);
        assert_eq(BeastType::Earth.into(), 2);
        assert_eq(BeastType::Electric.into(), 3);
        assert_eq(BeastType::Dragon.into(), 4);
        assert_eq(BeastType::Ice.into(), 5);
        assert_eq(BeastType::Magic.into(), 6);
        assert_eq(BeastType::Rock.into(), 7);
        assert_eq(BeastType::Undefined.into(), 8);
    }

    #[test]
    fn test_u8_to_beast_type_valid() {
        assert_eq(u8::into(0), BeastType::Fire);
        assert_eq(u8::into(1), BeastType::Water);
        assert_eq(u8::into(2), BeastType::Earth);
        assert_eq(u8::into(3), BeastType::Electric);
        assert_eq(u8::into(4), BeastType::Dragon);
        assert_eq(u8::into(5), BeastType::Ice);
        assert_eq(u8::into(6), BeastType::Magic);
        assert_eq(u8::into(7), BeastType::Rock);
        assert_eq(u8::into(8), BeastType::Undefined);
    }

    #[test]
    fn test_u8_to_beast_type_invalid() {
        assert_eq(u8::into(9), BeastType::Undefined);
        assert_eq(u8::into(255), BeastType::Undefined);
        assert_eq(u8::into(42), BeastType::Undefined);
    }

    #[test]
    fn test_beast_type_to_felt252() {
        assert_eq(BeastType::Fire.into(), str_to_felt252("Fire"));
        assert_eq(BeastType::Water.into(), str_to_felt252("Water"));
        assert_eq(BeastType::Earth.into(), str_to_felt252("Earth"));
        assert_eq(BeastType::Electric.into(), str_to_felt252("Electric"));
        assert_eq(BeastType::Dragon.into(), str_to_felt252("Dragon"));
        assert_eq(BeastType::Ice.into(), str_to_felt252("Ice"));
        assert_eq(BeastType::Magic.into(), str_to_felt252("Magic"));
        assert_eq(BeastType::Rock.into(), str_to_felt252("Rock"));
        assert_eq(BeastType::Undefined.into(), str_to_felt252("Undefined"));
    }

    #[test]
    fn test_bidirectional_mapping() {
        let all_variants: Array<(BeastType, u8)> = array![
            (BeastType::Fire, 0),
            (BeastType::Water, 1),
            (BeastType::Earth, 2),
            (BeastType::Electric, 3),
            (BeastType::Dragon, 4),
            (BeastType::Ice, 5),
            (BeastType::Magic, 6),
            (BeastType::Rock, 7),
            (BeastType::Undefined, 8),
        ];

        for (variant, number) in all_variants.iter() {
            let to_u8 = variant.into();
            let from_u8 = u8::into(to_u8);
            assert_eq(to_u8, number);
            assert_eq(from_u8, variant);
        }
    }
}
