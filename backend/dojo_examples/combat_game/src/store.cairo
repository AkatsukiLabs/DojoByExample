use dojo::{model::ModelStorage, world::WorldStorage};
use core::num::traits::zero::Zero;
use combat_game::{
    constants::SECONDS_PER_DAY,
    models::{
        player::Player, beast::{Beast, BeastTrait}, skill, skill::{Skill, SkillTrait},
        beast_skill::BeastSkill, beast_stats::{BeastStats, BeastStatsActionTrait},
        battle::{Battle, BattleTrait},
    },
    types::{
        beast_type::BeastType, skill::SkillType, status_condition::StatusCondition,
        battle_status::BattleStatus,
    },
};

use starknet::ContractAddress;

#[derive(Drop, Copy)]
struct Store {
    world: WorldStorage,
}

#[generate_trait]
pub impl StoreImpl of StoreTrait {
    fn new(world: WorldStorage) -> Store {
        Store { world: world }
    }

    // [ Initialization methods ]
    fn init_beast_skills(ref self: Store, beast_id: u16) {
        let beast = self.read_beast(beast_id);
        match beast.beast_type {
            BeastType::Light => {
                self
                    .write_beast_skills(
                        BeastSkill {
                            beast_id,
                            skills_ids: array![
                                skill::BEAM_SKILL_ID,
                                skill::SLASH_SKILL_ID,
                                skill::PIERCE_SKILL_ID,
                                skill::WAVE_SKILL_ID,
                            ]
                                .span(),
                        },
                    );
            },
            BeastType::Magic => {
                self
                    .write_beast_skills(
                        BeastSkill {
                            beast_id,
                            skills_ids: array![
                                skill::BLAST_SKILL_ID,
                                skill::FREEZE_SKILL_ID,
                                skill::BURN_SKILL_ID,
                                skill::PUNCH_SKILL_ID,
                            ]
                                .span(),
                        },
                    );
            },
            BeastType::Shadow => {
                self
                    .write_beast_skills(
                        BeastSkill {
                            beast_id,
                            skills_ids: array![
                                skill::SMASH_SKILL_ID,
                                skill::CRUSH_SKILL_ID,
                                skill::SHOCK_SKILL_ID,
                                skill::KICK_SKILL_ID,
                            ]
                                .span(),
                        },
                    );
            },
            _ => { panic!("[Store] - BeastType `{}` has no skills defined.", beast.beast_type); },
        }
    }

