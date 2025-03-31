use starknet::ContractAddress;



#[derive(Copy, Drop, Serde, Debug, Default)]
#[dojo::model]
#[repr(u8)]
pub enum BattleStatus {
    pub waiting = 0,
    pub active = 1,
    pub finished = 2,
}

impl BattleStatus {
    pub fn from_u8(value: u8) -> Option<BattleStatus> {
        match value {
            0 => Some(BattleStatus::waiting),
            1 => Some(BattleStatus::active),
            2 => Some(BattleStatus::finished),
            _ => None,
        }
    }

    pub fn to_u8(self) -> u8 {
        self as u8
    }
}