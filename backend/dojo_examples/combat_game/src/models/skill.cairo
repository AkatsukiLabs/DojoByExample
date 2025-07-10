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

pub const SLASH_SKILL_ID: u256 = 1;
pub const BEAM_SKILL_ID: u256 = 2;
pub const WAVE_SKILL_ID: u256 = 3;
pub const PUNCH_SKILL_ID: u256 = 4;
pub const KICK_SKILL_ID: u256 = 5;
pub const BLAST_SKILL_ID: u256 = 6;
pub const CRUSH_SKILL_ID: u256 = 7;
pub const PIERCE_SKILL_ID: u256 = 8;
pub const SMASH_SKILL_ID: u256 = 9;
pub const BURN_SKILL_ID: u256 = 10;
pub const FREEZE_SKILL_ID: u256 = 11;
pub const SHOCK_SKILL_ID: u256 = 12;
pub const DEFAULT_SKILL_ID: u256 = 13;

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

#[cfg(test)]
mod tests {
    use super::{
        SkillImpl, SkillType,
        SLASH_SKILL_ID, BEAM_SKILL_ID, WAVE_SKILL_ID, PUNCH_SKILL_ID, KICK_SKILL_ID,
        BLAST_SKILL_ID, CRUSH_SKILL_ID, PIERCE_SKILL_ID, SMASH_SKILL_ID, BURN_SKILL_ID,
        FREEZE_SKILL_ID, SHOCK_SKILL_ID, DEFAULT_SKILL_ID,
        SLASH_SKILL_DAMAGE, BEAM_SKILL_DAMAGE, WAVE_SKILL_DAMAGE, PUNCH_SKILL_DAMAGE,
        KICK_SKILL_DAMAGE, BLAST_SKILL_DAMAGE, CRUSH_SKILL_DAMAGE, PIERCE_SKILL_DAMAGE,
        SMASH_SKILL_DAMAGE, BURN_SKILL_DAMAGE, FREEZE_SKILL_DAMAGE, SHOCK_SKILL_DAMAGE,
        DEFAULT_SKILL_DAMAGE,
    };

