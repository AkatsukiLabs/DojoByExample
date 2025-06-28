#[cfg(test)]
mod battle_system {
    use dojo_cairo_test::{
        ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
        spawn_test_world,
    };
    use dojo::world::{WorldStorage, WorldStorageTrait};
    use dojo::model::{ModelStorage};
    use combat_game::systems::battle::{battle_system, IBattleDispatcher, IBattleDispatcherTrait};
    use combat_game::models::{
        player::{Player, m_Player}, battle::{Battle, m_Battle, BattleTrait}, beast::{m_Beast},
        beast_stats::{m_BeastStats}, beast_skill::{m_BeastSkill}, skill::{m_Skill}, skill,
    };
    use combat_game::types::{
        battle_status::BattleStatus, beast_type::BeastType, status_condition::StatusCondition,
    };
    use combat_game::store::{StoreTrait};

    use starknet::{contract_address_const, ContractAddress};
    use starknet::{testing};
    use core::num::traits::zero::Zero;

    // Constants for testing
    const BATTLE_TYPE: u8 = 0;
    const BEAST_ID_1: u16 = 1;
    const BEAST_ID_2: u16 = 2;

    fn PLAYER1() -> ContractAddress {
        contract_address_const::<0x1234>()
    }
    fn PLAYER2() -> ContractAddress {
        contract_address_const::<0x5678>()
    }

