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
            AttackType::Beam | AttackType::Slash |
            AttackType::Pierce => self.beast_type == @BeastType::Light,
            AttackType::Blast | AttackType::Freeze |
            AttackType::Burn => self.beast_type == @BeastType::Magic,
            AttackType::Smash | AttackType::Crush |
            AttackType::Shock => self.beast_type == @BeastType::Shadow,
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

        let damage = (base_damage.saturating_mul(attack_factor) / 100).saturating_add(level_bonus.into());
        let damage = damage.saturating_mul(favored_multiplier.into()) / 100;
        let damage = damage.saturating_mul(effectiveness.into()) / 100;

        (damage, is_favored, effectiveness == SUPER_EFFECTIVE)
    }
}
