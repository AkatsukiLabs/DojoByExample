use combat_game::types::beast_type::BeastType;
use combat_game::models::beast_stats::BeastStats;

#[starknet::interface]
pub trait IBeast<T> {
    fn spawn_beast(ref self: T, beast_type: BeastType) -> u16;
    fn level_up_beast(ref self: T, beast_id: u16);
    fn update_beast_stats(ref self: T, beast_stats: BeastStats);
}

#[dojo::contract]
pub mod beast_system {
    use super::{IBeast, BeastType, BeastStats};
    use starknet::get_block_timestamp;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use combat_game::store::{StoreTrait};
    use combat_game::models::beast_stats::BeastStatsActionTrait;

    #[storage]
    struct Storage {
        beast_counter: u16,
    }

    // Constructor
    fn dojo_init(ref self: ContractState) {
        self.beast_counter.write(1);
    }

    #[abi(embed_v0)]
    impl BeastImpl of IBeast<ContractState> {
        fn spawn_beast(ref self: ContractState, beast_type: BeastType) -> u16 {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let beast_id = self.beast_counter.read();
            self.beast_counter.write(beast_id + 1);

            let beast = store.new_beast(beast_id, beast_type);
            store.init_beast_skills(beast_id);

            let beast_stats = BeastStatsActionTrait::new_beast_stats(
                beast_id, beast_type, beast.level, get_block_timestamp(),
            );
            store.write_beast_stats(beast_stats);
            beast_id
        }

        fn level_up_beast(ref self: ContractState, beast_id: u16) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let mut beast = store.read_beast(beast_id);
            assert!(beast.level > 0, "Beast not found");
            let mut beast_stats = store.read_beast_stats(beast_id);

            beast.level += 1;
            beast_stats.level_up(beast.beast_type);

            store.write_beast(beast);
            store.write_beast_stats(beast_stats);
        }

        fn update_beast_stats(ref self: ContractState, beast_stats: BeastStats) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let mut beast = store.read_beast(beast_stats.beast_id);
            assert!(beast.level > 0, "Beast not found");

            store.write_beast_stats(beast_stats);
        }
    }
}
