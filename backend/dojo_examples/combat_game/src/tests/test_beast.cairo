#[cfg(test)]
mod beast_integration_tests {
    use combat_game::{
        models::{beast::{BeastTrait}, beast_stats::{BeastStatsActionTrait}},
        types::{beast_type::BeastType, skill::SkillType, status_condition::StatusCondition},
    };
    use starknet::{contract_address_const, ContractAddress};

    const PLAYER1_ADDRESS: felt252 = 0x1234;

    fn PLAYER1() -> ContractAddress {
        contract_address_const::<PLAYER1_ADDRESS>()
    }

    // ===============================
    // MINIMAL BEAST INTEGRATION TESTS
    // ===============================

    #[test]
    #[available_gas(300000)]
    fn test_beast_creation_integration() {
        // Test beast creation with different types
        let light_beast = BeastTrait::new(PLAYER1(), 1, BeastType::Light);
        let magic_beast = BeastTrait::new(PLAYER1(), 2, BeastType::Magic);
        let shadow_beast = BeastTrait::new(PLAYER1(), 3, BeastType::Shadow);

        // Validate basic properties
        assert_eq!(light_beast.player, PLAYER1(), "Light beast should belong to correct player");
        assert_eq!(light_beast.beast_id, 1, "Light beast ID should match");
        assert_eq!(light_beast.beast_type, BeastType::Light, "Beast type should be Light");
        assert_eq!(light_beast.level, 0, "Beast should start at level 0");
        assert_eq!(light_beast.experience, 0, "Beast should start with 0 experience");

        assert_eq!(magic_beast.beast_type, BeastType::Magic, "Beast type should be Magic");
        assert_eq!(shadow_beast.beast_type, BeastType::Shadow, "Beast type should be Shadow");
    }

    #[test]
    #[available_gas(250000)]
    fn test_beast_type_effectiveness_integration() {
        // Test type effectiveness calculations (pure calculations)
        let light_vs_shadow = BeastTrait::calculate_effectiveness(
            BeastType::Light, BeastType::Shadow,
        );
        let light_vs_magic = BeastTrait::calculate_effectiveness(
            BeastType::Light, BeastType::Magic,
        );
        let light_vs_light = BeastTrait::calculate_effectiveness(
            BeastType::Light, BeastType::Light,
        );

        assert_eq!(light_vs_shadow, 150, "Light should be super effective against Shadow");
        assert_eq!(light_vs_magic, 50, "Light should be not very effective against Magic");
        assert_eq!(light_vs_light, 100, "Light should be normally effective against Light");

        let magic_vs_light = BeastTrait::calculate_effectiveness(
            BeastType::Magic, BeastType::Light,
        );
        assert_eq!(magic_vs_light, 150, "Magic should be super effective against Light");
    }

    #[test]
    #[available_gas(250000)]
    fn test_beast_skill_favoring_integration() {
        let light_beast = BeastTrait::new(PLAYER1(), 1, BeastType::Light);
        let magic_beast = BeastTrait::new(PLAYER1(), 2, BeastType::Magic);

        // Test skill type favoring
        assert!(
            light_beast.is_favored_attack(SkillType::Beam), "Light beast should favor Beam attacks",
        );
        assert!(
            light_beast.is_favored_attack(SkillType::Slash),
            "Light beast should favor Slash attacks",
        );
        assert!(
            !light_beast.is_favored_attack(SkillType::Blast),
            "Light beast should NOT favor Blast attacks",
        );

        assert!(
            magic_beast.is_favored_attack(SkillType::Blast),
            "Magic beast should favor Blast attacks",
        );
        assert!(
            !magic_beast.is_favored_attack(SkillType::Beam),
            "Magic beast should NOT favor Beam attacks",
        );
    }

