use core::num::traits::{SaturatingAdd, SaturatingMul};
use starknet::ContractAddress;
use crate::constants::{
    BASE_LEVEL_BONUS, FAVORED_ATTACK_MULTIPLIER, NORMAL_ATTACK_MULTIPLIER, NORMAL_EFFECTIVENESS,
    NOT_VERY_EFFECTIVE, SUPER_EFFECTIVE,
};
use crate::models::skill::SkillTrait;
use crate::types::skill::SkillType;
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

    fn is_favored_attack(self: @Beast, skill_type: SkillType) -> bool {
        match skill_type {
            SkillType::Beam | SkillType::Slash | SkillType::Pierce |
            SkillType::Wave => self.beast_type == @BeastType::Light,
            SkillType::Blast | SkillType::Freeze | SkillType::Burn |
            SkillType::Punch => self.beast_type == @BeastType::Magic,
            SkillType::Smash | SkillType::Crush | SkillType::Shock |
            SkillType::Kick => self.beast_type == @BeastType::Shadow,
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
        self: @Beast, target: BeastType, skill_type: SkillType, attack_factor: u16,
    ) -> (u16, bool, bool) {
        let effectiveness = Self::calculate_effectiveness(*self.beast_type, target);
        let is_favored = self.is_favored_attack(skill_type);
        let favored_multiplier = if is_favored {
            FAVORED_ATTACK_MULTIPLIER
        } else {
            NORMAL_ATTACK_MULTIPLIER
        };
        let base_damage = SkillTrait::base_damage(skill_type);
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

        assert_eq!(beast.is_favored_attack(SkillType::Beam), true, "Light - SkillType::Beam");
        assert_eq!(beast.is_favored_attack(SkillType::Slash), true, "Light - SkillType::Slash");
        assert_eq!(beast.is_favored_attack(SkillType::Pierce), true, "Light - SkillType::Pierce");
        assert_eq!(beast.is_favored_attack(SkillType::Wave), true, "Light - SkillType::Wave");
        assert_eq!(beast.is_favored_attack(SkillType::Blast), false, "Light - SkillType::Blast");
        assert_eq!(beast.is_favored_attack(SkillType::Freeze), false, "Light - SkillType::Freeze");
        assert_eq!(beast.is_favored_attack(SkillType::Burn), false, "Light - SkillType::Burn");
        assert_eq!(beast.is_favored_attack(SkillType::Smash), false, "Light - SkillType::Smash");
        assert_eq!(beast.is_favored_attack(SkillType::Punch), false, "Light - SkillType::Punch");
        assert_eq!(beast.is_favored_attack(SkillType::Crush), false, "Light - SkillType::Crush");
        assert_eq!(beast.is_favored_attack(SkillType::Shock), false, "Light - SkillType::Shock");
        assert_eq!(beast.is_favored_attack(SkillType::Kick), false, "Light - SkillType::Kick");

        beast.beast_type = BeastType::Magic;
        assert_eq!(beast.is_favored_attack(SkillType::Beam), false, "Magic - SkillType::Beam");
        assert_eq!(beast.is_favored_attack(SkillType::Slash), false, "Magic - SkillType::Slash");
        assert_eq!(beast.is_favored_attack(SkillType::Pierce), false, "Magic - SkillType::Pierce");
        assert_eq!(beast.is_favored_attack(SkillType::Wave), false, "Magic - SkillType::Wave");
        assert_eq!(beast.is_favored_attack(SkillType::Blast), true, "Magic - SkillType::Blast");
        assert_eq!(beast.is_favored_attack(SkillType::Freeze), true, "Magic - SkillType::Freeze");
        assert_eq!(beast.is_favored_attack(SkillType::Burn), true, "Magic - SkillType::Burn");
        assert_eq!(beast.is_favored_attack(SkillType::Smash), false, "Magic - SkillType::Smash");
        assert_eq!(beast.is_favored_attack(SkillType::Punch), true, "Magic - SkillType::Punch");
        assert_eq!(beast.is_favored_attack(SkillType::Crush), false, "Magic - SkillType::Crush");
        assert_eq!(beast.is_favored_attack(SkillType::Shock), false, "Magic - SkillType::Shock");
        assert_eq!(beast.is_favored_attack(SkillType::Kick), false, "Magic - SkillType::Kick");

        beast.beast_type = BeastType::Shadow;
        assert_eq!(beast.is_favored_attack(SkillType::Beam), false, "Shadow - SkillType::Beam");
        assert_eq!(beast.is_favored_attack(SkillType::Slash), false, "Shadow - SkillType::Slash");
        assert_eq!(beast.is_favored_attack(SkillType::Pierce), false, "Shadow - SkillType::Pierce");
        assert_eq!(beast.is_favored_attack(SkillType::Wave), false, "Shadow - SkillType::Wave");
        assert_eq!(beast.is_favored_attack(SkillType::Blast), false, "Shadow - SkillType::Blast");
        assert_eq!(beast.is_favored_attack(SkillType::Freeze), false, "Shadow - SkillType::Freeze");
        assert_eq!(beast.is_favored_attack(SkillType::Burn), false, "Shadow - SkillType::Burn");
        assert_eq!(beast.is_favored_attack(SkillType::Smash), true, "Shadow - SkillType::Smash");
        assert_eq!(beast.is_favored_attack(SkillType::Punch), false, "Shadow - SkillType::Punch");
        assert_eq!(beast.is_favored_attack(SkillType::Crush), true, "Shadow - SkillType::Crush");
        assert_eq!(beast.is_favored_attack(SkillType::Shock), true, "Shadow - SkillType::Shock");
        assert_eq!(beast.is_favored_attack(SkillType::Kick), true, "Shadow - SkillType::Kick");
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

        // (attackerType, defenderType, attackerLevel, SkillType, attackFactor, expectedResult)
        let dataset = [
            (
                BeastType::Light,
                BeastType::Light,
                1_u8,
                SkillType::Blast,
                100_u16,
                (61_u16, false, false),
            ),
            (
                BeastType::Light,
                BeastType::Magic,
                1_u8,
                SkillType::Blast,
                100_u16,
                (30_u16, false, false),
            ),
            (
                BeastType::Light,
                BeastType::Shadow,
                1_u8,
                SkillType::Blast,
                100_u16,
                (91_u16, false, true),
            ),
            (
                BeastType::Light,
                BeastType::Light,
                1_u8,
                SkillType::Beam,
                100_u16,
                (67_u16, true, false),
            ),
            (
                BeastType::Light,
                BeastType::Light,
                1_u8,
                SkillType::Blast,
                200_u16,
                (111_u16, false, false),
            ),
            (
                BeastType::Light,
                BeastType::Shadow,
                5_u8,
                SkillType::Beam,
                300_u16,
                (270_u16, true, true),
            ),
        ]
            .span();

        for (
            attackerType,
            defenderType,
            attackerLevel,
            SkillType,
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
                .attack(*defenderType, *SkillType, *attackFactor);

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
