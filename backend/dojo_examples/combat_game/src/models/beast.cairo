use starknet::ContractAddress;
use crate::constants::{
    FAVORED_ATTACK_MULTIPLIER, NORMAL_ATTACK_MULTIPLIER, NORMAL_EFFECTIVENESS, NOT_VERY_EFFECTIVE,
    SUPER_EFFECTIVE,
};

#[derive(Introspect, Copy, Drop, Serde, Debug, PartialEq)]
pub enum ElementType {
    Light,
    Magic,
    Shadow,
}

#[derive(Introspect, Copy, Drop, Serde, Debug, PartialEq)]
pub enum AttackType {
    Beam,
    Slash,
    Pierce,
    Blast,
    Freeze,
    Burn,
    Smash,
    Crush,
    Shock,
}

#[generate_trait]
pub impl AttackTypeImpl of AttackTypeTrait {
    fn base_damage(self: @AttackType) -> u16 {
        match self {
            AttackType::Beam => 10,
            AttackType::Slash => 20,
            AttackType::Pierce => 30,
            AttackType::Blast => 10,
            AttackType::Freeze => 20,
            AttackType::Burn => 30,
            AttackType::Smash => 10,
            AttackType::Crush => 20,
            AttackType::Shock => 30,
        }
    }
}

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub beast_id: u16,
    pub level: u8,
    pub experience: u16,
    pub beast_type: ElementType,
}

#[generate_trait]
pub impl BeastImpl of BeastTrait {
    fn new(player: ContractAddress, beast_id: u16, beast_type: ElementType) -> Beast {
        Beast { player, beast_id, level: 0, experience: 0, beast_type }
    }

    fn is_favored_attack(attacker_type: ElementType, attack_type: AttackType) -> bool {
        match attack_type {
            AttackType::Beam | AttackType::Slash |
            AttackType::Pierce => attacker_type == ElementType::Light,
            AttackType::Blast | AttackType::Freeze |
            AttackType::Burn => attacker_type == ElementType::Magic,
            AttackType::Smash | AttackType::Crush |
            AttackType::Shock => attacker_type == ElementType::Shadow,
        }
    }

    fn calculate_effectiveness(attacker_type: ElementType, defender_type: ElementType) -> u8 {
        match (attacker_type, defender_type) {
            (ElementType::Light, ElementType::Shadow) | (ElementType::Magic, ElementType::Light) |
            (ElementType::Shadow, ElementType::Magic) => SUPER_EFFECTIVE,
            (ElementType::Light, ElementType::Magic) | (ElementType::Magic, ElementType::Shadow) |
            (ElementType::Shadow, ElementType::Light) => NOT_VERY_EFFECTIVE,
            _ => NORMAL_EFFECTIVENESS,
        }
    }

    fn calculate_damage(
        attacker_type: ElementType,
        attack_type: AttackType,
        attacker_stats: (u16, u16),
        defender_type: ElementType,
    ) -> (u16, bool, bool) {
        let is_favored = Self::is_favored_attack(attacker_type, attack_type);
        let favored_multiplier = if is_favored {
            FAVORED_ATTACK_MULTIPLIER
        } else {
            NORMAL_ATTACK_MULTIPLIER
        };
        let effectiveness = Self::calculate_effectiveness(attacker_type, defender_type);
        let (attack_factor, level_bonus) = attacker_stats;
        let base_damage = attack_type.base_damage();

        let damage: u16 = (base_damage * attack_factor / 100 + level_bonus)
            * favored_multiplier.into()
            * effectiveness.into();

        (damage, is_favored, effectiveness == SUPER_EFFECTIVE)
    }
}
