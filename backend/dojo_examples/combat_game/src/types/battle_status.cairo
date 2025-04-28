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

#[cfg(test)]
mod tests {
    use super::BattleStatus;

    #[test]
    fn test_into_battle_status_waiting() {
        let battle_status = BattleStatus::Waiting;
        let battle_status_felt252: felt252 = battle_status.into();
        assert_eq!(battle_status_felt252, 0);
    }

    #[test]
    fn test_into_battle_status_active() {
        let battle_status = BattleStatus::Active;
        let battle_status_felt252: felt252 = battle_status.into();
        assert_eq!(battle_status_felt252, 1);
    }

    #[test]
    fn test_into_battle_status_finished() {
        let battle_status = BattleStatus::Finished;
        let battle_status_felt252: felt252 = battle_status.into();
        assert_eq!(battle_status_felt252, 2);
    }

    #[test]
    fn test_into_battle_status_none() {
        let battle_status = BattleStatus::None;
        let battle_status_felt252: felt252 = battle_status.into();
        assert_eq!(battle_status_felt252, 3);
    }

    #[test]
    fn test_into_battle_status_u8_waiting() {
        let battle_status = BattleStatus::Waiting;
        let battle_status_u8: u8 = battle_status.into();
        assert_eq!(battle_status_u8, 0);
    }

    #[test]
    fn test_into_battle_status_u8_active() {
        let battle_status = BattleStatus::Active;
        let battle_status_u8: u8 = battle_status.into();
        assert_eq!(battle_status_u8, 1);
    }

    #[test]
    fn test_into_battle_status_u8_finished() {
        let battle_status = BattleStatus::Finished;
        let battle_status_u8: u8 = battle_status.into();
        assert_eq!(battle_status_u8, 2);
    }

    #[test]
    fn test_into_battle_status_u8_none() {
        let battle_status = BattleStatus::None;
        let battle_status_u8: u8 = battle_status.into();
        assert_eq!(battle_status_u8, 3);
    }

    #[test]
    fn test_into_battle_status_from_u8_waiting() {
        let battle_status_u8: u8 = 0;
        let battle_status: BattleStatus = battle_status_u8.into();
        assert_eq!(battle_status, BattleStatus::Waiting);
    }

    #[test]
    fn test_into_battle_status_from_u8_active() {
        let battle_status_u8: u8 = 1;
        let battle_status: BattleStatus = battle_status_u8.into();
        assert_eq!(battle_status, BattleStatus::Active);
    }

    #[test]
    fn test_into_battle_status_from_u8_finished() {
        let battle_status_u8: u8 = 2;
        let battle_status: BattleStatus = battle_status_u8.into();
        assert_eq!(battle_status, BattleStatus::Finished);
    }

    #[test]
    fn test_into_battle_status_from_u8_none() {
        let battle_status_u8: u8 = 3;
        let battle_status: BattleStatus = battle_status_u8.into();
        assert_eq!(battle_status, BattleStatus::None);
    }

    #[test]
    fn test_into_battle_status_from_u8_invalid() {
        let battle_status_u8: u8 = 4;
        let battle_status: BattleStatus = battle_status_u8.into();
        assert_eq!(battle_status, BattleStatus::None);
    }

    #[test]
    fn test_into_battle_status_from_u8_255_edge_case() {
        let battle_status_u8: u8 = 255;
        let battle_status: BattleStatus = battle_status_u8.into();
        assert_eq!(battle_status, BattleStatus::None);
    }
}
