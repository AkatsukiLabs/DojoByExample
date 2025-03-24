#[cfg(test)]
mod tests {
    use dojo_starter::models::battle::{Battle, BattleParams, BattleTrait, BattleType, BattleState};
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
