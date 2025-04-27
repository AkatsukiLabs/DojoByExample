use dojo::{model::ModelStorage, world::WorldStorage};
use core::num::traits::zero::Zero;
use combat_game::{
    constants::SECONDS_PER_DAY,
    models::{player::Player, beast::Beast, beast_stats::BeastStats, battle::Battle},
    types::{beast::BeastType, status_condition::StatusCondition, battle_status::BattleStatus},
};

use starknet::ContractAddress;

#[derive(Drop)]
struct Store {
    world: WorldStorage,
}

#[generate_trait]
impl StoreImpl of StoreTrait {
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    // [ Initialization methods ]
    // TODO: add attacks based on beast type
    // Blocked: Attacks are not implemented
    fn init_beast_attacks(ref self: Store, beast_type: BeastType) {
        match beast_type {
            BeastType::Fire => {},
            BeastType::Water => {},
            BeastType::Earth => {},
            BeastType::Electric => {},
            BeastType::Dragon => {},
            BeastType::Ice => {},
            BeastType::Magic => {},
            BeastType::Rock => {},
            BeastType::Undefined => {
                panic!(
                    "[ Store ] - BeastType `Undefined (id {})` cannot be initialize.",
                    Into::<BeastType, u8>::into(beast_type),
                );
            },
        }
    }

    // Implementation includes initialization methods
    // Suggestion: Since time will be handled as u64 because the standard, maybe we should change
    // the type of `last_active_day` and `creation_date` to u64
    fn new_player(ref self: Store) -> Player {
        let player = Player {
            address: starknet::get_caller_address(),
            current_beast_id: Zero::zero(),
            battles_won: Zero::zero(),
            battles_lost: Zero::zero(),
            last_active_day: (starknet::get_block_timestamp() / SECONDS_PER_DAY)
                .try_into()
                .unwrap(),
            creation_day: (starknet::get_block_timestamp() / SECONDS_PER_DAY).try_into().unwrap(),
        };
        self.world.write_model(@player);
        player
    }

    // TODO: Not implemented
    fn new_attack(ref self: Store) {}

    // TODO: Should the data for model initializations be sent as a parameter?
    // Maybe consume `beast_id` from an entity like `BeastTracker` to set an autoincrement id?
    fn new_beast(ref self: Store, beast_id: u16, beast_type: BeastType) -> Beast {
        let beast = Beast {
            player: starknet::get_caller_address(),
            beast_id,
            level: 1,
            experience: Zero::zero(),
            beast_type: Into::<BeastType, u8>::into(beast_type),
        };
        self.world.write_model(@beast);
        beast
    }

    // TODO: Should the data for model initializations be sent as a parameter?
    // Is there a reason why `beast_id` in BeastStats is u256
    fn new_beast_stats(
        ref self: Store,
        beast_id: u16,
        max_hp: u16,
        current_hp: u16,
        attack: u16,
        defense: u16,
        speed: u16,
        accuracy: u8,
        evasion: u8,
        status_condition: StatusCondition,
    ) -> BeastStats {
        let beast_stats = BeastStats {
            beast_id: beast_id.into(),
            max_hp,
            current_hp,
            attack,
            defense,
            speed,
            accuracy,
            evasion,
            status_condition: Into::<StatusCondition, u8>::into(status_condition),
            last_timestamp: starknet::get_block_timestamp(),
        };
        self.world.write_model(@beast_stats);
        beast_stats
    }

    // Maybe consume `battle_id` from an entity like `BattleTracker` to set an autoincrement id?
    // I think that BattleType enum is missing
    // TODO: Use pseudo-random for initial turn
    fn new_battle(
        ref self: Store,
        battle_id: u256,
        player1: ContractAddress,
        player2: ContractAddress,
        battle_type: u8,
    ) -> Battle {
        let battle = Battle {
            id: battle_id,
            player1,
            player2,
            current_turn: player1,
            status: Into::<BattleStatus, u8>::into(BattleStatus::Waiting),
            winner_id: Zero::zero(),
            battle_type: battle_type,
        };
        self.world.write_model(@battle);
        battle
    }

    // TODO: Use pseudo-random for initial turn
    fn create_rematch(ref self: Store, battle_id: u256) -> Battle {
        let battle = self.read_battle(battle_id);
        let rematch = Battle {
            id: battle_id,
            player1: battle.player1,
            player2: battle.player2,
            current_turn: battle.player1,
            status: Into::<BattleStatus, u8>::into(BattleStatus::Waiting),
            winner_id: Zero::zero(),
            battle_type: battle.battle_type,
        };
        self.world.write_model(@rematch);
        rematch
    }

    // [ Getter methods ]
    fn read_player(self: @Store) -> Player {
        self.read_player_from_address(starknet::get_caller_address())
    }

    fn read_player_from_address(self: @Store, player_address: ContractAddress) -> Player {
        self.world.read_model((player_address))
    }

    // Blocked: Attacks are not implemented
    fn read_attack(self: @Store, beast_id: u16, attack_id: u16) {
        // self.world.read_model((beast_id, attack_id))
    }

    fn read_beast(self: @Store, beast_id: u16) -> Beast {
        self.world.read_model((starknet::get_caller_address(), beast_id))
    }

    // TODO: Ask about this one
    fn read_ai_beast(self: @Store) {}

    // Is there a reason why `beast_id` in BeastStats is u256
    fn read_beast_stats(self: @Store, beast_id: u16) -> BeastStats {
        self.world.read_model((Into::<u16, u256>::into(beast_id)))
    }

    fn read_battle(self: @Store, battle_id: u256) -> Battle {
        self.world.read_model((battle_id))
    }

    // [ Setter methods ]

    // Implementation includes setter methods:
    fn write_player(ref self: Store, player: Player) {
        self.world.write_model(@player)
    }

    // Blocked: Attacks are not implemented
    fn write_attack(ref self: Store, attack: u32) {// self.world.write_model(@attack)
    }

    fn write_beast(ref self: Store, beast: Beast) {
        self.world.write_model(@beast)
    }

    fn write_beast_stats(ref self: Store, beast_stats: BeastStats) {
        self.world.write_model(@beast_stats)
    }

    fn write_battle(ref self: Store, battle: Battle) {
        self.world.write_model(@battle)
    }

    // [ Game logic methods]

    fn award_battle_experience(ref self: Store) {}
    fn is_attack_usable(ref self: Store) {}
    fn update_player_battle_result(ref self: Store) {}
    fn process_attack(ref self: Store) {}
}
