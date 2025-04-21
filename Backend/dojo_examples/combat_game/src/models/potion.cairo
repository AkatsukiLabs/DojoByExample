#[derive(Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
struct Potion {
    #[key]
    id: u64,
    name: felt252,
    effect: u8,
    rarity: u8,
    power: u32,
}


#[generate_trait]
pub impl PotionImpl of PotionTrait {
    fn new_potion(potion_id: u64) -> Potion {
        Potion {
            id: potion_id,
            name: 'Potion',
            effect: 0,
            rarity: 0,
            power: 0,
        }
    }
}


#[cfg(test)]
mod tests {
    use super::Potion;

    #[test]
    #[available_gas(300000)]
    fn test_basic_initialization() {
        let id = 1;

        let potion = Potion {
            id: 1,
            name: 'Murder',
            effect: 0,
            rarity: 0,
            power: 10,
        };

        assert_eq!(potion.id, id, "Potion ID should match");
        assert_eq!(potion.name, 'Murder', "Potion name should be Murder");
        assert_eq!(potion.power, 10, "Power should be 10");
    }
}
