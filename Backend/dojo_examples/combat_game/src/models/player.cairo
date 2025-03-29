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

#[cfg(test)]
mod tests {
    use super::{Player, PlayerTrait};

    // Helper function to create a test player
    fn setup_player() -> Player {
        Player {
            address: starknet::contract_address_const::<0x0>(),
            arena: 3,
            current_beast: 7,
            exists: true,
            trophies: 99,
        }
    }

    #[test]
    fn test_exists() {
        let player = setup_player();
        assert!(player.exists(), "Player should exist but does not.");
    }

    #[test]
    fn test_get_current_arena() {
        let player = setup_player();
        assert_eq!(player.get_current_arena(), 3, "Arena ID does not match expected value.");
    }


    #[test]
    fn test_get_current_beast() {
        let player = setup_player();
        assert_eq!(player.get_current_beast(), 7, "Beast ID does not match expected value.");
    }

    #[test]
    fn test_get_trophies() {
        let player = setup_player();
        assert_eq!(player.get_trophies(), 99, "Trophies count does not match expected value.");
    }
}

