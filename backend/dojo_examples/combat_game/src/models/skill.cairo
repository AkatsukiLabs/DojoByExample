use crate::types::skill::SkillType;

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

#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
#[dojo::model]
pub struct Skill {
    #[key]
    pub id: u256,
    pub power: u16,
    pub skill_type: SkillType,
    pub min_level_required: u8,
}

#[generate_trait]
pub impl SkillImpl of SkillTrait {
    #[inline(always)]
    fn new(id: u256, power: u16, skill_type: SkillType, min_level_required: u8) -> Skill {
        Skill { id, power, skill_type, min_level_required }
    }

    fn base_damage(skill_type: SkillType) -> u16 {
        match skill_type {
            SkillType::Slash => { SLASH_ATTACK_POWER },
            SkillType::Beam => { BEAM_ATTACK_POWER },
            SkillType::Wave => { WAVE_ATTACK_POWER },
            SkillType::Punch => { PUNCH_ATTACK_POWER },
            SkillType::Kick => { KICK_ATTACK_POWER },
            SkillType::Blast => { BLAST_ATTACK_POWER },
            SkillType::Crush => { CRUSH_ATTACK_POWER },
            SkillType::Pierce => { PIERCE_ATTACK_POWER },
            SkillType::Smash => { SMASH_ATTACK_POWER },
            SkillType::Burn => { BURN_ATTACK_POWER },
            SkillType::Freeze => { FREEZE_ATTACK_POWER },
            SkillType::Shock => { SHOCK_ATTACK_POWER },
            SkillType::Default => { DEFAULT_ATTACK_POWER },
        }
    }
}

