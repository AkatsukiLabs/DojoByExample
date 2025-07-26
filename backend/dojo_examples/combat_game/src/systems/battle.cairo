#[starknet::interface]
pub trait IBattle<T> {
    fn create_battle(ref self: T, opponent: starknet::ContractAddress, battle_type: u8) -> u256;
    fn join_battle(ref self: T, battle_id: u256);
    fn attack(ref self: T, battle_id: u256, skill_id: u256) -> (u16, bool, bool);
    fn end_battle(ref self: T, battle_id: u256, winner: starknet::ContractAddress);
}

#[dojo::contract]
pub mod battle_system {
    use super::IBattle;
    use combat_game::store::{StoreTrait};
    use combat_game::models::{battle::{BattleTrait}, player::{AssertTrait}};
    use combat_game::types::battle_status::BattleStatus;
    use combat_game::achievements::achievement::{Achievement, AchievementTrait};

    use starknet::{get_caller_address, get_block_timestamp, ContractAddress};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use core::num::traits::zero::Zero;

    use achievement::components::achievable::AchievableComponent;
    use achievement::store::{StoreTrait as AchievementStoreTrait, Store as AchievementStore};
    component!(path: AchievableComponent, storage: achievable, event: AchievableEvent);
    impl AchievableInternalImpl = AchievableComponent::InternalImpl<ContractState>;

