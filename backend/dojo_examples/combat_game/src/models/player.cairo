use starknet::ContractAddress;
use core::num::traits::zero::Zero;

// Constants imports
use combat_game::constants;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Player {
    #[key]
    pub address: ContractAddress,
    pub current_beast_id: u16,
    pub battles_won: u16,
    pub battles_lost: u16,
    pub last_active_day: u32,
    pub creation_day: u32,
}

#[generate_trait]
pub impl PlayerAssert of AssertTrait {
    #[inline(always)]
    fn assert_exists(self: Player) {
        assert(self.is_non_zero(), 'Player: Does not exist');
    }

    #[inline(always)]
    fn assert_not_exists(self: Player) {
        assert(self.is_zero(), 'Player: Already exist');
    }
}

pub impl ZeroablePlayerTrait of Zero<Player> {
    #[inline(always)]
    fn zero() -> Player {
        Player {
            address: constants::ZERO_ADDRESS(),
            current_beast_id: 0,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 0,
            creation_day: 1,
        }
    }

    #[inline(always)]
    fn is_zero(self: @Player) -> bool {
        *self.address == constants::ZERO_ADDRESS()
    }

    #[inline(always)]
    fn is_non_zero(self: @Player) -> bool {
        !self.is_zero()
    }
}

#[cfg(test)]
mod tests {
    use super::{Player, ZeroablePlayerTrait};
    use combat_game::constants;
    use starknet::{ContractAddress, contract_address_const};

    #[test]
    #[available_gas(1000000)]
    fn test_player_initialization() {
        // Use contract_address_const to create a mock address
        let mock_address: ContractAddress = contract_address_const::<0x123>();
        let initial_beast_id: u16 = 1;

        let player = Player {
            address: mock_address,
            current_beast_id: initial_beast_id,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 0,
            creation_day: 1,
        };

        assert_eq!(
            player.address, mock_address, "Player address should match the initialized address",
        );
        assert_eq!(player.current_beast_id, initial_beast_id, "Current beast ID should be 1");
        assert_eq!(player.battles_won, 0, "Battles won should be 0");
        assert_eq!(player.battles_lost, 0, "Battles lost should be 0");
        assert_eq!(player.last_active_day, 0, "Last active day should be 0");
        assert_eq!(player.creation_day, 1, "Creation day should be 1");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_player_initialization_zero_values() {
        let player: Player = ZeroablePlayerTrait::zero();

        assert_eq!(
            player.address,
            constants::ZERO_ADDRESS(),
            "Player address should match the initialized address",
        );
    }

    #[test]
    #[available_gas(1000000)]
    fn test_player_with_zero_beast() {
        let mock_address: ContractAddress = contract_address_const::<0x456>();

        let player = Player {
            address: mock_address,
            current_beast_id: 0,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 0,
            creation_day: 1,
        };

        assert_eq!(player.current_beast_id, 0, "Initial beast ID should be 0 for new player");
    }

    #[test]
    #[available_gas(1000000)]
    fn test_player_address_uniqueness() {
        let address1: ContractAddress = contract_address_const::<0x123>();
        let address2: ContractAddress = contract_address_const::<0x456>();

        let player1 = Player {
            address: address1,
            current_beast_id: 1,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 0,
            creation_day: 1,
        };

        let player2 = Player {
            address: address2,
            current_beast_id: 2,
            battles_won: 0,
            battles_lost: 0,
            last_active_day: 0,
            creation_day: 1,
        };

        assert!(player1.address != player2.address, "Players should have unique addresses");
    }
}

