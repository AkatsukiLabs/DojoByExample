use crate::types::skill::SkillType;

const SLASH_SKILL_DAMAGE: u16 = 40;
const BEAM_SKILL_DAMAGE: u16 = 45;
const WAVE_SKILL_DAMAGE: u16 = 35;
const PUNCH_SKILL_DAMAGE: u16 = 30;
const KICK_SKILL_DAMAGE: u16 = 35;
const BLAST_SKILL_DAMAGE: u16 = 50;
const CRUSH_SKILL_DAMAGE: u16 = 45;
const PIERCE_SKILL_DAMAGE: u16 = 40;
const SMASH_SKILL_DAMAGE: u16 = 50;
const BURN_SKILL_DAMAGE: u16 = 40;
const FREEZE_SKILL_DAMAGE: u16 = 40;
const SHOCK_SKILL_DAMAGE: u16 = 45;
const DEFAULT_SKILL_DAMAGE: u16 = 30;

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
            SkillType::Slash => { SLASH_SKILL_DAMAGE },
            SkillType::Beam => { BEAM_SKILL_DAMAGE },
            SkillType::Wave => { WAVE_SKILL_DAMAGE },
            SkillType::Punch => { PUNCH_SKILL_DAMAGE },
            SkillType::Kick => { KICK_SKILL_DAMAGE },
            SkillType::Blast => { BLAST_SKILL_DAMAGE },
            SkillType::Crush => { CRUSH_SKILL_DAMAGE },
            SkillType::Pierce => { PIERCE_SKILL_DAMAGE },
            SkillType::Smash => { SMASH_SKILL_DAMAGE },
            SkillType::Burn => { BURN_SKILL_DAMAGE },
            SkillType::Freeze => { FREEZE_SKILL_DAMAGE },
            SkillType::Shock => { SHOCK_SKILL_DAMAGE },
            SkillType::Default => { DEFAULT_SKILL_DAMAGE },
        }
    }
}

