#[derive(Copy, Drop, Serde, Introspect, PartialEq, Debug)]
pub enum BattleStatus {
    Waiting,
    Active,
    Finished,
}

#[cfg(test)]
mod tests {
    use super::BattleStatus;

    #[test]
    fn test_variant_instantiation() {
        let waiting = BattleStatus::Waiting;
        let active = BattleStatus::Active;
        let finished = BattleStatus::Finished;
        
        assert(waiting != active, 'waiting vs active');
        assert(active != finished, 'active vs finished');
        assert(waiting != finished, 'waiting vs finished');
    }

    #[test]
    fn test_variant_equality() {
        let status1 = BattleStatus::Waiting;
        let status2 = BattleStatus::Waiting;
        let status3 = BattleStatus::Active;
        
        assert(status1 == status2, 'equality check');
        assert(status1 != status3, 'inequality check');
    }

    #[test]
    fn test_variant_matching() {
        let status = BattleStatus::Active;
        
        let is_active = match status {
            BattleStatus::Active => true,
            _ => false,
        };
        
        assert(is_active, 'match check');
    }

    #[test]
    fn test_status_transitions() {
        let mut current_status = BattleStatus::Waiting;
        
        let can_start = match current_status {
            BattleStatus::Waiting => true,
            _ => false,
        };
        assert(can_start, 'can start check');

        current_status = BattleStatus::Active;
        let is_active = match current_status {
            BattleStatus::Active => true,
            _ => false,
        };
        assert(is_active, 'is active check');

        current_status = BattleStatus::Finished;
        let is_finished = match current_status {
            BattleStatus::Finished => true,
            _ => false,
        };
        assert(is_finished, 'is finished check');
    }

    #[test]
    fn test_status_function_integration() {
        let handle_status = |status: BattleStatus| -> bool {
            match status {
                BattleStatus::Active => true,
                _ => false,
            }
        };

        assert(handle_status(BattleStatus::Active), 'active check');
        assert(!handle_status(BattleStatus::Waiting), 'waiting check');
        assert(!handle_status(BattleStatus::Finished), 'finished check');
    }
}