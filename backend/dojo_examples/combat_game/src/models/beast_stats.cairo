use crate::{
    types::{status_condition::StatusCondition, beast_type::BeastType},
    helpers::pseudo_random::PseudoRandom,
};
use core::{poseidon::poseidon_hash_span, num::traits::Bounded};

#[derive(Introspect, Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct BeastStats {
    #[key]
    pub beast_id: u16,
    pub max_hp: u16,
    pub current_hp: u16,
    pub attack: u16,
    pub defense: u16,
    pub speed: u16,
    pub status_condition: StatusCondition,
    pub last_timestamp: u64,
}

#[generate_trait]
pub impl BeastStatsActions of BeastStatsActionTrait {
    fn generate_random_beast_stat(beast_id: u16, attribute_id: u16, min: u8, max: u8) -> u16 {
        let mut salt: u256 = poseidon_hash_span(
            array![beast_id.into(), attribute_id.into(), starknet::get_block_timestamp().into()]
                .span(),
        )
            .into();
        // Secure that salt is between [0, 18446744073709551615]
        let salt_u16: u16 = (salt % Bounded::<u16>::MAX.into()).try_into().unwrap();
        PseudoRandom::generate_random_u8(beast_id, salt_u16, min, max).into()
    }

    fn new_beast_stats(
        beast_id: u16, beast_type: BeastType, level: u8, current_timestamp: u64,
    ) -> BeastStats {
        let random_max_hp = Self::generate_random_beast_stat(beast_id, 1, 50, 100);
        let mut beast_stats = BeastStats {
            beast_id,
            max_hp: random_max_hp,
            current_hp: random_max_hp,
            attack: Self::generate_random_beast_stat(beast_id, 2, 50, 100),
            defense: Self::generate_random_beast_stat(beast_id, 3, 50, 100),
            speed: Self::generate_random_beast_stat(beast_id, 4, 10, 50),
            status_condition: StatusCondition::None,
            last_timestamp: starknet::get_block_timestamp(),
        };

        // Light: (HP: 100%, ATK: 120%, DEF: 90%, SPD: 110%)
        // Magic: (HP: 90%, ATK: 130%, DEF: 80%, SPD: 120%)
        // Shadow: (HP: 120%, ATK: 100%, DEF: 120%, SPD: 80%)
        match beast_type {
            BeastType::Light => {
                beast_stats.attack += (beast_stats.attack * 20) / 100;
                beast_stats.defense -= (beast_stats.attack * 10) / 100;
                beast_stats.speed += (beast_stats.attack * 10) / 100;
            },
            BeastType::Magic => {
                beast_stats.max_hp -= (beast_stats.attack * 10) / 100;
                beast_stats.current_hp -= (beast_stats.attack * 10) / 100;
                beast_stats.attack += (beast_stats.attack * 30) / 100;
                beast_stats.defense -= (beast_stats.attack * 20) / 100;
                beast_stats.speed += (beast_stats.attack * 20) / 100;
            },
            BeastType::Shadow => {
                beast_stats.max_hp += (beast_stats.attack * 20) / 100;
                beast_stats.current_hp += (beast_stats.attack * 20) / 100;
                beast_stats.defense += (beast_stats.attack * 20) / 100;
                beast_stats.speed -= (beast_stats.attack * 20) / 100;
            },
        }

        beast_stats
    }

    fn take_damage(ref self: BeastStats, damage: u16) {
        self.current_hp = if self.current_hp < damage {
            0
        } else {
            self.current_hp - damage
        };
        self._update_timestamp()
    }

    fn is_defeated(self: BeastStats) -> bool {
        self.current_hp == 0
    }

    fn heal(ref self: BeastStats, amount: u16) {
        self
            .current_hp =
                if self.current_hp + amount > self.max_hp {
                    self.max_hp
                } else {
                    self.current_hp + amount
                };
        self._update_timestamp()
    }

    fn apply_status(ref self: BeastStats, status: StatusCondition) {
        self.status_condition = status;
        self._update_timestamp()
    }

    fn clear_status(ref self: BeastStats) {
        self.status_condition = StatusCondition::None;
        self._update_timestamp()
    }

    fn can_attack(self: BeastStats) -> bool {
        match self.status_condition {
            StatusCondition::Stunned => {
                let mut salt: u256 = poseidon_hash_span(
                    array![
                        self.beast_id.into(),
                        self.current_hp.into(),
                        starknet::get_block_timestamp().into(),
                    ]
                        .span(),
                )
                    .into();
                // Secure that salt is between [0, 18446744073709551615]
                let salt_u16: u16 = (salt % Bounded::<u16>::MAX.into()).try_into().unwrap();

                // 25% chance of returning true
                PseudoRandom::generate_random_u8(self.beast_id, salt_u16, 1, 4).into() == 1
            },
            _ => true,
        }
    }

    fn adjust_damage_for_status(self: BeastStats, damage: u16) -> u16 {
        match self.status_condition {
            StatusCondition::Weakness => {
                // Reduces damage to 70%
                (damage * 70) / 100
            },
            _ => damage,
        }
    }

    fn level_up(ref self: BeastStats, beast_type: BeastType) {
        // Light: HP +3, ATK +2, DEF +1, SPD +2
        // Magic: HP +2, ATK +3, DEF +1, SPD +2
        // Shadow: HP +4, ATK +1, DEF +3, SPD +0
        match beast_type {
            BeastType::Light => {
                self.max_hp += 3;
                self.attack += 2;
                self.defense += 1;
                self.speed += 2;
            },
            BeastType::Magic => {
                self.max_hp += 2;
                self.attack += 3;
                self.defense += 1;
                self.speed += 2;
            },
            BeastType::Shadow => {
                self.max_hp += 4;
                self.attack += 1;
                self.defense += 3;
                self.speed += 0;
            },
        }
        self.current_hp = self.max_hp;
        self._update_timestamp()
    }

