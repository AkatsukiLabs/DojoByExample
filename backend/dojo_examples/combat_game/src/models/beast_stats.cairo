use crate::{
    types::{status_condition::StatusCondition, beast_type::BeastType},
    helpers::pseudo_random::PseudoRandom,
};
use core::{poseidon::poseidon_hash_span, num::traits::Bounded};

#[derive(Copy, Drop, Serde, Debug)]
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
impl BeastStatsActions of BeastStatsActionTrait {
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
            // StatusCondition::Stunned not implemented
            StatusCondition::Paralyzed => {
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
            // StatusCondition::Weakness not implemented
            _ => damage
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

