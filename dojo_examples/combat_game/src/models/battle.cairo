use starknet::ContractAddress;
use core::num::traits::Zero;

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct Battle {
    #[key]
    pub id: u256,
    pub player1: (ContractAddress, u256),
    pub player2: (ContractAddress, u256),
    pub current_turn: ContractAddress,
    pub state: BattleState,
    pub winner_id: Option<ContractAddress>,
    pub battle_timestamp: u64,
    pub last_action_timestamp: u64,
    pub battle_type: BattleType,
}

#[derive(Copy, Drop, Debug, Serde, Introspect, Default, PartialEq)]
pub enum BattleState {
    #[default]
    WAITING,
    ACTIVE,
    FINISHED,
}

#[derive(Copy, Drop, Debug, Serde, Introspect, Default, PartialEq)]
pub enum BattleType {
    RANKED,
    #[default]
    FRIENDLY,
    TOURNAMENT,
}

#[derive(Drop, Default)]
pub struct BattleParams {
    pub player1: Option<(ContractAddress, u256)>,
    pub player2: Option<(ContractAddress, u256)>,
    pub battle_type: BattleType,
}

#[generate_trait]
pub impl BattleImpl of BattleTrait {
    fn new(id: u256, init_params: BattleParams) -> Battle {
        // current turn should be a random. but init to zero
        let mut player1 = (Zero::zero(), 0);
        let mut player2 = (Zero::zero(), 0);

        if let Option::Some((player, beast)) = init_params.player1 {
            assert(player.is_non_zero(), 'ZERO ADDRESS');
            assert(beast.is_non_zero(), 'INVALID BEAST ID');
            player1 = (player, beast);
        }

        if let Option::Some((player, beast)) = init_params.player2 {
            assert(player.is_non_zero(), 'ZERO ADDRESS');
            assert(beast.is_non_zero(), 'INVALID BEAST ID');
            player2 = (player, beast);
        }

        Battle {
            id,
            player1,
            player2,
            current_turn: Zero::zero(),
            state: Default::default(),
            winner_id: Option::None,
            battle_timestamp: 0,
            last_action_timestamp: 0,
            battle_type: init_params.battle_type
        }
    }

    fn set_turn(ref self: Battle, player: ContractAddress) {
        assert(self.state == Default::default(), 'BATTLE NOT WAITING');
        let (player1, _) = self.player1;
        let (player2, _) = self.player2;
        assert(player == player1 || player == player2, 'PLAYER NOT IN BATTLE');
        self.current_turn = player;
    }

    fn add_player(ref self: Battle, player: (ContractAddress, u256)) {
        assert(self.state == Default::default(), 'BATTLE NOT WAITING');
        let (player, beast) = player;
        assert(player.is_non_zero() && beast.is_non_zero(), 'INVALID PLAYER PARAMS');
        let (mut player1, mut beast1) = self.player1;
        let (mut player2, mut beast2) = self.player2;

        assert(player1.is_non_zero() && player2.is_non_zero(), 'MAX NO. OF PLAYERS REACHED');
        if player1.is_zero() {
            player1 = player;
            beast1 = beast;
        } else if player2.is_zero() {
            player2 = player;
            beast2 = beast;
        }
    }
}
