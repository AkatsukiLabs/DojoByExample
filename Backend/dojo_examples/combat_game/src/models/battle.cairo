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

#[cfg(test)]
mod tests {
    use super::{Battle, BattleParams, BattleTrait, BattleType, BattleState};
    use starknet::{ContractAddress, contract_address_const};
    use core::num::traits::Zero;
    use starknet::testing;

    const ID: u256 = 1;

    fn USER1() -> ContractAddress {
        contract_address_const::<'USER'>()
    }

    fn USER2() -> ContractAddress {
        contract_address_const::<'USER2'>()
    }

    fn init_battle(
        player1: Option<(ContractAddress, u256)>, player2: Option<(ContractAddress, u256)>, t: u8,
    ) -> Battle {
        let battle_type = match t {
            0 => Default::default(),
            _ => BattleType::TOURNAMENT,
        };

        let init_params = BattleParams { player1, player2, battle_type };

        let battle = BattleTrait::new(ID, init_params);
        assert(battle.id == ID, 'WRONG ID');
        if t == 0 {
            assert(battle.battle_type == BattleType::FRIENDLY, 'WRONG BATTLE TYPE');
        }
        assert(battle.state == BattleState::WAITING, 'WRONG BATTLE STATE');
        assert(battle.current_turn.is_zero(), 'WRONG CURRENT TURN');

        battle
    }

    #[test]
    fn test_battle_creation_success() {
        let battle = init_battle(Option::None, Option::None, 0);
        let check = (Zero::zero(), 0);
        assert(battle.player1 == check, 'INIT FAILED');
        assert(battle.player2 == check, 'INIT FAILED');
    }

    #[test]
    #[should_panic(expected: 'PLAYERS/BEASTS ARE THE SAME')]
    fn test_battle_creation_should_panic_on_same_player1_and_player2() {
        let player1 = Option::Some((USER1(), ID));
        let player2 = Option::Some((USER1(), 2));

        init_battle(player1, player2, 0);
    }

    #[test]
    #[should_panic(expected: 'ZERO ADDRESS')]
    fn test_battle_creation_should_panic_on_zero_address_player() {
        let player1 = Option::Some((Zero::zero(), ID));
        init_battle(player1, Option::None, 0);
    }

    #[test]
    #[should_panic(expected: 'INSUFFICIENT NUMBER OF PLAYERS')]
    fn test_battle_start_should_panic_on_insufficient_player_count() {
        let player1 = Option::Some((USER1(), ID));
        let mut battle = init_battle(player1, Option::None, 0);

        battle.start();
    }

    #[test]
    fn test_battle_add_player_successfully() {
        let mut battle = init_battle(Option::None, Option::None, 0);
        let player1 = (USER1(), ID);
        battle.add_player(player1);

        assert(battle.player1 == player1, 'FIRST ADDITION FAILED');
        assert(battle.player2 == (Zero::zero(), 0), 'INCORRECT ADDITION');

        let player2 = (USER2(), ID + 1);
        battle.add_player(player2);
        assert(battle.player2 == player2, 'SECOND ADDITION FAILED');
        assert(battle.current_turn == USER1(), 'TURN CHANGED'); // unchanged

        battle.set_turn(USER2());
        assert(battle.current_turn == USER2(), 'SET TURN FAILED');
    }

    #[test]
    #[should_panic(expected: 'MAX NO. OF PLAYERS REACHED')]
    fn test_battle_add_player_max_player_reached() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);

        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 0);
        let player3 = (contract_address_const::<'USER3'>(), ID + 2);
        battle.add_player(player3);
    }

    #[test]
    fn test_battle_start_success() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 0);
        testing::set_block_timestamp(1000);
        battle.start();

        // should set turn automatically to player1 when started
        assert(battle.current_turn == USER1(), 'WRONG TURN INIT');
        assert(battle.state == BattleState::ACTIVE, 'WRONG BATTLE STATE');
        assert(battle.battle_timestamp == 1000, 'WRONG BATTLE TIMESTAMP');
    }

    #[test]
    fn test_battle_update_success() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 0);
        battle.start();

        assert(battle.current_turn == USER1(), 'WRONG TURN INIT');
        testing::set_block_timestamp(200);
        battle.update();

        assert(battle.last_action_timestamp == 200, 'TIME UPDATE FAILED');
        assert(battle.current_turn == USER2(), 'TURN UPDATE FAILED');

        battle.update();
        assert(battle.current_turn == USER1(), 'BATTLE UPDATE FAILED.');
    }

    #[test]
    #[should_panic(expected: 'BATTLE NOT WAITING')]
    fn test_battle_add_player_should_panic_on_battle_not_waiting() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 0);
        battle.start();

        let player = (contract_address_const::<'USER3'>(), ID + 2);
        battle.add_player(player);
    }

    #[test]
    #[should_panic(expected: 'PLAYER/BEAST ALREADY EXISTS')]
    fn test_battle_add_player_should_panic_on_already_existing_player_or_beast() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID);
        let mut battle = init_battle(Option::None, Option::None, 0);
        battle.add_player(player1);
        battle.add_player(player2);
    }

    #[test]
    #[should_panic(expected: 'PLAYER NOT IN BATTLE')]
    fn test_battle_set_turn_for_non_existent_player() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 0);

        let player = contract_address_const::<'USER3'>();
        battle.set_turn(player);
    }

    #[test]
    #[should_panic(expected: 'SUB FAILED. NOT TOURNAMENT')]
    fn test_battle_sub_player_on_non_tournament() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 0);
        battle.start();

        let player = (contract_address_const::<'USER3'>(), ID + 3);
        battle.sub_player(player, 0);
    }

    #[test]
    fn test_battle_sub_player_success() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 1);
        battle.start();

        assert(battle.player1 == player1, 'INIT FAILED');
        let player = (contract_address_const::<'USER3'>(), ID + 2);
        battle.sub_player(player, 0);

        // player at 0 is  battle.player1
        // player1 no longer in game
        assert(battle.player1 == player, 'BATTLE SUB FAILED');

        // sub player1 for player2
        battle.sub_player(player1, 1);
        assert(battle.player2 == player1, 'BATTLE SUB FAILED.');
    }

    #[test]
    #[should_panic(expected: 'PLAYER/BEAST ALREADY IN BATTLE')]
    fn test_battle_sub_player_should_panic_on_existent_player_or_beast() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 1);
        battle.start();

        // Use an existing beast id.
        let player = (contract_address_const::<'USER3'>(), ID + 1);
        battle.sub_player(player, 0);
    }

    #[test]
    fn test_battle_resolve_battle_success() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 1);
        battle.start();

        battle.resolve_battle(USER1());
        assert(battle.state == BattleState::FINISHED, 'WRONG STATE');
        assert(battle.winner_id == Option::Some(USER1()), 'WRONG WINNER');
    }

    #[test]
    #[should_panic(expected: 'PLAYER NOT IN BATTLE')]
    fn test_battle_resolve_battle_should_panic_on_non_existent_player() {
        let player1 = (USER1(), ID);
        let player2 = (USER2(), ID + 1);
        let mut battle = init_battle(Option::Some(player1), Option::Some(player2), 1);
        battle.start();

        let player = contract_address_const::<'USER3'>();
        battle.resolve_battle(player);
    }
}
