use dojo::world::IWorldDispatcher;
use starknet::ContractAddress;

#[dojo::model]
struct Potion {
    #[key]
    id: u32,
    name: felt252,
    description: felt252,
    effect: felt252,
    rarity: u8,
    power: u32,
    price: u128,
    is_magical: bool,
    creation_date: u64,
    creator: ContractAddress
}

#[dojo::contract]
mod PotionsSystem {
    use super::{Potion, IWorldDispatcher, ContractAddress};
    use dojo::world::IWorldDispatcherTrait;
    use starknet::get_caller_address;
    use starknet::timestamp;

    #[abi(embed_v0)]
    impl PotionsImpl of IPotions<ContractState> {
        fn create_potion(
            ref self: ContractState,
            world: IWorldDispatcher,
            name: felt252,
            description: felt252,
            effect: felt252,
            rarity: u8,
            power: u32,
            price: u128,
            is_magical: bool
        ) {
            let caller = get_caller_address();
            let current_time = timestamp();

            let next_id = self.next_id.read() + 1;
            self.next_id.write(next_id);

            let potion = Potion {
                id: next_id,
                name,
                description,
                effect,
                rarity,
                power,
                price,
                is_magical,
                creation_date: current_time,
                creator: caller
            };

            world.set!(Potion, potion);
            self.emit(PotionCreated { id: next_id, creator: caller });
        }
    }

    #[event]
    struct PotionCreated {
        id: u32,
        creator: ContractAddress
    }

    #[storage]
    struct Storage {
        next_id: u32
    }
}

#[starknet::interface]
trait IPotions<TContractState> {
    fn create_potion(
        ref self: TContractState,
        world: IWorldDispatcher,
        name: felt252,
        description: felt252,
        effect: felt252,
        rarity: u8,
        power: u32,
        price: u128,
        is_magical: bool
    );
}