    #[test]
    #[available_gas(400000)]
    fn test_beast_attack_calculations_integration() {
        let light_beast = BeastTrait::new(PLAYER1(), 1, BeastType::Light);

        // Test attack calculation with type effectiveness
        let (damage, is_favored, is_effective) = light_beast
            .attack(BeastType::Shadow, SkillType::Beam, 1);

        assert!(damage > 0, "Attack should deal damage");
        assert!(is_favored, "Beam should be favored by Light beast");
        assert!(is_effective, "Light should be effective against Shadow");

        // Test non-effective attack
        let (damage2, is_favored2, is_effective2) = light_beast
            .attack(BeastType::Magic, SkillType::Beam, 1);

        assert!(damage2 > 0, "Attack should still deal damage");
        assert!(is_favored2, "Beam should still be favored by Light beast");
        assert!(!is_effective2, "Light should not be effective against Magic");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_beast_stats_basic_integration() {
        let beast_stats = BeastStatsActionTrait::new_beast_stats(1, BeastType::Light, 1, 1000);

        // Validate basic stats exist
        assert!(beast_stats.max_hp > 0, "Beast should have max HP");
        assert!(beast_stats.current_hp > 0, "Beast should have current HP");
        assert!(beast_stats.attack > 0, "Beast should have attack");
        assert!(beast_stats.defense > 0, "Beast should have defense");
        assert!(beast_stats.speed > 0, "Beast should have speed");

        // Validate initial state
        assert_eq!(beast_stats.current_hp, beast_stats.max_hp, "Current HP should equal max HP");
        assert_eq!(
            beast_stats.status_condition, StatusCondition::None, "Should start with no status",
        );
    }

    #[test]
    #[available_gas(1000000)]
    fn test_beast_stats_damage_integration() {
        let mut beast_stats = BeastStatsActionTrait::new_beast_stats(1, BeastType::Light, 1, 1000);

        let initial_hp = beast_stats.current_hp;

        // Test damage taking
        beast_stats.take_damage(20);
        assert_eq!(beast_stats.current_hp, initial_hp - 20, "Should take damage correctly");
        assert!(!beast_stats.is_defeated(), "Should not be defeated with remaining HP");

        // Test healing
        beast_stats.heal(10);
        assert_eq!(beast_stats.current_hp, initial_hp - 10, "Should heal correctly");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_beast_status_conditions_integration() {
        let mut beast_stats = BeastStatsActionTrait::new_beast_stats(1, BeastType::Light, 1, 1000);

        // Test initial state
        assert_eq!(
            beast_stats.status_condition, StatusCondition::None, "Should start with no status",
        );
        assert!(beast_stats.can_attack(), "Should be able to attack initially");

        // Test applying status condition
        beast_stats.apply_status(StatusCondition::Poisoned);
        assert_eq!(
            beast_stats.status_condition, StatusCondition::Poisoned, "Should have poisoned status",
        );
        assert!(
            beast_stats.can_attack(),
            "Should still be able to attack when poisoned (only Stunned prevents attacking)",
        );

        // Test clearing status condition
        beast_stats.clear_status();
        assert_eq!(beast_stats.status_condition, StatusCondition::None, "Status should be cleared");
        assert!(beast_stats.can_attack(), "Should be able to attack after status cleared");
    }

    #[test]
    #[available_gas(1500000)]
    fn test_beast_type_modifiers_integration() {
        let light_stats = BeastStatsActionTrait::new_beast_stats(1, BeastType::Light, 1, 1000);
        let magic_stats = BeastStatsActionTrait::new_beast_stats(2, BeastType::Magic, 1, 1000);
        let shadow_stats = BeastStatsActionTrait::new_beast_stats(3, BeastType::Shadow, 1, 1000);

        // All beasts should have positive stats
        assert!(light_stats.max_hp > 0, "Light beast should have HP");
        assert!(light_stats.attack > 0, "Light beast should have attack");

        assert!(magic_stats.max_hp > 0, "Magic beast should have HP");
        assert!(magic_stats.attack > 0, "Magic beast should have attack");

        assert!(shadow_stats.max_hp > 0, "Shadow beast should have HP");
        assert!(shadow_stats.attack > 0, "Shadow beast should have attack");

        // Each type should have different total stats due to modifiers
        let light_total = light_stats.max_hp + light_stats.attack;
        let magic_total = magic_stats.max_hp + magic_stats.attack;

        // At least one comparison should be different due to type modifiers
        assert!(light_total != magic_total, "Beast types should have different stat totals");
    }

    #[test]
    #[available_gas(1500000)]
    fn test_beast_lifecycle_simulation() {
        // Simulate a simplified beast lifecycle
        let mut beast = BeastTrait::new(PLAYER1(), 1, BeastType::Light);
        let mut beast_stats = BeastStatsActionTrait::new_beast_stats(1, BeastType::Light, 1, 1000);

        // Initial state
        let initial_level = beast.level;
        let initial_hp = beast_stats.current_hp;

        // Simulate gaining experience
        beast.experience += 50;

        // Simulate taking damage
        beast_stats.take_damage(25);

        // Verify changes
        assert_eq!(beast.experience, 50, "Experience should have increased");
        assert_eq!(beast_stats.current_hp, initial_hp - 25, "HP should have decreased");

        // Test that beast maintains its properties
        assert_eq!(beast.beast_type, BeastType::Light, "Beast type should remain unchanged");
        assert_eq!(beast.player, PLAYER1(), "Beast owner should remain unchanged");
        assert_eq!(beast.level, initial_level, "Level should remain unchanged until level up");
    }
}
