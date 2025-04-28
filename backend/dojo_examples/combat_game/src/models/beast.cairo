use core::num::traits::{SaturatingAdd, SaturatingMul};
use starknet::ContractAddress;
use crate::constants::{
    BASE_LEVEL_BONUS, FAVORED_ATTACK_MULTIPLIER, NORMAL_ATTACK_MULTIPLIER, NORMAL_EFFECTIVENESS,
    NOT_VERY_EFFECTIVE, SUPER_EFFECTIVE,
};
use crate::types::attack_type::{AttackType, AttackTypeTrait};
use crate::types::beast_type::BeastType;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub beast_id: u16,
    pub level: u8,
    pub experience: u16,
    pub beast_type: BeastType,
}

#[generate_trait]
pub impl BeastImpl of BeastTrait {
    fn new(player: ContractAddress, beast_id: u16, beast_type: BeastType) -> Beast {
        Beast { player, beast_id, level: 0, experience: 0, beast_type }
    }

    fn is_favored_attack(self: @Beast, attack_type: AttackType) -> bool {
        match attack_type {
            AttackType::Beam | AttackType::Slash | AttackType::Pierce |
            AttackType::Wave => self.beast_type == @BeastType::Light,
            AttackType::Blast | AttackType::Freeze | AttackType::Burn |
            AttackType::Punch => self.beast_type == @BeastType::Magic,
            AttackType::Smash | AttackType::Crush | AttackType::Shock |
            AttackType::Kick => self.beast_type == @BeastType::Shadow,
            _ => false,
        }
    }

    fn calculate_effectiveness(attacker_type: BeastType, defender_type: BeastType) -> u8 {
        match (attacker_type, defender_type) {
            (BeastType::Light, BeastType::Shadow) | (BeastType::Magic, BeastType::Light) |
            (BeastType::Shadow, BeastType::Magic) => SUPER_EFFECTIVE,
            (BeastType::Light, BeastType::Magic) | (BeastType::Magic, BeastType::Shadow) |
            (BeastType::Shadow, BeastType::Light) => NOT_VERY_EFFECTIVE,
            _ => NORMAL_EFFECTIVENESS,
        }
    }

    fn attack(
        self: @Beast, target: BeastType, attack_type: AttackType, attack_factor: u16,
    ) -> (u16, bool, bool) {
        let effectiveness = Self::calculate_effectiveness(*self.beast_type, target);
        let is_favored = self.is_favored_attack(attack_type);
        let favored_multiplier = if is_favored {
            FAVORED_ATTACK_MULTIPLIER
        } else {
            NORMAL_ATTACK_MULTIPLIER
        };
        let base_damage = attack_type.base_damage();
        let level_bonus = BASE_LEVEL_BONUS.saturating_add(*self.level);

        let damage = (base_damage.saturating_mul(attack_factor) / 100)
            .saturating_add(level_bonus.into());
        let damage = damage.saturating_mul(favored_multiplier.into()) / 100;
        let damage = damage.saturating_mul(effectiveness.into()) / 100;

        (damage, is_favored, effectiveness == SUPER_EFFECTIVE)
    }
}

#[cfg(test)]
mod tests {
    use starknet::contract_address::contract_address_const;
    use super::*;

    #[test]
    fn test_new() {
        let player = contract_address_const::<'bob'>();

        assert_eq!(
            BeastTrait::new(player, 123, BeastType::Shadow),
            Beast { player, beast_id: 123, level: 0, experience: 0, beast_type: BeastType::Shadow },
            "Bad new() function",
        );
    }

