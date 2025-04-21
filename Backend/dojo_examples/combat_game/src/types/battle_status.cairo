#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum BattleStatus {
    Waiting,
    Active,
    Finished,
    None,
}

pub impl IntoBattleStatusFelt252 of Into<BattleStatus, felt252> {
    #[inline(always)]
     fn into(self: BattleStatus) -> felt252 {
        match self {
            BattleStatus::Waiting => 0,
            BattleStatus::Active => 1,
            BattleStatus::Finished => 2,
            BattleStatus::None => 3,
        }
    }
}

pub impl IntoBattleStatusU8 of Into<BattleStatus, u8> {
    #[inline(always)]
     fn into(self: BattleStatus) -> u8 {
        match self {
            BattleStatus::Waiting => 0,
            BattleStatus::Active => 1,
            BattleStatus::Finished => 2,
            BattleStatus::None => 3,
        }
    }
}

pub impl Intou8BattleStatus of Into<u8, BattleStatus> {
    #[inline(always)]
     fn into(self: u8) -> BattleStatus {
        let battle_type: u8 = self.into();
        match battle_type {
            0 => BattleStatus::Waiting,
            1 => BattleStatus::Active,
            2 => BattleStatus::Finished,
            3 => BattleStatus::None,
            _ => BattleStatus::None,
        }
    }
}