    pub fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "combat_game",
            resources: [
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Model(m_Battle::TEST_CLASS_HASH),
                TestResource::Model(m_Beast::TEST_CLASS_HASH),
                TestResource::Model(m_BeastStats::TEST_CLASS_HASH),
                TestResource::Model(m_BeastSkill::TEST_CLASS_HASH),
                TestResource::Model(m_Skill::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_BattleCreated::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_BattleJoined::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_AttackExecuted::TEST_CLASS_HASH),
                TestResource::Event(battle_system::e_BattleEnded::TEST_CLASS_HASH),
                TestResource::Event(achievement::events::index::e_TrophyCreation::TEST_CLASS_HASH),
                TestResource::Event(
                    achievement::events::index::e_TrophyProgression::TEST_CLASS_HASH,
                ),
                TestResource::Contract(battle_system::TEST_CLASS_HASH),
            ]
                .span(),
        };

        ndef
    }

    pub fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"combat_game", @"battle_system")
                .with_writer_of([dojo::utils::bytearray_hash(@"combat_game")].span()),
        ]
            .span()
    }

    pub fn setup() -> (WorldStorage, IBattleDispatcher) {
        let ndef = namespace_def();
        let mut world: WorldStorage = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"battle_system").unwrap();
        let battle_system = IBattleDispatcher { contract_address };

        (world, battle_system)
    }

    fn setup_players_and_beasts(mut world: WorldStorage) {
        let mut store = StoreTrait::new(world);

        // Create player 1
        testing::set_caller_address(PLAYER1());
        let mut player1 = store.new_player();
        player1.current_beast_id = BEAST_ID_1.into();
        store.write_player(player1);

        // Create beast for player 1
        let _beast1 = store.new_beast(BEAST_ID_1, BeastType::Light);
        store.init_beast_skills(BEAST_ID_1);
        let _beast1_stats = store
            .new_beast_stats(BEAST_ID_1, 100, 100, 50, 30, 40, 90, 80, StatusCondition::None);

        // Create player 2
        testing::set_caller_address(PLAYER2());
        let mut player2 = store.new_player();
        player2.current_beast_id = BEAST_ID_2.into();
        store.write_player(player2);

        // Create beast for player 2
        let _beast2 = store.new_beast(BEAST_ID_2, BeastType::Shadow);
        store.init_beast_skills(BEAST_ID_2);
        let _beast2_stats = store
            .new_beast_stats(BEAST_ID_2, 100, 100, 45, 35, 35, 85, 75, StatusCondition::None);
    }

    fn setup_active_battle(mut world: WorldStorage, battle_system: IBattleDispatcher) -> u256 {
        // Setup players and beasts
        setup_players_and_beasts(world);

        // Create battle
        testing::set_contract_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        // Join battle to make it active
        testing::set_contract_address(PLAYER2());
        battle_system.join_battle(battle_id);

        battle_id
    }

    fn setup_players_without_beasts(mut world: WorldStorage) {
        let mut store = StoreTrait::new(world);

        // Create player 1
        testing::set_caller_address(PLAYER1());
        store.new_player();

        // Create player 2
        testing::set_caller_address(PLAYER2());
        store.new_player();
    }

    fn get_player_skill(player: ContractAddress, current_player: bool) -> u256 {
        if player == PLAYER1() && current_player {
            skill::SLASH_SKILL_ID
        } else {
            skill::SMASH_SKILL_ID
        }
    }

    #[test]
    fn test_create_battle_success() {
        // Create test environment
        let (mut world, battle_system) = setup();

        // Setup players and beasts
        setup_players_and_beasts(world);

        // Set the caller address for the test
        testing::set_contract_address(PLAYER1());
        testing::set_block_timestamp(1000);

        // Create a battle
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        // Verify the battle was created correctly
        let battle: Battle = world.read_model((battle_id));

        assert(battle.id == battle_id, 'Battle ID should match');
        assert(battle.player1 == PLAYER1(), 'Player 1 should match');
        assert(battle.player2 == PLAYER2(), 'Player 2 should match');
        assert(battle.status == BattleStatus::Waiting, 'Battle should be waiting');
        assert(battle.battle_type == BATTLE_TYPE, 'Battle type should match');
        assert(battle.winner_id == Zero::zero(), 'Winner should be unset');
        assert(battle.timestamp_start > 0, 'Start timestamp should be set');
    }

    #[test]
    #[should_panic(expected: ("Cannot battle yourself", 'ENTRYPOINT_FAILED'))]
    fn test_create_battle_self_battle() {
        // Create test environment
        let (mut world, battle_system) = setup();

        // Setup players
        setup_players_and_beasts(world);

        // Set the caller address
        testing::set_contract_address(PLAYER1());

        // Try to create a battle against yourself
        battle_system.create_battle(PLAYER1(), BATTLE_TYPE);
    }

    #[test]
    fn test_join_battle_success() {
        // Create test environment
        let (mut world, battle_system) = setup();

        testing::set_block_timestamp(50);

        // Setup players and beasts
        setup_players_and_beasts(world);

        // Create a battle as player 1
        testing::set_contract_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        testing::set_block_timestamp(100);

        // Join the battle as player 2
        testing::set_contract_address(PLAYER2());
        battle_system.join_battle(battle_id);

        // Verify the battle is now active
        let battle: Battle = world.read_model((battle_id));
        assert(battle.status == BattleStatus::Active, 'Battle should be active');
        assert(
            battle.timestamp_last_action > battle.timestamp_start, 'Last action should be updated',
        );
    }

    #[test]
    #[should_panic(expected: ("Player 1 has no beast selected", 'ENTRYPOINT_FAILED'))]
    fn test_join_battle_without_beast() {
        // Create test environment
        let (mut world, battle_system) = setup();

        testing::set_block_timestamp(50);

        // Setup players without beasts
        setup_players_without_beasts(world);

        // Create a battle as player 1
        testing::set_contract_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        testing::set_block_timestamp(100);

        // Join the battle as player 2
        testing::set_contract_address(PLAYER2());
        battle_system.join_battle(battle_id);

        // Verify the battle is now active
        let battle: Battle = world.read_model((battle_id));
        assert(battle.status == BattleStatus::Active, 'Battle should be active');
        assert(
            battle.timestamp_last_action > battle.timestamp_start, 'Last action should be updated',
        );
    }

    #[test]
    #[should_panic(expected: ("Battle is not waiting for players", 'ENTRYPOINT_FAILED'))]
    fn test_join_battle_when_active() {
        // Create test environment
        let (mut world, battle_system) = setup();

        setup_active_battle(world, battle_system);

        testing::set_contract_address(PLAYER1());
        battle_system.join_battle(1);
    }

    #[test]
    #[should_panic(expected: ('Not a battle participant', 'ENTRYPOINT_FAILED'))]
    fn test_join_battle_non_participant() {
        // Create test environment
        let (mut world, battle_system) = setup();

        // Setup players
        setup_players_and_beasts(world);

        // Create a battle between player 1 and player 2
        testing::set_contract_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        // A different player try to join
        let other_player = contract_address_const::<0x333>();
        testing::set_contract_address(other_player);
        battle_system.join_battle(battle_id);
    }

    #[test]
    #[should_panic(expected: ("Player 1 has no beast selected", 'ENTRYPOINT_FAILED'))]
    fn test_join_battle_no_beast_fails() {
        // Create test environment
        let (mut world, battle_system) = setup();
        let mut store = StoreTrait::new(world);

        // Setup players without beasts
        testing::set_caller_address(PLAYER1());
        store.new_player();
        testing::set_caller_address(PLAYER2());
        store.new_player();

        // Create a battle
        testing::set_contract_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        // Try to join without having beasts
        testing::set_contract_address(PLAYER2());
        battle_system.join_battle(battle_id);
    }

    #[test]
    fn test_attack_success() {
        // Create test environment
        let (mut world, battle_system) = setup();

        // Setup players, beasts, and active battle
        let battle_id = setup_active_battle(world, battle_system);

        // Get the battle to see whose turn it is
        let battle: Battle = world.read_model((battle_id));
        let current_player = battle.current_turn;

        // Get the player's skill
        let skill = get_player_skill(current_player, true);

        // Set caller to current turn player
        testing::set_contract_address(current_player);

        // Execute an attack
        let (damage, _, _) = battle_system.attack(battle_id, skill);

        // Verify attack results
        assert(damage > 0, 'Damage should be dealt');

        // Verify battle state was updated
        let updated_battle: Battle = world.read_model((battle_id));
        assert(updated_battle.current_turn != current_player, 'Turn should switch');
    }

    #[test]
    #[should_panic(expected: ("It's not your turn", 'ENTRYPOINT_FAILED'))]
    fn test_attack_wrong_turn() {
        // Create test environment
        let (mut world, battle_system) = setup();

        // Setup active battle
        let battle_id = setup_active_battle(world, battle_system);

        // Get the battle to see whose turn it is
        let battle: Battle = world.read_model((battle_id));
        let current_player = battle.current_turn;
        let other_player = if current_player == PLAYER1() {
            PLAYER2()
        } else {
            PLAYER1()
        };

        // Try to attack when it's not your turn
        testing::set_contract_address(other_player);
        let skill = get_player_skill(other_player, false);
        battle_system.attack(battle_id, skill);
    }

    #[test]
    fn test_end_battle_success() {
        // Create test environment
        let (mut world, battle_system) = setup();

        testing::set_block_timestamp(1000);

        // Setup active battle
        let battle_id = setup_active_battle(world, battle_system);

        // End the battle manually as player 1
        testing::set_contract_address(PLAYER1());
        battle_system.end_battle(battle_id, PLAYER1());

        // Verify battle is finished
        let battle: Battle = world.read_model((battle_id));
        assert(battle.status == BattleStatus::Finished, 'Battle should be finished');
        assert(battle.winner_id == PLAYER1(), 'Winner should be set');

        // Verify player stats were updated
        let winner_player: Player = world.read_model((PLAYER1()));
        assert(winner_player.battles_won > 0, 'Winner should have battle won');
    }

    #[test]
    #[should_panic(expected: ("Winner must be a battle participant", 'ENTRYPOINT_FAILED'))]
    fn test_end_battle_invalid_participant() {
        // Create test environment
        let (mut world, battle_system) = setup();

        // Setup active battle
        let battle_id = setup_active_battle(world, battle_system);

        // Try to end battle with invalid participant
        testing::set_contract_address(PLAYER1());
        let invalid_participant = contract_address_const::<0x999>();
        battle_system.end_battle(battle_id, invalid_participant);
    }

    #[test]
    fn test_multiple_battles() {
        // Create test environment
        let (mut world, battle_system) = setup();

        testing::set_block_timestamp(1000);

        // Setup players
        setup_players_and_beasts(world);

        // Create multiple battles
        testing::set_contract_address(PLAYER1());
        let battle_id_1 = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);
        let battle_id_2 = battle_system.create_battle(PLAYER2(), 1);

        // Verify battles have different IDs
        assert(battle_id_1 != battle_id_2, 'Battle IDs should be different');

        // Verify both battles exist
        let battle_1: Battle = world.read_model((battle_id_1));
        let battle_2: Battle = world.read_model((battle_id_2));

        assert(battle_1.id == battle_id_1, 'Battle 1 ID should match');
        assert(battle_2.id == battle_id_2, 'Battle 2 ID should match');
        assert(battle_1.battle_type == BATTLE_TYPE, 'Battle 1 type should match');
        assert!(battle_2.battle_type == 1, "Battle 2 type should be different");
    }

    #[test]
    fn test_complete_battle_flow() {
        // Create test environment
        let (mut world, battle_system) = setup();

        testing::set_block_timestamp(1000);

        // Setup players and beasts
        setup_players_and_beasts(world);

        // Create battle
        testing::set_contract_address(PLAYER1());
        let battle_id = battle_system.create_battle(PLAYER2(), BATTLE_TYPE);

        // Verify initial state
        let battle: Battle = world.read_model((battle_id));
        assert(battle.status == BattleStatus::Waiting, 'Should start as waiting');

        // Join battle
        testing::set_contract_address(PLAYER2());
        battle_system.join_battle(battle_id);

        // Verify active state
        let mut battle: Battle = world.read_model((battle_id));
        assert(battle.status == BattleStatus::Active, 'Should be active after join');

        // Execute some attacks
        let mut turn_count: u8 = 0;
        while turn_count < 3 { // Simulate a few turns
            let mut battle: Battle = world.read_model((battle_id));
            if battle.is_finished() {
                break;
            }

            let current_player = battle.current_turn;
            testing::set_contract_address(current_player);

            let skill = get_player_skill(current_player, true);
            let (damage, _, _) = battle_system.attack(battle_id, skill);

            assert(damage > 0, 'Should deal damage');
            turn_count += 1;
        };

        // End battle manually if not finished
        let mut battle: Battle = world.read_model((battle_id));
        if !battle.is_finished() {
            testing::set_contract_address(PLAYER1());
            battle_system.end_battle(battle_id, PLAYER1());
        }

        // Verify final state
        let final_battle: Battle = world.read_model((battle_id));
        assert(final_battle.status == BattleStatus::Finished, 'Should be finished');
        assert(!final_battle.winner_id.is_zero(), 'Should have a winner');
    }
}