    #[test]
    fn test_favored_attack() {
        let mut beast = BeastTrait::new(contract_address_const::<'bob'>(), 123, BeastType::Light);

        assert_eq!(beast.is_favored_attack(AttackType::Beam), true, "Light - AttackType::Beam");
        assert_eq!(beast.is_favored_attack(AttackType::Slash), true, "Light - AttackType::Slash");
        assert_eq!(beast.is_favored_attack(AttackType::Pierce), true, "Light - AttackType::Pierce");
        assert_eq!(beast.is_favored_attack(AttackType::Wave), true, "Light - AttackType::Wave");
        assert_eq!(beast.is_favored_attack(AttackType::Blast), false, "Light - AttackType::Blast");
        assert_eq!(
            beast.is_favored_attack(AttackType::Freeze), false, "Light - AttackType::Freeze",
        );
        assert_eq!(beast.is_favored_attack(AttackType::Burn), false, "Light - AttackType::Burn");
        assert_eq!(beast.is_favored_attack(AttackType::Smash), false, "Light - AttackType::Smash");
        assert_eq!(beast.is_favored_attack(AttackType::Punch), false, "Light - AttackType::Punch");
        assert_eq!(beast.is_favored_attack(AttackType::Crush), false, "Light - AttackType::Crush");
        assert_eq!(beast.is_favored_attack(AttackType::Shock), false, "Light - AttackType::Shock");
        assert_eq!(beast.is_favored_attack(AttackType::Kick), false, "Light - AttackType::Kick");

        beast.beast_type = BeastType::Magic;
        assert_eq!(beast.is_favored_attack(AttackType::Beam), false, "Magic - AttackType::Beam");
        assert_eq!(beast.is_favored_attack(AttackType::Slash), false, "Magic - AttackType::Slash");
        assert_eq!(
            beast.is_favored_attack(AttackType::Pierce), false, "Magic - AttackType::Pierce",
        );
        assert_eq!(beast.is_favored_attack(AttackType::Wave), false, "Magic - AttackType::Wave");
        assert_eq!(beast.is_favored_attack(AttackType::Blast), true, "Magic - AttackType::Blast");
        assert_eq!(beast.is_favored_attack(AttackType::Freeze), true, "Magic - AttackType::Freeze");
        assert_eq!(beast.is_favored_attack(AttackType::Burn), true, "Magic - AttackType::Burn");
        assert_eq!(beast.is_favored_attack(AttackType::Smash), false, "Magic - AttackType::Smash");
        assert_eq!(beast.is_favored_attack(AttackType::Punch), true, "Magic - AttackType::Punch");
        assert_eq!(beast.is_favored_attack(AttackType::Crush), false, "Magic - AttackType::Crush");
        assert_eq!(beast.is_favored_attack(AttackType::Shock), false, "Magic - AttackType::Shock");
        assert_eq!(beast.is_favored_attack(AttackType::Kick), false, "Magic - AttackType::Kick");

        beast.beast_type = BeastType::Shadow;
        assert_eq!(beast.is_favored_attack(AttackType::Beam), false, "Shadow - AttackType::Beam");
        assert_eq!(beast.is_favored_attack(AttackType::Slash), false, "Shadow - AttackType::Slash");
        assert_eq!(
            beast.is_favored_attack(AttackType::Pierce), false, "Shadow - AttackType::Pierce",
        );
        assert_eq!(beast.is_favored_attack(AttackType::Wave), false, "Shadow - AttackType::Wave");
        assert_eq!(beast.is_favored_attack(AttackType::Blast), false, "Shadow - AttackType::Blast");
        assert_eq!(
            beast.is_favored_attack(AttackType::Freeze), false, "Shadow - AttackType::Freeze",
        );
        assert_eq!(beast.is_favored_attack(AttackType::Burn), false, "Shadow - AttackType::Burn");
        assert_eq!(beast.is_favored_attack(AttackType::Smash), true, "Shadow - AttackType::Smash");
        assert_eq!(beast.is_favored_attack(AttackType::Punch), false, "Shadow - AttackType::Punch");
        assert_eq!(beast.is_favored_attack(AttackType::Crush), true, "Shadow - AttackType::Crush");
        assert_eq!(beast.is_favored_attack(AttackType::Shock), true, "Shadow - AttackType::Shock");
        assert_eq!(beast.is_favored_attack(AttackType::Kick), true, "Shadow - AttackType::Kick");
    }

    #[test]
    fn test_calculate_effectiveness() {
        let dataset = [
            (BeastType::Light, BeastType::Light, NORMAL_EFFECTIVENESS),
            (BeastType::Light, BeastType::Magic, NOT_VERY_EFFECTIVE),
            (BeastType::Light, BeastType::Shadow, SUPER_EFFECTIVE),
            (BeastType::Magic, BeastType::Light, SUPER_EFFECTIVE),
            (BeastType::Magic, BeastType::Magic, NORMAL_EFFECTIVENESS),
            (BeastType::Magic, BeastType::Shadow, NOT_VERY_EFFECTIVE),
            (BeastType::Shadow, BeastType::Light, NOT_VERY_EFFECTIVE),
            (BeastType::Shadow, BeastType::Magic, SUPER_EFFECTIVE),
            (BeastType::Shadow, BeastType::Shadow, NORMAL_EFFECTIVENESS),
        ]
            .span();

        for (attacker, defender, expected) in dataset {
            assert_eq!(
                BeastTrait::calculate_effectiveness(*attacker, *defender),
                *expected,
                "Bad attacker: {} defender: {}",
                attacker,
                defender,
            );
        }
    }

    #[test]
    fn test_attack() {
        let player = contract_address_const::<'bob'>();

        // (attackerType, defenderType, attackerLevel, attackType, attackFactor, expectedResult)
        let dataset = [
            (
                BeastType::Light,
                BeastType::Light,
                1_u8,
                AttackType::Blast,
                100_u16,
                (61_u16, false, false),
            ),
            (
                BeastType::Light,
                BeastType::Magic,
                1_u8,
                AttackType::Blast,
                100_u16,
                (30_u16, false, false),
            ),
            (
                BeastType::Light,
                BeastType::Shadow,
                1_u8,
                AttackType::Blast,
                100_u16,
                (91_u16, false, true),
            ),
            (
                BeastType::Light,
                BeastType::Light,
                1_u8,
                AttackType::Beam,
                100_u16,
                (67_u16, true, false),
            ),
            (
                BeastType::Light,
                BeastType::Light,
                1_u8,
                AttackType::Blast,
                200_u16,
                (111_u16, false, false),
            ),
            (
                BeastType::Light,
                BeastType::Shadow,
                5_u8,
                AttackType::Beam,
                300_u16,
                (270_u16, true, true),
            ),
        ]
            .span();

        for (
            attackerType,
            defenderType,
            attackerLevel,
            attackType,
            attackFactor,
            (expectedDamage, expectedFavored, expectedEffectiveness),
        ) in dataset {
            let beast = Beast {
                player,
                beast_id: 1,
                level: *attackerLevel,
                experience: 0,
                beast_type: *attackerType,
            };
            let (damage, favored, effectiveness) = beast
                .attack(*defenderType, *attackType, *attackFactor);

            assert!(
                damage == *expectedDamage
                    && favored == *expectedFavored
                    && effectiveness == *expectedEffectiveness,
                "Expected: ({}, {}, {}) Got: ({}, {}, {})",
                expectedDamage,
                expectedFavored,
                expectedEffectiveness,
                damage,
                favored,
                effectiveness,
            );
        }
    }
}
