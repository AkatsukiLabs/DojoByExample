use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Player {
    #[key]
    address: ContractAddress,
    arena: felt252, // TODO: Change to Arena enum when added
    current_beast: felt252, // TODO: Change to the BeastType enum when added
    exists: bool,
    trophies: usize,
}

trait PlayerTrait {
    fn exists(self: @Player) -> bool;
    fn get_current_arena(
        self: @Player,
    ) -> felt252; // TODO: Change return type to Arena enum when added
    fn get_current_beast(
        self: @Player,
    ) -> felt252; // TODO: Change return type to BeastType enum when added
    fn get_trophies(self: @Player) -> usize;
}

impl PlayerImpl of PlayerTrait {
    fn exists(self: @Player) -> bool {
        *self.exists
    }

    fn get_current_arena(self: @Player) -> felt252 {
        *self.arena
    }

    fn get_current_beast(self: @Player) -> felt252 {
        *self.current_beast
    }

    fn get_trophies(self: @Player) -> usize {
        *self.trophies
    }
}
