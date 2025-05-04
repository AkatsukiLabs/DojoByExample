use dojo::{model::ModelStorage, world::WorldStorage};
use core::num::traits::zero::Zero;
use combat_game::{
    helpers::pseudo_random::PseudoRandom::generate_random_u8,
    constants::SECONDS_PER_DAY,
    models::{player::Player, beast::Beast, skill::Skill, beast_skill::BeastSkill, beast_stats::BeastStats, battle::Battle},
    types::{beast_type::BeastType, skill::SkillType, status_condition::StatusCondition, battle_status::BattleStatus},
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
    fn init_beast_attacks(ref self: Store, beast_type: BeastType) {
        match beast_type {
            BeastType::Light => {},
            BeastType::Magic => {},
            BeastType::Shadow => {},
            _ => {
                panic!(
                    "[Store] - BeastType `{}` cannot be initialize.", beast_type);
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

    fn new_skill(ref self: Store, id: u256, power: u16, skill_type: SkillType, min_level_required: u8) -> Skill {
        let skill = Skill {
            id,
            power,
            skill_type,
            min_level_required
        };
        self.world.write_model(@skill);
        skill
    }

    fn new_beast(ref self: Store, beast_id: u16, beast_type: BeastType) -> Beast {
        let beast = Beast {
            player: starknet::get_caller_address(),
            beast_id,
            level: 1,
            experience: Zero::zero(),
            beast_type: beast_type,
        };
        self.world.write_model(@beast);
        beast
    }

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

    // I think that BattleType enum is missing
    // TODO: Use pseudo-random for initial turn
    fn new_battle(
        ref self: Store,
        battle_id: u256,
        player1: ContractAddress,
        player2: ContractAddress,
        battle_type: u8,
    ) -> Battle {
        let players = array![player1, player2];
        let battle = Battle {
            id: battle_id,
            player1,
            player2,
            current_turn: *players.at(generate_random_u8(battle_id.try_into().unwrap(), 0, 0, players.len().try_into().unwrap()).into()),,
            status: Into::<BattleStatus, u8>::into(BattleStatus::Waiting),
            winner_id: Zero::zero(),
            battle_type: battle_type,
        };
        self.world.write_model(@battle);
        battle
    }

    fn create_rematch(ref self: Store, battle_id: u256) -> Battle {
        let battle = self.read_battle(battle_id);
        let players = array![battle.player1, battle.player2];
        
        let rematch = Battle {
            id: battle_id,
            player1: battle.player1,
            player2: battle.player2,
            current_turn: *players.at(generate_random_u8(battle_id.try_into().unwrap(), 0, 0, players.len().try_into().unwrap()).into()),
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

    fn read_skill(self: @Store, skill_id: u16) -> Skill {
        self.world.read_model((skill_id))
    }

    fn read_beast_skill(self: @Store, beast_id: u16) -> BeastSkill {
        self.world.read_model((beast_id))
    }

    fn read_beast(self: @Store, beast_id: u16) -> Beast {
        self.world.read_model((starknet::get_caller_address(), beast_id))
    }

    // TODO: Ask about this one
    fn read_ai_beast(self: @Store) {}

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

    fn write_skill(ref self: Store, skill: Skill) {
        self.world.write_model(@skill)
    }

    fn write_beast_skills(ref self: Store, beast_skill: BeastSkill) {
        self.world.write_model(@beast_skill)
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
