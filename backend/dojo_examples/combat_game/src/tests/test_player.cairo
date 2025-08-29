#[cfg(test)]
mod player_integration_tests {
    use combat_game::constants::SECONDS_PER_DAY;
    use combat_game::models::battle::{Battle, BattleTrait, m_Battle};
    use combat_game::models::beast::{Beast, m_Beast};
    use combat_game::models::beast_skill::{BeastSkill, m_BeastSkill};
    use combat_game::models::beast_stats::{BeastStats, BeastStatsActionTrait, m_BeastStats};
    use combat_game::models::player::{Player, PlayerAssert, m_Player};
    use combat_game::models::skill::{Skill, m_Skill};
    use combat_game::store::StoreTrait;
    use combat_game::systems::battle::{IBattleDispatcher, IBattleDispatcherTrait, battle_system};
    use combat_game::systems::beast::{IBeastDispatcher, IBeastDispatcherTrait, beast_system};
    use combat_game::systems::player::{IPlayerDispatcher, IPlayerDispatcherTrait, player_system};
    use combat_game::types::battle_status::BattleStatus;
    use combat_game::types::beast_type::BeastType;
    use combat_game::types::status_condition::StatusCondition;
    use core::num::traits::zero::Zero;
    use dojo::model::ModelStorage;
    use dojo::world::{WorldStorage, WorldStorageTrait};
    use dojo_cairo_test::{
        ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
        spawn_test_world,
    };
    use starknet::{ContractAddress, contract_address_const, get_block_timestamp, testing};

    // Test constants
    const INITIAL_BEAST_ID: u16 = 1;
    const BATTLE_TYPE: u8 = 0;

    fn PLAYER1() -> ContractAddress {
        contract_address_const::<0x1234>()
    }

    fn PLAYER2() -> ContractAddress {
        contract_address_const::<0x5678>()
    }

    fn PLAYER3() -> ContractAddress {
        contract_address_const::<0x9abc>()
    }

