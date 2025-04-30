#[starknet::interface]
trait IExperienceCalculator<TContractState> {
    fn calculate_experience(ref self: TContractState, level: u32) -> u32;
    fn check_level_up(ref self: TContractState, current_level: u32, current_exp: u32) -> bool;
    fn calculate_remaining_exp(ref self: TContractState, current_level: u32, current_exp: u32) -> u32;
}

#[starknet::contract]
mod ExperienceCalculator {
    use starknet::ContractAddress;
    use zeroable::Zeroable;
    use traits::TryInto;
    use integer::{U256TryIntoFelt252, U256FromFelt252};

    #[storage]
    struct Storage {
        base_exp: u32,
        exp_multiplier: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, base_exp: u32, exp_multiplier: u32) {
        self.base_exp.write(base_exp);
        self.exp_multiplier.write(exp_multiplier);
    }

    #[external(v0)]
    impl ExperienceCalculatorImpl of super::IExperienceCalculator<ContractState> {
        fn calculate_experience(ref self: ContractState, level: u32) -> u32 {
            let base_exp: felt252 = self.base_exp.read().into();
            let exp_multiplier: felt252 = self.exp_multiplier.read().into();
            let level_felt: felt252 = level.into();
            
            // Calculate: base_exp * (level * exp_multiplier)
            let result = base_exp * (level_felt * exp_multiplier);
            
            // Convert back to u32
            result.try_into().unwrap()
        }

        fn check_level_up(ref self: ContractState, current_level: u32, current_exp: u32) -> bool {
            let required_exp = self.calculate_experience(current_level);
            current_exp >= required_exp
        }

        fn calculate_remaining_exp(ref self: ContractState, current_level: u32, current_exp: u32) -> u32 {
            let required_exp = self.calculate_experience(current_level);
            if current_exp >= required_exp {
                0
            } else {
                required_exp - current_exp
            }
        }
    }
} 