    use dojo::event::EventStorage;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        achievable: AchievableComponent::Storage,
        battle_counter: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        AchievableEvent: AchievableComponent::Event,
    }

    #[derive(Drop, Copy, Serde)]
    #[dojo::event]
    pub struct BattleCreated {
        #[key]
        pub battle_id: u256,
        #[key]
        pub player1: ContractAddress,
        pub opponent: ContractAddress,
        pub battle_type: u8,
    }

    #[derive(Drop, Copy, Serde)]
    #[dojo::event]
    pub struct BattleJoined {
        #[key]
        pub battle_id: u256,
        #[key]
        pub player2: ContractAddress,
        pub timestamp: u64,
    }

    #[derive(Drop, Copy, Serde)]
    #[dojo::event]
    pub struct AttackExecuted {
        #[key]
        pub battle_id: u256,
        #[key]
        pub attacker: ContractAddress,
        pub attacker_beast_id: u16,
        pub defender_beast_id: u16,
        pub skill_id: u256,
        pub damage_dealt: u16,
    }

    #[derive(Drop, Copy, Serde)]
    #[dojo::event]
    pub struct BattleEnded {
        #[key]
        pub battle_id: u256,
        #[key]
        pub winner: ContractAddress,
        pub timestamp: u64,
    }

    // Constructor
    fn dojo_init(ref self: ContractState) {
        self.battle_counter.write(1);
    }

    #[abi(embed_v0)]
    impl BattleImpl of IBattle<ContractState> {
        fn create_battle(
            ref self: ContractState, opponent: ContractAddress, battle_type: u8,
        ) -> u256 {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let caller = get_caller_address();

            // Validate that caller is not trying to battle themselves
            assert!(caller != opponent, "Cannot battle yourself");

            // Validate that both players exist
            let player1 = store.read_player_from_address(caller);
            let player2 = store.read_player_from_address(opponent);
            player1.assert_exists();
            player2.assert_exists();

            // Get next battle ID
            let battle_id = self.battle_counter.read();

            // Create battle
            let _battle = store.new_battle(battle_id, caller, opponent, battle_type);

            // Increment battle counter
            self.battle_counter.write(battle_id + 1);

            // Emit event
            world.emit_event(@BattleCreated { battle_id, player1: caller, opponent, battle_type });

            battle_id
        }

        // Method to join a battle
        fn join_battle(ref self: ContractState, battle_id: u256) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let caller = get_caller_address();

            // Read the battle
            let mut battle = store.read_battle(battle_id);

            // Validate battle is in waiting status
            assert!(battle.status == BattleStatus::Waiting, "Battle is not waiting for players");

            // Validate caller is one of the battle participants
            assert(
                caller == battle.player1 || caller == battle.player2, 'Not a battle participant',
            );

            // Validate both players have beasts
            let player1 = store.read_player_from_address(battle.player1);
            let player2 = store.read_player_from_address(battle.player2);
            assert!(player1.current_beast_id != Zero::zero(), "Player 1 has no beast selected");
            assert!(player2.current_beast_id != Zero::zero(), "Player 2 has no beast selected");

            // Update battle status to active
            battle.status = BattleStatus::Active;
            battle.update_timestamp();

            // Save updated battle
            store.write_battle(battle);

            // Emit event
            world
                .emit_event(
                    @BattleJoined { battle_id, player2: caller, timestamp: get_block_timestamp() },
                );
        }

        fn attack(ref self: ContractState, battle_id: u256, skill_id: u256) -> (u16, bool, bool) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);
            let achievement_store = AchievementStoreTrait::new(world);

            let caller = get_caller_address();

            // Read the battle
            let mut battle = store.read_battle(battle_id);

            // Validate battle is active
            assert!(battle.is_active(), "Battle is not active");

            // Validate it's the caller's turn
            assert!(battle.current_turn == caller, "It's not your turn");

            // Validate caller is a participant
            assert(caller == battle.player1 || caller == battle.player2, 'Non battle participant');

            // Get attacker and defender
            let mut attacker: ContractAddress = Zero::zero();
            let mut defender: ContractAddress = Zero::zero();
            if battle.player1 == caller {
                attacker = battle.player1;
                defender = battle.player2;
            } else {
                attacker = battle.player2;
                defender = battle.player1;
            }

            // Get current beast IDs
            let attacker_beast_id = store.read_player_from_address(attacker).current_beast_id;
            let defender_beast_id = store.read_player_from_address(defender).current_beast_id;

            // Process attack
            let (damage_dealt, is_favored, is_effective) = store
                .process_attack(battle_id, attacker_beast_id, defender_beast_id, skill_id);

            // Update battle timestamp and switch turns
            battle.update_timestamp();
            battle.switch_turn();

            // Save the updated battle
            store.write_battle(battle);

            // Emit attack event
            world
                .emit_event(
                    @AttackExecuted {
                        battle_id,
                        attacker: caller,
                        attacker_beast_id,
                        defender_beast_id,
                        skill_id,
                        damage_dealt,
                    },
                );

            // Check if battle ended
            let mut updated_battle = store.read_battle(battle_id);
            if updated_battle.is_finished() {
                // Progress battle victory achievements for the winner
                let winner_player = store.read_player_from_address(updated_battle.winner_id);

                // Progress through battle achievement tiers based on wins
                let wins = winner_player.battles_won + 1;
                progress_achievements(wins, achievement_store, winner_player.address);

                // Emit battle ended event
                world
                    .emit_event(
                        @BattleEnded {
                            battle_id,
                            winner: updated_battle.winner_id,
                            timestamp: get_block_timestamp(),
                        },
                    );
            }

            (damage_dealt, is_favored, is_effective)
        }

        fn end_battle(ref self: ContractState, battle_id: u256, winner: ContractAddress) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);
            let achievement_store = AchievementStoreTrait::new(world);

            let caller = get_caller_address();

            // Read the battle
            let mut battle = store.read_battle(battle_id);

            // Validate battle is not already finished
            assert!(!battle.is_finished(), "Battle is already finished");

            // Validate caller is a participant
            assert!(
                caller == battle.player1 || caller == battle.player2,
                "You are not a participant in this battle",
            );

            // Validate winner is a participant
            assert!(
                winner == battle.player1 || winner == battle.player2,
                "Winner must be a battle participant",
            );

            // End the battle
            battle.end(winner);

            // Update player battle results
            store.update_player_battle_result(won: true);

            // Save the updated battle
            store.write_battle(battle);

            // Progress battle victory achievements for the winner
            let winner_player = store.read_player_from_address(winner);
            let wins = winner_player.battles_won + 1;

            progress_achievements(wins, achievement_store, winner_player.address);

            // Emit event
            world.emit_event(@BattleEnded { battle_id, winner, timestamp: get_block_timestamp() });
        }
    }

    fn progress_achievements(
        wins: u16, achievement_store: AchievementStore, winner: ContractAddress,
    ) {
        if wins >= 1 {
            let achievement: Achievement = Achievement::FirstBlood;
            achievement_store
                .progress(winner.into(), achievement.identifier(), 1, get_block_timestamp());
        }
        if wins >= 5 {
            let achievement: Achievement = Achievement::Warrior;
            achievement_store
                .progress(winner.into(), achievement.identifier(), 1, get_block_timestamp());
        }
        if wins >= 15 {
            let achievement: Achievement = Achievement::Veteran;
            achievement_store
                .progress(winner.into(), achievement.identifier(), 1, get_block_timestamp());
        }
        if wins >= 30 {
            let achievement: Achievement = Achievement::Champion;
            achievement_store
                .progress(winner.into(), achievement.identifier(), 1, get_block_timestamp());
        }
        if wins >= 50 {
            let achievement: Achievement = Achievement::Legend;
            achievement_store
                .progress(winner.into(), achievement.identifier(), 1, get_block_timestamp());
        }
    }
}
