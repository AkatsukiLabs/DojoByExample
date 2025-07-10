#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum BeastType {
    Light,
    Magic,
    Shadow,
}

pub impl IntoBeastTypeFelt252 of Into<BeastType, felt252> {
    #[inline(always)]
    fn into(self: BeastType) -> felt252 {
        match self {
            BeastType::Light => 0,
            BeastType::Magic => 1,
            BeastType::Shadow => 2,
        }
    }
}

pub impl IntoBeastTypeU8 of Into<BeastType, u8> {
    #[inline(always)]
    fn into(self: BeastType) -> u8 {
        match self {
            BeastType::Light => 0,
            BeastType::Magic => 1,
            BeastType::Shadow => 2,
        }
    }
}

pub impl Intou8BeastType of Into<u8, BeastType> {
    #[inline(always)]
    fn into(self: u8) -> BeastType {
        let beast_type: u8 = self.into();
        match beast_type {
            0 => BeastType::Light,
            1 => BeastType::Magic,
            2 => BeastType::Shadow,
            _ => BeastType::Light, // Default fallback
        }
    }
}

pub impl BeastTypeDisplay of core::fmt::Display<BeastType> {
    fn fmt(self: @BeastType, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            BeastType::Light => "Light",
            BeastType::Magic => "Magic",
            BeastType::Shadow => "Shadow",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::BeastType;

    #[test]
    fn test_into_beast_type_light() {
        let beast_type = BeastType::Light;
        let beast_type_felt252: felt252 = beast_type.into();
        assert_eq!(beast_type_felt252, 0);
    }

    #[test]
    fn test_into_beast_type_magic() {
        let beast_type = BeastType::Magic;
        let beast_type_felt252: felt252 = beast_type.into();
        assert_eq!(beast_type_felt252, 1);
    }

    #[test]
    fn test_into_beast_type_shadow() {
        let beast_type = BeastType::Shadow;
        let beast_type_felt252: felt252 = beast_type.into();
        assert_eq!(beast_type_felt252, 2);
    }

    #[test]
    fn test_into_beast_type_u8_light() {
        let beast_type = BeastType::Light;
        let beast_type_u8: u8 = beast_type.into();
        assert_eq!(beast_type_u8, 0);
    }

    #[test]
    fn test_into_beast_type_u8_magic() {
        let beast_type = BeastType::Magic;
        let beast_type_u8: u8 = beast_type.into();
        assert_eq!(beast_type_u8, 1);
    }

    #[test]
    fn test_into_beast_type_u8_shadow() {
        let beast_type = BeastType::Shadow;
        let beast_type_u8: u8 = beast_type.into();
        assert_eq!(beast_type_u8, 2);
    }

    #[test]
    fn test_into_beast_type_from_u8_light() {
        let beast_type_u8: u8 = 0;
        let beast_type: BeastType = beast_type_u8.into();
        assert_eq!(beast_type, BeastType::Light);
    }

    #[test]
    fn test_into_beast_type_from_u8_magic() {
        let beast_type_u8: u8 = 1;
        let beast_type: BeastType = beast_type_u8.into();
        assert_eq!(beast_type, BeastType::Magic);
    }

    #[test]
    fn test_into_beast_type_from_u8_shadow() {
        let beast_type_u8: u8 = 2;
        let beast_type: BeastType = beast_type_u8.into();
        assert_eq!(beast_type, BeastType::Shadow);
    }

    #[test]
    fn test_into_beast_type_from_u8_invalid() {
        let beast_type_u8: u8 = 3;
        let beast_type: BeastType = beast_type_u8.into();
        assert_eq!(beast_type, BeastType::Light); // Default fallback
    }

    #[test]
    fn test_into_beast_type_from_u8_255_edge_case() {
        let beast_type_u8: u8 = 255;
        let beast_type: BeastType = beast_type_u8.into();
        assert_eq!(beast_type, BeastType::Light); // Default fallback
    }

    #[test]
    fn test_beast_type_display_light() {
        let beast_type = BeastType::Light;
        let display_string = format!("{}", beast_type);
        assert_eq!(display_string, "Light");
    }

    #[test]
    fn test_beast_type_display_magic() {
        let beast_type = BeastType::Magic;
        let display_string = format!("{}", beast_type);
        assert_eq!(display_string, "Magic");
    }

    #[test]
    fn test_beast_type_display_shadow() {
        let beast_type = BeastType::Shadow;
        let display_string = format!("{}", beast_type);
        assert_eq!(display_string, "Shadow");
    }
}