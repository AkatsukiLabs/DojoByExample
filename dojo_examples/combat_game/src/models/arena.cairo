use core::traits::TryInto;
use core::debug::PrintTrait;
use core::Default;
use core::Zeroable;


#[derive(Copy, Drop, Serde, Introspect)]
#[dojo::model]
struct Arena {
    #[key]
    pub id: u32,
    pub name: u32,
    pub minimum_rank: u32,
    pub maximum_rank: u32,
    pub entry_fee: u128,
}

#[generate_trait]
impl ArenaImpl of ArenaTrait {
    #[inline(always)]
    fn new_arena(
        id: u32,
        name: u32,
        minimum_rank: u32,
        maximum_rank: u32,
        entry_fee: u128
    ) -> Arena {
        Arena {
            id,
            name,
            minimum_rank,
            maximum_rank,
            entry_fee,
        }
    }

    fn register_player(ref self: Arena, player_rank: u32, fee_paid: u128) -> bool {
        if player_rank >= self.minimum_rank && player_rank <= self.maximum_rank && fee_paid == self.entry_fee {
            return true;
        }
        return false;
    }
}

impl ZeroableArena of Zeroable<Arena> {
    fn zero() -> Arena {
        Arena {
            id: 0,
            name: 0,
            minimum_rank: 0,
            maximum_rank: 0,
            entry_fee: 0,
        }
    }

    fn is_zero(self: Arena) -> bool {
        self.id == 0 &&
        self.name == 0 &&
        self.minimum_rank == 0 &&
        self.maximum_rank == 0 &&
        self.entry_fee == 0
    }
}

