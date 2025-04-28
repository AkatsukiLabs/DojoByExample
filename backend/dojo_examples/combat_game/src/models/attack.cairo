use crate::types::attack::AttackType;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Attack {
    #[key]
    pub beast_id: u256,
    #[key]
    pub attack_id: u256,
    pub min_level_required: u8,
    pub attack_type: AttackType,
}

const SLASH_ATTACK_POWER: u16 = 40;
const BEAM_ATTACK_POWER: u16 = 45;
const WAVE_ATTACK_POWER: u16 = 35;
const PUNCH_ATTACK_POWER: u16 = 30;
const KICK_ATTACK_POWER: u16 = 35;
const BLAST_ATTACK_POWER: u16 = 50;
const CRUSH_ATTACK_POWER: u16 = 45;
const PIERCE_ATTACK_POWER: u16 = 40;
const SMASH_ATTACK_POWER: u16 = 50;
const BURN_ATTACK_POWER: u16 = 40;
const FREEZE_ATTACK_POWER: u16 = 40;
const SHOCK_ATTACK_POWER: u16 = 45;
const DEFAULT_ATTACK_POWER: u16 = 30;

#[generate_trait]
pub impl AttackImpl of AttackTrait {
    #[inline(always)]
    fn new(
        beast_id: u256, attack_id: u256, min_level_required: u8, attack_type: AttackType,
    ) -> Attack {
        Attack { beast_id, attack_id, min_level_required, attack_type }
    }

    fn get_attack_type(self: Attack) -> AttackType {
        self.attack_type
    }

    fn get_attack_power(attack_type: AttackType) -> u16 {
        match attack_type {
            AttackType::Slash => { SLASH_ATTACK_POWER },
            AttackType::Beam => { BEAM_ATTACK_POWER },
            AttackType::Wave => { WAVE_ATTACK_POWER },
            AttackType::Punch => { PUNCH_ATTACK_POWER },
            AttackType::Kick => { KICK_ATTACK_POWER },
            AttackType::Blast => { BLAST_ATTACK_POWER },
            AttackType::Crush => { CRUSH_ATTACK_POWER },
            AttackType::Pierce => { PIERCE_ATTACK_POWER },
            AttackType::Smash => { SMASH_ATTACK_POWER },
            AttackType::Burn => { BURN_ATTACK_POWER },
            AttackType::Freeze => { FREEZE_ATTACK_POWER },
            AttackType::Shock => { SHOCK_ATTACK_POWER },
            AttackType::Default => { DEFAULT_ATTACK_POWER },
        }
    }
}
