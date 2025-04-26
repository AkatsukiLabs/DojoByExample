use core::num::traits::SaturatingAdd;

// rarity is a value from 0 to 255, where:
// * 0 means "extremely rare"
// * 255 means "extremely common"
//
// This threshold is used to know where a potion could
// be considered as "rare".
const RARITY_THRESHOLD: u8 = 16;

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
            rarity: 255,
            power: 0,
        }
    }

    fn use_potion(self: @Potion, target_hp: u32) -> u32 {
        target_hp.saturating_add(*self.power)
    }

    fn is_rare(self: @Potion) -> bool {
        *self.rarity <= RARITY_THRESHOLD
    }

    fn describe(self: @Potion) -> ByteArray {
        format!("{} (E: {}, P: {}, R: {})", self.name, self.effect, self.power, self.rarity)
    }
}

#[cfg(test)]
mod tests {
    use super::{Potion, PotionTrait, RARITY_THRESHOLD};
    use core::num::traits::Bounded;


    #[test]
    #[available_gas(300000)]
    fn test_basic_initialization() {
        let id = 1;

        let potion = Potion {
            id: 1,
            name: 'Murder',
            effect: 0,
            rarity: 255,
            power: 10,
        };

        assert_eq!(potion.id, id, "Potion ID should match");
        assert_eq!(potion.name, 'Murder', "Potion name should be Murder");
        assert_eq!(potion.power, 10, "Power should be 10");
    }

    #[test]
    fn test_use_potion() {
        let mut potion = PotionTrait::new_potion(1);
        potion.power = 25;

        assert_eq!(potion.use_potion(100), 125, "Potion's power should be applied");
        assert_eq!(potion.use_potion(Bounded::<u32>::MAX - 1_u32), Bounded::<u32>::MAX, "Should not exceed max HP");
    }

    #[test]
    fn test_is_rare() {
        let mut potion = PotionTrait::new_potion(1);
        
        potion.rarity = RARITY_THRESHOLD;
        assert_eq!(potion.is_rare(), true, "Should be rare (rarity: {})", potion.rarity);

        potion.rarity = RARITY_THRESHOLD - 1;
        assert_eq!(potion.is_rare(), true, "Should be rare (rarity: {})", potion.rarity);

        potion.rarity = RARITY_THRESHOLD + 1;
        assert_eq!(potion.is_rare(), false, "Should NOT be rare (rarity: {})", potion.rarity);
    }

    #[test]
    fn test_describe() {
        let potion = Potion {
            id: 1,
            name: 'blueberry',
            effect: 1,
            rarity: 48,
            power: 12
        };

        assert_eq!(potion.describe(), format!("{} (E: 1, P: 12, R: 48)", 'blueberry'));

        let potion = Potion {
            id: 2,
            name: 'ancestral potion',
            effect: 4,
            rarity: 8,
            power: 1200
        };

        assert_eq!(potion.describe(), format!("{} (E: 4, P: 1200, R: 8)", 'ancestral potion'));
    }
}
