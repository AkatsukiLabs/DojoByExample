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

        let (check1, _) = player1;

        // Pick one for a check. The same players cannot be added to the game
        if check1.is_non_zero() {
            assert(!validate_players(player1, player2), 'PLAYERS/BEASTS ARE THE SAME');
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
            battle_type: init_params.battle_type,
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
        let (player_ref, beast) = player;
        assert(player_ref.is_non_zero() && beast.is_non_zero(), 'INVALID PLAYER PARAMS');
        let (player1, _) = self.player1;
        let (player2, _) = self.player2;

        assert(player1.is_zero() || player2.is_zero(), 'MAX NO. OF PLAYERS REACHED');
        if player1.is_zero() {
            self.player1 = (player_ref, beast);
            self.current_turn = player_ref;
        } else if player2.is_zero() {
            // only validate when player count is > 1
            assert(!validate_players(self.player1, player), 'PLAYER/BEAST ALREADY EXISTS');
            self.player2 = (player_ref, beast);
        }
    }

    fn start(ref self: Battle) {
        assert(self.state == Default::default(), 'BATTLE NOT PENDING');
        let (player1, _) = self.player1;
        let (player2, _) = self.player2;
        assert(player1.is_non_zero() && player2.is_non_zero(), 'INSUFFICIENT NUMBER OF PLAYERS');

        if self.current_turn == Zero::zero() {
            self.current_turn = player1;
        }
        self.battle_timestamp = starknet::get_block_timestamp();
        self.state = BattleState::ACTIVE;
    }

    fn update(ref self: Battle) {
        assert(self.state == BattleState::ACTIVE, 'BATTLE NOT ACTIVE');
        // update both the last action and the current turn
        self.last_action_timestamp = starknet::get_block_timestamp();
        let (player1, _) = self.player1;
        let (player2, _) = self.player2;
        self
            .current_turn =
                if self.current_turn == player1 {
                    player2
                } else {
                    player1
                }; // should work
    }

    // for tournament
    fn sub_player(ref self: Battle, player: (ContractAddress, u256), pos: u8) {
        assert(self.state == BattleState::ACTIVE, 'BATTLE NOT ACTIVE');
        assert(self.battle_type == BattleType::TOURNAMENT, 'SUB FAILED. NOT TOURNAMENT');
        assert(pos < 2, 'INVALID POSITION');

        assert(
            !validate_players(player, self.player1) && !validate_players(player, self.player2),
            'PLAYER/BEAST ALREADY IN BATTLE',
        );
        match pos {
            0 => self.player1 = player,
            _ => self.player2 = player,
        };
    }

    fn resolve_battle(ref self: Battle, winner_id: ContractAddress) {
        assert(self.state == BattleState::ACTIVE, 'BATTLE NOT ACTIVE');
        let (player1, _) = self.player1;
        let (player2, _) = self.player2;
        assert(winner_id == player1 || winner_id == player2, 'PLAYER NOT IN BATTLE');
        self.winner_id = Option::Some(winner_id);
        self.state = BattleState::FINISHED;
        self.current_turn = Zero::zero();
    }
}

fn validate_players(player1: (ContractAddress, u256), player2: (ContractAddress, u256)) -> bool {
    let (check1, beast1) = player1;
    let (check2, beast2) = player2;

    check1 == check2 || beast1 == beast2
}
