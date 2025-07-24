#[starknet::interface]
pub trait IPlayer<T> {
    fn spawn_player(ref self: T, initial_beast_id: u16);
    fn update_profile(ref self: T, won: bool, current_beast_id: u16);
}

#[dojo::contract]
pub mod player_system {
    use super::IPlayer;

    use combat_game::models::player::{Player, PlayerAssert};
    use combat_game::store::{StoreTrait};

    use starknet::{get_caller_address, get_block_timestamp};

    #[storage]
    struct Storage {
        player_counter: u256,
    }

    // Constructor
    fn dojo_init(ref self: ContractState) {
        self.player_counter.write(1);
    }

    #[abi(embed_v0)]
    impl PlayerImpl of IPlayer<ContractState> {
        fn spawn_player(ref self: ContractState, initial_beast_id: u16) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let found = store.read_player();
            found.assert_not_exists();

            let player = Player {
                address: get_caller_address(),
                current_beast_id: initial_beast_id,
                battles_won: 0,
                battles_lost: 0,
                last_active_day: get_block_timestamp(),
                creation_day: get_block_timestamp(),
            };

            store.write_player(player);
        }

        fn update_profile(ref self: ContractState, won: bool, current_beast_id: u16) {
            let mut world = self.world(@"combat_game");
            let mut store = StoreTrait::new(world);

            let mut player = store.read_player();
            player.assert_exists();

            store.update_player_battle_result(won);
            player.current_beast_id = current_beast_id;
            store.write_player(player);
        }
    }
}
