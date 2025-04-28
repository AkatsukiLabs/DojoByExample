use core::num::traits::SaturatingAdd;
use crate::types::rarity::{Rarity, RarityTrait};
use crate::utils::string::stringify;

#[derive(Drop, Serde, IntrospectPacked, Debug)]
#[dojo::model]
struct Potion {
    #[key]
    id: u64,
    name: felt252,
    effect: u8,
    rarity: Rarity,
    power: u32,
}

#[generate_trait]
pub impl PotionImpl of PotionTrait {
    fn new_potion(potion_id: u64) -> Potion {

        Potion { id: potion_id, name: 'Potion', effect: 0, rarity: Rarity::Basic, power: 0 }
    }

    fn use_potion(self: @Potion, target_hp: u32) -> u32 {
        target_hp.saturating_add(*self.power)
    }

    fn is_rare(self: @Potion) -> bool {
        self.rarity.is_rare()
    }

    fn describe(self: @Potion) -> ByteArray {
        format!(
            "{} (Effect: {}, Power: {}, Rarity: {})",
            stringify(*self.name),
            self.effect,
            self.power,
            self.rarity,
        )
    }
}

#[cfg(test)]
mod tests {
    use super::{Potion, PotionTrait};
    use crate::types::rarity::Rarity;
    use core::num::traits::Bounded;

    #[test]
    #[available_gas(300000)]
    fn test_basic_initialization() {
        let id = 1;

  
        let potion = Potion { id: 1, name: 'Murder', effect: 0, rarity: Rarity::Basic, power: 10 };


        assert_eq!(potion.id, id, "Potion ID should match");
        assert_eq!(potion.name, 'Murder', "Potion name should be Murder");
        assert_eq!(potion.power, 10, "Power should be 10");
    }

    #[test]
    fn test_use_potion() {
        let mut potion = PotionTrait::new_potion(1);
        potion.power = 25;

        assert_eq!(potion.use_potion(100), 125, "Potion's power should be applied");
        assert_eq!(
            potion.use_potion(Bounded::<u32>::MAX - 1_u32),
            Bounded::<u32>::MAX,
            "Should not exceed max HP",
        );
    }

    #[test]
    fn test_is_rare() {
        let mut potion = PotionTrait::new_potion(1);

        potion.rarity = Rarity::VeryRare;
        assert_eq!(potion.is_rare(), true, "VeryRare should return true");

        potion.rarity = Rarity::Rare;
        assert_eq!(potion.is_rare(), true, "Rare should return true");

        potion.rarity = Rarity::Uncommon;
        assert_eq!(potion.is_rare(), false, "Uncommon should return false");
    }

    #[test]
    fn test_describe() {
        let potion = Potion {
            id: 1, name: 'blueberry', effect: 1, rarity: Rarity::Basic, power: 12,
        };

        assert_eq!(potion.describe(), format!("blueberry (Effect: 1, Power: 12, Rarity: Basic)"));

        let potion = Potion {
            id: 2, name: 'ancestral potion', effect: 4, rarity: Rarity::VeryRare, power: 1200,
        };

        assert_eq!(
            potion.describe(),
            format!("ancestral potion (Effect: 4, Power: 1200, Rarity: Very Rare)"),
        );
    }
}
