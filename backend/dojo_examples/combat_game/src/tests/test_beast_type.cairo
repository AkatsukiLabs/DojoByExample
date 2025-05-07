#[cfg(test)]
mod tests {
    use super::BeastType;
    use core::convert::Into;
    use starknet::testing::assert_eq;

    #[test]
    fn test_beast_type_into_felt252() {
        assert_eq!(Into::<felt252>::into(BeastType::Fire), 'Fire');
        assert_eq!(Into::<felt252>::into(BeastType::Water), 'Water');
        assert_eq!(Into::<felt252>::into(BeastType::Earth), 'Earth');
        assert_eq!(Into::<felt252>::into(BeastType::Electric), 'Electric');
        assert_eq!(Into::<felt252>::into(BeastType::Dragon), 'Dragon');
        assert_eq!(Into::<felt252>::into(BeastType::Ice), 'Ice');
        assert_eq!(Into::<felt252>::into(BeastType::Magic), 'Magic');
        assert_eq!(Into::<felt252>::into(BeastType::Rock), 'Rock');
        assert_eq!(Into::<felt252>::into(BeastType::Undefined), 'Undefined');
    }

    #[test]
    fn test_beast_type_into_u8() {
        assert_eq!(Into::<u8>::into(BeastType::Fire), 0_u8);
        assert_eq!(Into::<u8>::into(BeastType::Water), 1_u8);
        assert_eq!(Into::<u8>::into(BeastType::Earth), 2_u8);
        assert_eq!(Into::<u8>::into(BeastType::Electric), 3_u8);
        assert_eq!(Into::<u8>::into(BeastType::Dragon), 4_u8);
        assert_eq!(Into::<u8>::into(BeastType::Ice), 5_u8);
        assert_eq!(Into::<u8>::into(BeastType::Magic), 6_u8);
        assert_eq!(Into::<u8>::into(BeastType::Rock), 7_u8);
        assert_eq!(Into::<u8>::into(BeastType::Undefined), 8_u8);
    }

    #[test]
    fn test_u8_into_beast_type_valid() {
        assert_eq!(Into::<BeastType>::into(0_u8), BeastType::Fire);
        assert_eq!(Into::<BeastType>::into(1_u8), BeastType::Water);
        assert_eq!(Into::<BeastType>::into(2_u8), BeastType::Earth);
        assert_eq!(Into::<BeastType>::into(3_u8), BeastType::Electric);
        assert_eq!(Into::<BeastType>::into(4_u8), BeastType::Dragon);
        assert_eq!(Into::<BeastType>::into(5_u8), BeastType::Ice);
        assert_eq!(Into::<BeastType>::into(6_u8), BeastType::Magic);
        assert_eq!(Into::<BeastType>::into(7_u8), BeastType::Rock);
    }

    #[test]
    fn test_u8_into_beast_type_invalid() {
        assert_eq!(Into::<BeastType>::into(8_u8), BeastType::Undefined);
        assert_eq!(Into::<BeastType>::into(9_u8), BeastType::Undefined);
        assert_eq!(Into::<BeastType>::into(255_u8), BeastType::Undefined);
        assert_eq!(Into::<BeastType>::into(100_u8), BeastType::Undefined);
    }

    #[test]
    fn test_edge_cases() {
        assert_eq!(Into::<BeastType>::into(0_u8), BeastType::Fire);
        assert_eq!(Into::<BeastType>::into(255_u8), BeastType::Undefined);
    }
}