    fn _update_timestamp(ref self: BeastStats) {
        self.last_timestamp = starknet::get_block_timestamp();
    }
}

#[cfg(test)]
mod tests {
    use super::{BeastStats, BeastStatsActionTrait, StatusCondition, BeastType};

    // take_damage() tests
    #[test]
    fn test_take_damage_normal_case() {
        let mut stats = dummy_beast_stats();
        stats.take_damage(30);
        assert!(stats.current_hp == 70, "HP should decrease by damage");
    }

    #[test]
    fn test_take_damage_exact_zero() {
        let mut stats = dummy_beast_stats();
        stats.current_hp = 50;
        stats.take_damage(50);
        assert!(stats.current_hp == 0, "HP should be 0 if damage equals HP");
    }

    #[test]
    fn test_take_damage_overkill() {
        let mut stats = dummy_beast_stats();
        stats.current_hp = 50;
        stats.take_damage(100);
        assert!(stats.current_hp == 0, "HP should not go below 0");
    }

    // heal() tests
    #[test]
    fn test_heal_normal() {
        let mut stats = dummy_beast_stats();
        stats.current_hp = 50;
        stats.heal(30);
        assert!(stats.current_hp == 80, "HP should increase by heal amount");
    }

    #[test]
    fn test_heal_capped() {
        let mut stats = dummy_beast_stats();
        stats.current_hp = 90;
        stats.heal(20);
        assert!(stats.current_hp == 100, "HP should not exceed max_hp");
    }

    #[test]
    fn test_heal_when_full() {
        let mut stats = dummy_beast_stats();
        stats.heal(10);
        assert!(stats.current_hp == 100, "HP stays at max if already full");
    }

    // level_up() tests
    #[test]
    fn test_level_up_light_type() {
        let mut stats = dummy_beast_stats();
        stats.current_hp = 50;

        // Light: HP +3, ATK +2, DEF +1, SPD +2
        stats.level_up(BeastType::Light);
        assert!(stats.max_hp == 103, "Light: HP +3");
        assert!(stats.attack == 102, "Light: ATK +2");
        assert!(stats.defense == 101, "Light: DEF +1");
        assert!(stats.speed == 52, "Light: SPD +2");
        assert!(stats.current_hp == stats.max_hp, "Current hp should be max HP");
    }

    #[test]
    fn test_level_up_sets_current_hp() {
        let mut stats = dummy_beast_stats();

        // Magic: HP +2, ATK +3, DEF +1, SPD +2
        stats.level_up(BeastType::Magic);
        assert!(stats.max_hp == 102, "Magic: HP +3");
        assert!(stats.attack == 103, "Magic: ATK +2");
        assert!(stats.defense == 101, "Magic: DEF +1");
        assert!(stats.speed == 52, "Magic: SPD +2");
        assert!(stats.current_hp == stats.max_hp, "Current hp should be max HP");
    }

    #[test]
    fn test_level_up_shadow_type() {
        let mut stats = dummy_beast_stats();

        // Shadow: HP +4, ATK +1, DEF +3, SPD +0
        stats.level_up(BeastType::Shadow);
        assert!(stats.max_hp == 104, "Shadow: HP +4");
        assert!(stats.attack == 101, "Shadow: ATK +1");
        assert!(stats.defense == 103, "Shadow: DEF +3");
        assert!(stats.speed == 50, "Shadow: SPD +0");
        assert!(stats.current_hp == stats.max_hp, "Current hp should be max HP");
    }

    // apply_status() tests
    #[test]
    fn test_apply_status_sets_status() {
        let mut stats = dummy_beast_stats();
        stats.apply_status(StatusCondition::Paralyzed);
        assert!(stats.status_condition == StatusCondition::Paralyzed, "Status should be Paralyzed");
    }

    #[test]
    fn test_apply_status_overwrites_existing() {
        let mut stats = dummy_beast_stats();
        stats.status_condition = StatusCondition::Poisoned;
        stats.apply_status(StatusCondition::Paralyzed);
        assert!(
            stats.status_condition == StatusCondition::Paralyzed,
            "Should overwrite previous status",
        );
    }

    // clear_status() tests
    #[test]
    fn test_clear_status_sets_none() {
        let mut stats = dummy_beast_stats();
        stats.status_condition = StatusCondition::Paralyzed;
        stats.clear_status();
        assert!(
            stats.status_condition == StatusCondition::None, "Status should be cleared to None",
        );
    }

    #[test]
    fn test_clear_status_when_none() {
        let mut stats = dummy_beast_stats();
        stats.status_condition = StatusCondition::None;
        stats.clear_status();
        assert!(stats.status_condition == StatusCondition::None, "Status remains None");
    }

    // can_attack() tests
    #[test]
    fn test_can_attack_when_status_none() {
        let stats = dummy_beast_stats();
        assert!(stats.can_attack(), "Should attack when status is None");
    }

    #[test]
    fn test_can_attack_when_status_poisoned() {
        let mut stats = dummy_beast_stats();
        stats.status_condition = StatusCondition::Poisoned;
        assert!(stats.can_attack(), "Should attack when poisoned");
    }

    // MOCKS
    fn dummy_beast_stats() -> BeastStats {
        BeastStats {
            beast_id: 1,
            max_hp: 100,
            current_hp: 100,
            attack: 100,
            defense: 100,
            speed: 50,
            status_condition: StatusCondition::None,
            last_timestamp: starknet::get_block_timestamp(),
        }
    }
}