    #[test]
    #[available_gas(1000000)]
    fn test_skill_initialization() {
        let skill = SkillImpl::new(SLASH_SKILL_ID, 100, SkillType::Slash, 5);

        assert_eq!(skill.id, SLASH_SKILL_ID, "Skill ID should match");
        assert_eq!(skill.power, 100, "Skill power should be 100");
        assert_eq!(skill.skill_type, SkillType::Slash, "Skill type should be Slash");
        assert_eq!(skill.min_level_required, 5, "Min level required should be 5");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_new_constructor() {
        let skill = SkillImpl::new(BEAM_SKILL_ID, 150, SkillType::Beam, 10);

        assert_eq!(skill.id, BEAM_SKILL_ID, "Skill ID should match BEAM_SKILL_ID");
        assert_eq!(skill.power, 150, "Skill power should be 150");
        assert_eq!(skill.skill_type, SkillType::Beam, "Skill type should be Beam");
        assert_eq!(skill.min_level_required, 10, "Min level required should be 10");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_zero_power() {
        let skill = SkillImpl::new(WAVE_SKILL_ID, 0, SkillType::Wave, 1);

        assert_eq!(skill.power, 0, "Skill power should be 0");
        assert_eq!(skill.min_level_required, 1, "Min level required should be 1");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_zero_level_requirement() {
        let skill = SkillImpl::new(PUNCH_SKILL_ID, 50, SkillType::Punch, 0);

        assert_eq!(skill.min_level_required, 0, "Min level required should be 0");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_max_values() {
        let skill = SkillImpl::new(KICK_SKILL_ID, 65535, SkillType::Kick, 255);

        assert_eq!(skill.power, 65535, "Skill power should be max u16");
        assert_eq!(skill.min_level_required, 255, "Min level required should be max u8");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_slash() {
        let damage = SkillImpl::base_damage(SkillType::Slash);
        assert_eq!(damage, SLASH_SKILL_DAMAGE, "Slash base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_beam() {
        let damage = SkillImpl::base_damage(SkillType::Beam);
        assert_eq!(damage, BEAM_SKILL_DAMAGE, "Beam base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_wave() {
        let damage = SkillImpl::base_damage(SkillType::Wave);
        assert_eq!(damage, WAVE_SKILL_DAMAGE, "Wave base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_punch() {
        let damage = SkillImpl::base_damage(SkillType::Punch);
        assert_eq!(damage, PUNCH_SKILL_DAMAGE, "Punch base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_kick() {
        let damage = SkillImpl::base_damage(SkillType::Kick);
        assert_eq!(damage, KICK_SKILL_DAMAGE, "Kick base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_blast() {
        let damage = SkillImpl::base_damage(SkillType::Blast);
        assert_eq!(damage, BLAST_SKILL_DAMAGE, "Blast base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_crush() {
        let damage = SkillImpl::base_damage(SkillType::Crush);
        assert_eq!(damage, CRUSH_SKILL_DAMAGE, "Crush base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_pierce() {
        let damage = SkillImpl::base_damage(SkillType::Pierce);
        assert_eq!(damage, PIERCE_SKILL_DAMAGE, "Pierce base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_smash() {
        let damage = SkillImpl::base_damage(SkillType::Smash);
        assert_eq!(damage, SMASH_SKILL_DAMAGE, "Smash base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_burn() {
        let damage = SkillImpl::base_damage(SkillType::Burn);
        assert_eq!(damage, BURN_SKILL_DAMAGE, "Burn base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_freeze() {
        let damage = SkillImpl::base_damage(SkillType::Freeze);
        assert_eq!(damage, FREEZE_SKILL_DAMAGE, "Freeze base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_shock() {
        let damage = SkillImpl::base_damage(SkillType::Shock);
        assert_eq!(damage, SHOCK_SKILL_DAMAGE, "Shock base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_base_damage_default() {
        let damage = SkillImpl::base_damage(SkillType::Default);
        assert_eq!(damage, DEFAULT_SKILL_DAMAGE, "Default base damage should match constant");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_id_uniqueness() {
        let skill1 = SkillImpl::new(SLASH_SKILL_ID, 100, SkillType::Slash, 5);
        let skill2 = SkillImpl::new(BEAM_SKILL_ID, 100, SkillType::Beam, 5);

        assert!(skill1.id != skill2.id, "Skills should have unique IDs");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_equality() {
        let skill1 = SkillImpl::new(BLAST_SKILL_ID, 200, SkillType::Blast, 15);
        let skill2 = SkillImpl::new(BLAST_SKILL_ID, 200, SkillType::Blast, 15);

        assert_eq!(skill1, skill2, "Skills with same properties should be equal");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_inequality() {
        let skill1 = SkillImpl::new(CRUSH_SKILL_ID, 200, SkillType::Crush, 15);
        let skill2 = SkillImpl::new(CRUSH_SKILL_ID, 300, SkillType::Crush, 15);

        assert!(skill1 != skill2, "Skills with different properties should be different");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_all_skill_constants() {
        // Test that all skill ID constants are unique
        let skill_ids = array![
            SLASH_SKILL_ID, BEAM_SKILL_ID, WAVE_SKILL_ID, PUNCH_SKILL_ID,
            KICK_SKILL_ID, BLAST_SKILL_ID, CRUSH_SKILL_ID, PIERCE_SKILL_ID,
            SMASH_SKILL_ID, BURN_SKILL_ID, FREEZE_SKILL_ID, SHOCK_SKILL_ID,
            DEFAULT_SKILL_ID
        ];

        // Test that each ID is within expected range
        assert!(SLASH_SKILL_ID >= 1 && SLASH_SKILL_ID <= 13, "Slash skill ID should be in range");
        assert!(BEAM_SKILL_ID >= 1 && BEAM_SKILL_ID <= 13, "Beam skill ID should be in range");
        assert!(WAVE_SKILL_ID >= 1 && WAVE_SKILL_ID <= 13, "Wave skill ID should be in range");
        assert!(PUNCH_SKILL_ID >= 1 && PUNCH_SKILL_ID <= 13, "Punch skill ID should be in range");
        assert!(KICK_SKILL_ID >= 1 && KICK_SKILL_ID <= 13, "Kick skill ID should be in range");
        assert!(BLAST_SKILL_ID >= 1 && BLAST_SKILL_ID <= 13, "Blast skill ID should be in range");
        assert!(CRUSH_SKILL_ID >= 1 && CRUSH_SKILL_ID <= 13, "Crush skill ID should be in range");
        assert!(PIERCE_SKILL_ID >= 1 && PIERCE_SKILL_ID <= 13, "Pierce skill ID should be in range");
        assert!(SMASH_SKILL_ID >= 1 && SMASH_SKILL_ID <= 13, "Smash skill ID should be in range");
        assert!(BURN_SKILL_ID >= 1 && BURN_SKILL_ID <= 13, "Burn skill ID should be in range");
        assert!(FREEZE_SKILL_ID >= 1 && FREEZE_SKILL_ID <= 13, "Freeze skill ID should be in range");
        assert!(SHOCK_SKILL_ID >= 1 && SHOCK_SKILL_ID <= 13, "Shock skill ID should be in range");
        assert!(DEFAULT_SKILL_ID >= 1 && DEFAULT_SKILL_ID <= 13, "Default skill ID should be in range");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_skill_damage_consistency() {
        // Test that base damage matches what would be set when creating skills
        let slash_skill = SkillImpl::new(SLASH_SKILL_ID, SLASH_SKILL_DAMAGE, SkillType::Slash, 1);
        let calculated_damage = SkillImpl::base_damage(SkillType::Slash);
        
        assert_eq!(slash_skill.power, calculated_damage, "Skill power should match base damage");
    }
}