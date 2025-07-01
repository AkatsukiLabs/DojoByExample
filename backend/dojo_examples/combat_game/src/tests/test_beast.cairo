#[cfg(test)]
mod beast_skill_tests {
    use combat_game::models::beast_skill::BeastSkill;
    use combat_game::models::skill::{
        BEAM_SKILL_ID, BLAST_SKILL_ID, BURN_SKILL_ID, CRUSH_SKILL_ID, FREEZE_SKILL_ID,
        KICK_SKILL_ID, PIERCE_SKILL_ID, PUNCH_SKILL_ID, SHOCK_SKILL_ID, SLASH_SKILL_ID,
        SMASH_SKILL_ID, WAVE_SKILL_ID,
    };
    use super::*;

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_struct_init_valid() {
        let beast_id = 42_u16;
        let skills = array![SLASH_SKILL_ID, BEAM_SKILL_ID, WAVE_SKILL_ID].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: skills };
        assert_eq!(beast_skill.beast_id, beast_id, "Beast ID should match");
        assert_eq!(beast_skill.skills_ids.len(), 3, "Skills length should be 3");
        assert_eq!(*beast_skill.skills_ids.at(0), SLASH_SKILL_ID, "First skill should be SLASH");
        assert_eq!(*beast_skill.skills_ids.at(1), BEAM_SKILL_ID, "Second skill should be BEAM");
        assert_eq!(*beast_skill.skills_ids.at(2), WAVE_SKILL_ID, "Third skill should be WAVE");
    }

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_assignment_light() {
        let beast_id = 1_u16;
        let skills = array![BEAM_SKILL_ID, SLASH_SKILL_ID, PIERCE_SKILL_ID, WAVE_SKILL_ID].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: skills };
        assert_eq!(beast_skill.skills_ids.len(), 4, "Light beast should have 4 skills");
        assert_eq!(*beast_skill.skills_ids.at(0), BEAM_SKILL_ID, "First skill should be BEAM");
        assert_eq!(*beast_skill.skills_ids.at(1), SLASH_SKILL_ID, "Second skill should be SLASH");
        assert_eq!(*beast_skill.skills_ids.at(2), PIERCE_SKILL_ID, "Third skill should be PIERCE");
        assert_eq!(*beast_skill.skills_ids.at(3), WAVE_SKILL_ID, "Fourth skill should be WAVE");
    }

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_assignment_magic() {
        let beast_id = 2_u16;
        let skills = array![BLAST_SKILL_ID, FREEZE_SKILL_ID, BURN_SKILL_ID, PUNCH_SKILL_ID].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: skills };
        assert_eq!(beast_skill.skills_ids.len(), 4, "Magic beast should have 4 skills");
        assert_eq!(*beast_skill.skills_ids.at(0), BLAST_SKILL_ID, "First skill should be BLAST");
        assert_eq!(*beast_skill.skills_ids.at(1), FREEZE_SKILL_ID, "Second skill should be FREEZE");
        assert_eq!(*beast_skill.skills_ids.at(2), BURN_SKILL_ID, "Third skill should be BURN");
        assert_eq!(*beast_skill.skills_ids.at(3), PUNCH_SKILL_ID, "Fourth skill should be PUNCH");
    }

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_assignment_shadow() {
        let beast_id = 3_u16;
        let skills = array![SMASH_SKILL_ID, CRUSH_SKILL_ID, SHOCK_SKILL_ID, KICK_SKILL_ID].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: skills };
        assert_eq!(beast_skill.skills_ids.len(), 4, "Shadow beast should have 4 skills");
        assert_eq!(*beast_skill.skills_ids.at(0), SMASH_SKILL_ID, "First skill should be SMASH");
        assert_eq!(*beast_skill.skills_ids.at(1), CRUSH_SKILL_ID, "Second skill should be CRUSH");
        assert_eq!(*beast_skill.skills_ids.at(2), SHOCK_SKILL_ID, "Third skill should be SHOCK");
        assert_eq!(*beast_skill.skills_ids.at(3), KICK_SKILL_ID, "Fourth skill should be KICK");
    }

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_empty_skills() {
        let beast_id = 4_u16;
        let skills = array![].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: skills };
        assert_eq!(beast_skill.skills_ids.len(), 0, "Empty skills list should have length 0");
    }

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_invalid_skill_id() {
        let beast_id = 5_u16;
        let invalid_skill_id = 999_u256;
        let skills = array![SLASH_SKILL_ID, invalid_skill_id].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: skills };
        assert_eq!(beast_skill.skills_ids.len(), 2, "Should have 2 skills");
        assert_eq!(
            *beast_skill.skills_ids.at(1), invalid_skill_id, "Second skill should be invalid",
        );
    }

    #[test]
    #[available_gas(300000)]
    fn test_beast_skill_id_validation() {
        let beast_id = 6_u16;
        let valid_skills = array![SLASH_SKILL_ID, BEAM_SKILL_ID, WAVE_SKILL_ID].span();
        let beast_skill = BeastSkill { beast_id, skills_ids: valid_skills };
        // Validate all skills are in the expected set
        let expected = array![SLASH_SKILL_ID, BEAM_SKILL_ID, WAVE_SKILL_ID];
        for i in 0..beast_skill.skills_ids.len() {
            let skill_id = *beast_skill.skills_ids.at(i);
            let mut found = false;
            for j in 0..expected.len() {
                if skill_id == *expected.at(j) {
                    found = true;
                }
            };
            assert!(found, "Skill ID {} should be valid", skill_id);
        }
    }
}