    fn init_skills(ref self: Store) {
        self
            .world
            .write_models(
                array![
                    @Skill {
                        id: skill::SLASH_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Slash),
                        skill_type: SkillType::Slash,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::BEAM_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Beam),
                        skill_type: SkillType::Beam,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::WAVE_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Wave),
                        skill_type: SkillType::Wave,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::PUNCH_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Punch),
                        skill_type: SkillType::Punch,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::KICK_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Kick),
                        skill_type: SkillType::Kick,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::BLAST_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Blast),
                        skill_type: SkillType::Blast,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::CRUSH_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Crush),
                        skill_type: SkillType::Crush,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::PIERCE_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Pierce),
                        skill_type: SkillType::Pierce,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::SMASH_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Smash),
                        skill_type: SkillType::Smash,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::BURN_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Burn),
                        skill_type: SkillType::Burn,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::FREEZE_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Freeze),
                        skill_type: SkillType::Freeze,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::SHOCK_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Shock),
                        skill_type: SkillType::Shock,
                        min_level_required: 1,
                    },
                    @Skill {
                        id: skill::DEFAULT_SKILL_ID,
                        power: SkillTrait::base_damage(SkillType::Default),
                        skill_type: SkillType::Default,
                        min_level_required: 1,
                    },
                ]
                    .span(),
            );
    }

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

    fn new_skill(
        ref self: Store, id: u256, power: u16, skill_type: SkillType, min_level_required: u8,
    ) -> Skill {
        let skill = Skill { id, power, skill_type, min_level_required };
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
            status_condition,
            last_timestamp: starknet::get_block_timestamp(),
        };
        self.world.write_model(@beast_stats);
        beast_stats
    }

    fn new_battle(
        ref self: Store,
        battle_id: u256,
        player1: ContractAddress,
        player2: ContractAddress,
        battle_type: u8,
    ) -> Battle {
        let battle = BattleTrait::new(battle_id, player1, player2, battle_type);
        self.world.write_model(@battle);
        battle
    }

    fn create_rematch(ref self: Store, battle_id: u256) -> Battle {
        let battle = self.read_battle(battle_id);

        let rematch = BattleTrait::new(
            battle_id, battle.player1, battle.player2, battle.battle_type,
        );
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

    fn read_skill(self: @Store, skill_id: u256) -> Skill {
        self.world.read_model((skill_id))
    }

    fn read_beast_skill(self: @Store, beast_id: u16) -> BeastSkill {
        self.world.read_model((beast_id))
    }

    fn read_beast(self: @Store, beast_id: u16) -> Beast {
        self.world.read_model((starknet::get_caller_address(), beast_id))
    }

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
    fn award_battle_experience(ref self: Store, beast_id: u16, exp_amount: u16) -> bool {
        // Read beast and its stats
        let mut beast = self.read_beast(beast_id);

        // Add experience
        beast.experience += exp_amount;

        // Check if level up is needed
        // TODO: ExperienceCalculatorTrait is not implemented
        // let exp_needed = ExperienceTrrait::calculate_exp_needed_for_level(beast.level);
        let exp_needed = 10;
        let level_up_occurred = beast.experience >= exp_needed;

        if level_up_occurred {
            // Calculate remaining exp
            // TODO: ExperienceCalculatorTrait is not implemented
            // beast.experience);
            // beast.experience = ExperienceTrrait::remaining_exp_after_level_up(beast.level,
            beast.experience = 5;
            beast.level += 1;

            // Update beast stats
            let mut beast_stats = self.read_beast_stats(beast_id);
            beast_stats.level_up(beast.beast_type);
            self.write_beast_stats(beast_stats);
        }

        self.write_beast(beast);
        level_up_occurred
    }

    fn is_skill_usable(ref self: Store, beast_id: u16, skill_id: u256) -> bool {
        let beast_skills = self.read_beast_skill(beast_id);
        let mut found = false;
        for beast_skill in beast_skills.skills_ids {
            if beast_skill == @skill_id {
                found = true;
                break;
            }
        };
        found
    }

    fn update_player_battle_result(mut self: Store, won: bool) {
        let mut player = self.read_player();
        if won {
            player.battles_won += 1;
        } else {
            player.battles_lost += 1;
        }
        player
            .last_active_day = (starknet::get_block_timestamp() / SECONDS_PER_DAY)
            .try_into()
            .unwrap();
        self.write_player(player);
    }

    // Process attack in battle
    fn process_attack(
        ref self: Store,
        battle_id: u256,
        attacker_beast_id: u16,
        defender_beast_id: u16,
        skill_id: u256,
    ) -> (u16, bool, bool) {
        let mut battle = self.read_battle(battle_id);
        assert!(
            battle.status == BattleStatus::Active,
            "Battle should be in `Active` status (current `{}`)",
            battle.status,
        );

        assert!(
            self.is_skill_usable(attacker_beast_id, skill_id),
            "Beast {} can't use skill {}",
            attacker_beast_id,
            skill_id,
        );

        // Read beast data
        let mut attacker_beast = self.read_beast(attacker_beast_id);
        let mut defender_beast = self.read_beast(defender_beast_id);

        // Read beast stats
        let mut attacker_stats = self.read_beast_stats(attacker_beast_id);
        let mut defender_stats = self.read_beast_stats(defender_beast_id);

        // Check if attacker can attack
        assert(attacker_stats.can_attack(), 'Beast cannot attack');

        // Calculate damage
        let skill = self.read_skill(skill_id);
        let (damage, is_favored, is_effective) = attacker_beast
            .attack(defender_beast.beast_type, skill.skill_type, 1);
        defender_stats.take_damage(damage);

        // Check if battle is over
        if defender_stats.is_defeated() {
            battle.status = BattleStatus::Finished;
            battle.winner_id = starknet::get_caller_address();

            // Update player stats
            self.update_player_battle_result(won: true);

            // TODO: Define base experience for winning a game
            self.award_battle_experience(attacker_beast_id, 1);
        }

        // Save changes
        self.write_battle(battle);
        self.write_beast_stats(attacker_stats);
        self.write_beast_stats(defender_stats);
        (damage, is_favored, is_effective)
    }
}
