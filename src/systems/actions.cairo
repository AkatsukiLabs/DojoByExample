#[starknet::interface]
pub trait IActions<T> {
    fn spawn(ref self: T);
}

#[dojo::contract]
pub mod actions {
    use super::IActions;
    
    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Implementation will go here
        }
    }
}