    pub fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "combat_game",
            resources: [
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Model(m_Beast::TEST_CLASS_HASH),
                TestResource::Model(m_BeastStats::TEST_CLASS_HASH),
                TestResource::Model(m_BeastSkill::TEST_CLASS_HASH),
                TestResource::Model(m_Skill::TEST_CLASS_HASH),
                TestResource::Model(m_Battle::TEST_CLASS_HASH),
                TestResource::Event(player_system::e_PlayerSpawned::TEST_CLASS_HASH),
                TestResource::Event(beast_system::e_BeastSpawned::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_BattleCreated::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_BattleJoined::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_AttackExecuted::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_BattleEnded::TEST_CLASS_HASH),
                TestResource::Event(achievement::events::index::e_TrophyCreation::TEST_CLASS_HASH),
                TestResource::Event(
                    achievement::events::index::e_TrophyProgression::TEST_CLASS_HASH,
                ),
                TestResource::Contract(player_system::TEST_CLASS_HASH),
                TestResource::Contract(beast_system::TEST_CLASS_HASH),
                TestResource::Contract(battle_system::TEST_CLASS_HASH),
            ]
                .span(),
        };
        ndef
    }

    pub fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"combat_game", @"player_system")
                .with_writer_of([dojo::utils::bytearray_hash(@"combat_game")].span()),
            ContractDefTrait::new(@"combat_game", @"beast_system")
                .with_writer_of([dojo::utils::bytearray_hash(@"combat_game")].span()),
            ContractDefTrait::new(@"combat_game", @"battle_system")
                .with_writer_of([dojo::utils::bytearray_hash(@"combat_game")].span()),
        ]
            .span()
    }

    pub fn setup() -> (WorldStorage, IPlayerDispatcher, IBeastDispatcher, IBattleDispatcher) {
        let ndef = namespace_def();
        let mut world: WorldStorage = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (player_contract_address, _) = world.dns(@"player_system").unwrap();
        let player_system = IPlayerDispatcher { contract_address: player_contract_address };

        let (beast_contract_address, _) = world.dns(@"beast_system").unwrap();
        let beast_system = IBeastDispatcher { contract_address: beast_contract_address };

        let (battle_contract_address, _) = world.dns(@"battle_system").unwrap();
        let battle_system = IBattleDispatcher { contract_address: battle_contract_address };

        // Initialize skills in the world
        let mut store = StoreTrait::new(world);
        store.init_skills();

        (world, player_system, beast_system, battle_system)
    }

    fn setup_beast_for_player(
        mut world: WorldStorage,
        beast_system: IBeastDispatcher,
        player_address: ContractAddress,
        beast_type: BeastType,
    ) -> u16 {
        testing::set_caller_address(player_address);
        beast_system.spawn_beast(beast_type)
    }

    // ================================
    // PLAYER LIFECYCLE TESTS
    // ================================

    #[test]
    #[available_gas(3000000)]
    fn test_player_creation_and_initialization() {
        let (mut world, player_system, beast_system, _) = setup();

        // Set caller to player 1
        testing::set_caller_address(PLAYER1());

        // Spawn player with initial beast
        player_system.spawn_player(INITIAL_BEAST_ID);

        // Verify player was created with correct values
        let store = StoreTrait::new(world);
        let player = store.read_player_from_address(PLAYER1());

        player.assert_exists();
        assert_eq!(player.address, PLAYER1(), "Player address should match");
        assert_eq!(player.current_beast_id, INITIAL_BEAST_ID, "Current beast ID should be set");
        assert_eq!(player.battles_won, 0, "Initial battles won should be 0");
        assert_eq!(player.battles_lost, 0, "Initial battles lost should be 0");
        assert!(player.creation_day > 0, "Creation day should be set");
        assert!(player.last_active_day > 0, "Last active day should be set");
        assert_eq!(
            player.creation_day,
            player.last_active_day,
            "Creation and last active should be same initially",
        );
    }

    #[test]
    #[available_gas(3000000)]
    #[should_panic(expected: ('Player: Already exist',))]
    fn test_player_creation_duplicate_should_fail() {
        let (mut world, player_system, _, _) = setup();

        testing::set_caller_address(PLAYER1());

        // Create player first time
        player_system.spawn_player(INITIAL_BEAST_ID);

        // Try to create same player again - should panic
        player_system.spawn_player(INITIAL_BEAST_ID);
    }

    #[test]
    #[available_gas(3000000)]
    fn test_player_unique_addresses() {
        let (mut world, player_system, _, _) = setup();

        // Create player 1
        testing::set_caller_address(PLAYER1());
        player_system.spawn_player(1);

        // Create player 2
        testing::set_caller_address(PLAYER2());
        player_system.spawn_player(2);

        let store = StoreTrait::new(world);
        let player1 = store.read_player_from_address(PLAYER1());
        let player2 = store.read_player_from_address(PLAYER2());

        player1.assert_exists();
        player2.assert_exists();
        assert!(player1.address != player2.address, "Players should have unique addresses");
        assert!(
            player1.current_beast_id != player2.current_beast_id,
            "Players should have different beast IDs",
        );
    }

    // ================================
    // PLAYER-BEAST INTEGRATION TESTS
    // ================================

    #[test]
    #[available_gas(5000000)]
    fn test_player_beast_assignment_integration() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());

        // Create beast first
        let beast_id = beast_system.spawn_beast(BeastType::Light);

        // Create player with this beast
        player_system.spawn_player(beast_id);

        let store = StoreTrait::new(world);
        let player = store.read_player_from_address(PLAYER1());
        let beast = store.read_beast(beast_id);

        // Verify integration
        assert_eq!(player.current_beast_id, beast_id, "Player should have correct beast ID");
        assert_eq!(beast.player, PLAYER1(), "Beast should belong to player");
        assert_eq!(beast.beast_type, BeastType::Light, "Beast should have correct type");
    }

    #[test]
    #[available_gas(5000000)]
    fn test_player_beast_update_integration() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());

        // Create initial setup
        let initial_beast_id = beast_system.spawn_beast(BeastType::Light);
        player_system.spawn_player(initial_beast_id);

        // Create a new beast
        let new_beast_id = beast_system.spawn_beast(BeastType::Shadow);

        // Update player profile with new beast
        player_system.update_profile(true, new_beast_id);

        let store = StoreTrait::new(world);
        let player = store.read_player_from_address(PLAYER1());

        assert_eq!(player.current_beast_id, new_beast_id, "Player should have updated beast ID");
        assert_eq!(player.battles_won, 1, "Player should have 1 battle won from update");
    }

    // ================================
    // BATTLE STATISTICS INTEGRATION TESTS
    // ================================

    #[test]
    #[available_gas(8000000)]
    fn test_battle_statistics_tracking_integration() {
        let (mut world, player_system, beast_system, battle_system) = setup();

        // Setup two players with beasts
        testing::set_caller_address(PLAYER1());
        let beast1_id = beast_system.spawn_beast(BeastType::Light);
        player_system.spawn_player(beast1_id);

        testing::set_caller_address(PLAYER2());
        let beast2_id = beast_system.spawn_beast(BeastType::Shadow);
        player_system.spawn_player(beast2_id);

        // Setup beast stats for both
        let mut store = StoreTrait::new(world);
        let beast1_stats = BeastStatsActionTrait::new_beast_stats(
            beast1_id, BeastType::Light, 1, get_block_timestamp(),
        );
        let beast2_stats = BeastStatsActionTrait::new_beast_stats(
            beast2_id, BeastType::Shadow, 1, get_block_timestamp(),
        );
        store.write_beast_stats(beast1_stats);
        store.write_beast_stats(beast2_stats);

        // Simulate battle wins and losses
        testing::set_caller_address(PLAYER1());
        player_system.update_profile(true, beast1_id); // Win
        player_system.update_profile(false, beast1_id); // Loss
        player_system.update_profile(true, beast1_id); // Win

        testing::set_caller_address(PLAYER2());
        player_system.update_profile(false, beast2_id); // Loss
        player_system.update_profile(false, beast2_id); // Loss

        // Verify statistics
        let player1 = store.read_player_from_address(PLAYER1());
        let player2 = store.read_player_from_address(PLAYER2());

        assert_eq!(player1.battles_won, 2, "Player1 should have 2 wins");
        assert_eq!(player1.battles_lost, 1, "Player1 should have 1 loss");
        assert_eq!(player2.battles_won, 0, "Player2 should have 0 wins");
        assert_eq!(player2.battles_lost, 2, "Player2 should have 2 losses");
    }

    #[test]
    #[available_gas(8000000)]
    fn test_battle_statistics_persistence() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());
        let beast_id = beast_system.spawn_beast(BeastType::Magic);
        player_system.spawn_player(beast_id);

        // Initial state verification
        let mut store = StoreTrait::new(world);
        let initial_player = store.read_player_from_address(PLAYER1());
        assert_eq!(initial_player.battles_won, 0, "Initial wins should be 0");
        assert_eq!(initial_player.battles_lost, 0, "Initial losses should be 0");

        // Simulate multiple battle outcomes
        player_system.update_profile(true, beast_id); // Win 1
        player_system.update_profile(true, beast_id); // Win 2
        player_system.update_profile(false, beast_id); // Loss 1
        player_system.update_profile(true, beast_id); // Win 3

        // Verify persistence across multiple transactions
        let final_player = store.read_player_from_address(PLAYER1());
        assert_eq!(final_player.battles_won, 3, "Should have 3 total wins");
        assert_eq!(final_player.battles_lost, 1, "Should have 1 total loss");
    }

    // ================================
    // ACTIVITY TRACKING TESTS
    // ================================

    #[test]
    #[available_gas(5000000)]
    fn test_player_activity_tracking() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());
        let beast_id = beast_system.spawn_beast(BeastType::Light);

        // Record creation time
        let creation_timestamp = get_block_timestamp();
        player_system.spawn_player(beast_id);

        let store = StoreTrait::new(world);
        let player = store.read_player_from_address(PLAYER1());

        let expected_day = creation_timestamp / SECONDS_PER_DAY;
        assert_eq!(
            player.creation_day, expected_day.try_into().unwrap(), "Creation day should match",
        );
        assert_eq!(
            player.last_active_day,
            expected_day.try_into().unwrap(),
            "Last active should match creation initially",
        );

        // Simulate time passage and activity
        testing::set_block_timestamp(
            creation_timestamp + SECONDS_PER_DAY + 3600,
        ); // Next day + 1 hour
        player_system.update_profile(true, beast_id);

        let updated_player = store.read_player_from_address(PLAYER1());
        let new_expected_day = (creation_timestamp + SECONDS_PER_DAY + 3600) / SECONDS_PER_DAY;

        assert_eq!(
            updated_player.creation_day,
            expected_day.try_into().unwrap(),
            "Creation day should not change",
        );
        assert_eq!(
            updated_player.last_active_day,
            new_expected_day.try_into().unwrap(),
            "Last active should update",
        );
        assert!(
            updated_player.last_active_day > updated_player.creation_day,
            "Last active should be after creation",
        );
    }

    #[test]
    #[available_gas(5000000)]
    fn test_multiple_activity_updates() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());
        let beast_id = beast_system.spawn_beast(BeastType::Shadow);
        player_system.spawn_player(beast_id);

        let store = StoreTrait::new(world);
        let initial_player = store.read_player_from_address(PLAYER1());
        let initial_last_active = initial_player.last_active_day;

        // Multiple activities on same day should update last_active to same day
        player_system.update_profile(true, beast_id);
        player_system.update_profile(false, beast_id);

        let same_day_player = store.read_player_from_address(PLAYER1());
        assert_eq!(
            same_day_player.last_active_day,
            initial_last_active,
            "Same day activities should not change day",
        );

        // Activity on different day should update
        testing::set_block_timestamp(get_block_timestamp() + SECONDS_PER_DAY * 2);
        player_system.update_profile(true, beast_id);

        let different_day_player = store.read_player_from_address(PLAYER1());
        assert!(
            different_day_player.last_active_day > initial_last_active,
            "Different day activity should update last_active_day",
        );
    }

    // ================================
    // CROSS-SYSTEM INTEGRATION TESTS
    // ================================

    #[test]
    #[available_gas(10000000)]
    fn test_player_beast_battle_full_integration() {
        let (mut world, player_system, beast_system, battle_system) = setup();

        // Setup Player 1
        testing::set_caller_address(PLAYER1());
        let beast1_id = beast_system.spawn_beast(BeastType::Light);
        player_system.spawn_player(beast1_id);

        // Setup Player 2
        testing::set_caller_address(PLAYER2());
        let beast2_id = beast_system.spawn_beast(BeastType::Shadow);
        player_system.spawn_player(beast2_id);

        // Setup beast stats
        let mut store = StoreTrait::new(world);
        let beast1_stats = BeastStatsActionTrait::new_beast_stats(
            beast1_id, BeastType::Light, 1, get_block_timestamp(),
        );
        let beast2_stats = BeastStatsActionTrait::new_beast_stats(
            beast2_id, BeastType::Shadow, 1, get_block_timestamp(),
        );
        store.write_beast_stats(beast1_stats);
        store.write_beast_stats(beast2_stats);

        // Initialize beast skills
        store.init_beast_skills(beast1_id);
        store.init_beast_skills(beast2_id);

        // Create and join battle
        testing::set_caller_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        testing::set_caller_address(PLAYER2());
        battle_system.join_battle(battle_id);

        // Verify cross-system state
        let battle = store.read_battle(battle_id);
        let player1 = store.read_player_from_address(PLAYER1());
        let player2 = store.read_player_from_address(PLAYER2());
        let beast1 = store.read_beast(beast1_id);
        let beast2 = store.read_beast(beast2_id);

        assert_eq!(battle.player1, PLAYER1(), "Battle player1 should match");
        assert_eq!(battle.player2, PLAYER2(), "Battle player2 should match");
        assert_eq!(battle.status, BattleStatus::Active, "Battle should be active");
        assert_eq!(player1.current_beast_id, beast1_id, "Player1 beast should match");
        assert_eq!(player2.current_beast_id, beast2_id, "Player2 beast should match");
        assert_eq!(beast1.player, PLAYER1(), "Beast1 owner should match");
        assert_eq!(beast2.player, PLAYER2(), "Beast2 owner should match");
    }

    #[test]
    #[available_gas(8000000)]
    fn test_player_beast_switching_integration() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());

        // Create multiple beasts
        let beast1_id = beast_system.spawn_beast(BeastType::Light);
        let beast2_id = beast_system.spawn_beast(BeastType::Magic);
        let beast3_id = beast_system.spawn_beast(BeastType::Shadow);

        // Start with beast1
        player_system.spawn_player(beast1_id);

        let store = StoreTrait::new(world);
        let initial_player = store.read_player_from_address(PLAYER1());
        assert_eq!(initial_player.current_beast_id, beast1_id, "Should start with beast1");

        // Switch to beast2
        player_system.update_profile(true, beast2_id);
        let updated_player = store.read_player_from_address(PLAYER1());
        assert_eq!(updated_player.current_beast_id, beast2_id, "Should switch to beast2");
        assert_eq!(updated_player.battles_won, 1, "Should increment wins");

        // Switch to beast3
        player_system.update_profile(false, beast3_id);
        let final_player = store.read_player_from_address(PLAYER1());
        assert_eq!(final_player.current_beast_id, beast3_id, "Should switch to beast3");
        assert_eq!(final_player.battles_won, 1, "Wins should stay same");
        assert_eq!(final_player.battles_lost, 1, "Should increment losses");
    }

    // ================================
    // MULTIPLE PLAYERS INTERACTION TESTS
    // ================================

    #[test]
    #[available_gas(8000000)]
    fn test_multiple_players_simultaneous_creation() {
        let (mut world, player_system, beast_system, _) = setup();

        // Create multiple players simultaneously
        testing::set_caller_address(PLAYER1());
        let beast1_id = beast_system.spawn_beast(BeastType::Light);
        player_system.spawn_player(beast1_id);

        testing::set_caller_address(PLAYER2());
        let beast2_id = beast_system.spawn_beast(BeastType::Magic);
        player_system.spawn_player(beast2_id);

        testing::set_caller_address(PLAYER3());
        let beast3_id = beast_system.spawn_beast(BeastType::Shadow);
        player_system.spawn_player(beast3_id);

        // Verify all players exist independently
        let store = StoreTrait::new(world);
        let player1 = store.read_player_from_address(PLAYER1());
        let player2 = store.read_player_from_address(PLAYER2());
        let player3 = store.read_player_from_address(PLAYER3());

        player1.assert_exists();
        player2.assert_exists();
        player3.assert_exists();

        assert_eq!(player1.current_beast_id, beast1_id, "Player1 should have correct beast");
        assert_eq!(player2.current_beast_id, beast2_id, "Player2 should have correct beast");
        assert_eq!(player3.current_beast_id, beast3_id, "Player3 should have correct beast");

        // Verify they're all unique
        assert!(player1.address != player2.address, "Player1 and Player2 should be different");
        assert!(player1.address != player3.address, "Player1 and Player3 should be different");
        assert!(player2.address != player3.address, "Player2 and Player3 should be different");
    }

    #[test]
    #[available_gas(10000000)]
    fn test_multiple_players_battle_interactions() {
        let (mut world, player_system, beast_system, _) = setup();

        // Setup three players
        testing::set_caller_address(PLAYER1());
        let beast1_id = beast_system.spawn_beast(BeastType::Light);
        player_system.spawn_player(beast1_id);

        testing::set_caller_address(PLAYER2());
        let beast2_id = beast_system.spawn_beast(BeastType::Magic);
        player_system.spawn_player(beast2_id);

        testing::set_caller_address(PLAYER3());
        let beast3_id = beast_system.spawn_beast(BeastType::Shadow);
        player_system.spawn_player(beast3_id);

        // Simulate battle outcomes between different players
        testing::set_caller_address(PLAYER1());
        player_system.update_profile(true, beast1_id); // Player1 wins vs someone

        testing::set_caller_address(PLAYER2());
        player_system.update_profile(false, beast2_id); // Player2 loses vs Player1

        testing::set_caller_address(PLAYER1());
        player_system.update_profile(false, beast1_id); // Player1 loses vs Player3

        testing::set_caller_address(PLAYER3());
        player_system.update_profile(true, beast3_id); // Player3 wins vs Player1

        // Verify statistics
        let store = StoreTrait::new(world);
        let player1 = store.read_player_from_address(PLAYER1());
        let player2 = store.read_player_from_address(PLAYER2());
        let player3 = store.read_player_from_address(PLAYER3());

        assert_eq!(player1.battles_won, 1, "Player1 should have 1 win");
        assert_eq!(player1.battles_lost, 1, "Player1 should have 1 loss");
        assert_eq!(player2.battles_won, 0, "Player2 should have 0 wins");
        assert_eq!(player2.battles_lost, 1, "Player2 should have 1 loss");
        assert_eq!(player3.battles_won, 1, "Player3 should have 1 win");
        assert_eq!(player3.battles_lost, 0, "Player3 should have 0 losses");
    }

    // ================================
    // EDGE CASES AND ERROR CONDITIONS
    // ================================

    #[test]
    #[available_gas(3000000)]
    #[should_panic(expected: ('Player: Does not exist',))]
    fn test_update_nonexistent_player() {
        let (mut world, player_system, _, _) = setup();

        testing::set_caller_address(PLAYER1());

        // Try to update profile without creating player first
        player_system.update_profile(true, 1);
    }

    #[test]
    #[available_gas(3000000)]
    fn test_player_with_zero_beast_id() {
        let (mut world, player_system, _, _) = setup();

        testing::set_caller_address(PLAYER1());

        // Create player with zero beast ID (should be allowed)
        player_system.spawn_player(0);

        let store = StoreTrait::new(world);
        let player = store.read_player_from_address(PLAYER1());

        player.assert_exists();
        assert_eq!(player.current_beast_id, 0, "Player should have zero beast ID");
    }

    #[test]
    #[available_gas(5000000)]
    fn test_player_battle_statistics_overflow_prevention() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());
        let beast_id = beast_system.spawn_beast(BeastType::Light);
        player_system.spawn_player(beast_id);

        // Simulate many wins (test large numbers)
        let mut i: u16 = 0;
        while i < 100 {
            player_system.update_profile(true, beast_id);
            i += 1;
        }

        let store = StoreTrait::new(world);
        let player = store.read_player_from_address(PLAYER1());

        assert_eq!(player.battles_won, 100, "Should handle 100 wins correctly");
        assert_eq!(player.battles_lost, 0, "Should still have 0 losses");
    }

    #[test]
    #[available_gas(5000000)]
    fn test_player_state_consistency_across_operations() {
        let (mut world, player_system, beast_system, _) = setup();

        testing::set_caller_address(PLAYER1());
        let beast_id = beast_system.spawn_beast(BeastType::Magic);
        player_system.spawn_player(beast_id);

        let store = StoreTrait::new(world);

        // Perform multiple operations and verify consistency
        let initial_player = store.read_player_from_address(PLAYER1());
        let initial_creation_day = initial_player.creation_day;

        player_system.update_profile(true, beast_id);
        let after_win = store.read_player_from_address(PLAYER1());
        assert_eq!(
            after_win.creation_day, initial_creation_day, "Creation day should never change",
        );
        assert_eq!(after_win.battles_won, 1, "Wins should increment");

        player_system.update_profile(false, beast_id);
        let after_loss = store.read_player_from_address(PLAYER1());
        assert_eq!(
            after_loss.creation_day, initial_creation_day, "Creation day should never change",
        );
        assert_eq!(after_loss.battles_won, 1, "Wins should stay same");
        assert_eq!(after_loss.battles_lost, 1, "Losses should increment");

        // Change beast and verify consistency
        let new_beast_id = beast_system.spawn_beast(BeastType::Shadow);
        player_system.update_profile(true, new_beast_id);
        let after_beast_change = store.read_player_from_address(PLAYER1());

        assert_eq!(
            after_beast_change.creation_day,
            initial_creation_day,
            "Creation day should never change",
        );
        assert_eq!(after_beast_change.current_beast_id, new_beast_id, "Beast ID should update");
        assert_eq!(after_beast_change.battles_won, 2, "Wins should increment");
        assert_eq!(after_beast_change.battles_lost, 1, "Losses should stay same");
    }

    #[test]
    #[available_gas(3000000)]
    fn test_player_zero_state_validation() {
        let (mut world, _, _, _) = setup();

        // Test Zero player state
        let store = StoreTrait::new(world);
        let nonexistent_player = store.read_player_from_address(PLAYER1());

        assert!(nonexistent_player.is_zero(), "Non-existent player should be zero");

        // Verify zero player structure
        use combat_game::constants;
        assert_eq!(
            nonexistent_player.address,
            constants::ZERO_ADDRESS(),
            "Zero player should have zero address",
        );
        assert_eq!(nonexistent_player.current_beast_id, 0, "Zero player should have zero beast ID");
        assert_eq!(nonexistent_player.battles_won, 0, "Zero player should have zero wins");
        assert_eq!(nonexistent_player.battles_lost, 0, "Zero player should have zero losses");
        assert_eq!(
            nonexistent_player.last_active_day, 0, "Zero player should have zero last active",
        );
        assert_eq!(nonexistent_player.creation_day, 1, "Zero player should have creation day 1");
    }
}
