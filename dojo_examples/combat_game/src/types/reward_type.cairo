#[derive(Serde, Drop)]
pub enum RewardType {
    Undefined,
    Tokens,
    Item,
    Experience,
}

impl IntoRewardTypeFelt252 of Into<RewardType, felt252> {
    fn into(self: RewardType) -> felt252 {
        match self {
            RewardType::Undefined => 0,
            RewardType::Tokens => 1,
            RewardType::Item => 2,
            RewardType::Experience => 3,
        }
    }
}

impl IntoRewardTypeU8 of Into<RewardType, u8> {
    fn into(self: RewardType) -> u8 {
        match self {
            RewardType::Undefined => 0_u8,
            RewardType::Tokens => 1_u8,
            RewardType::Item => 2_u8,
            RewardType::Experience => 3_u8,
        }
    }
}

impl IntoU8RewardType of Into<u8, RewardType> {
    fn into(self: u8) -> RewardType {
        match self {
            0_u8 => RewardType::Undefined,
            1_u8 => RewardType::Tokens,
            2_u8 => RewardType::Item,
            3_u8 => RewardType::Experience,
            _ => {
                println!("Does not match a RewardType");
                RewardType::Undefined
            },
        }
    }
}
