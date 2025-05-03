#[derive(Copy, Drop, Serde)]
enum AttackType {
    Slash,
    Beam,
    Wave,
    Punch,
    Kick,
    Blast,
    Crush,
    Pierce,
    Smash,
    Burn,
    Freeze,
    Shock,
    None,
}

impl AttackTypeIntoFelt252 of Into<AttackType, felt252> {
    fn into(self: AttackType) -> felt252 {
        match self {
            AttackType::Slash => 'Slash',
            AttackType::Beam => 'Beam',
            AttackType::Wave => 'Wave',
            AttackType::Punch => 'Punch',
            AttackType::Kick => 'Kick',
            AttackType::Blast => 'Blast',
            AttackType::Crush => 'Crush',
            AttackType::Pierce => 'Pierce',
            AttackType::Smash => 'Smash',
            AttackType::Burn => 'Burn',
            AttackType::Freeze => 'Freeze',
            AttackType::Shock => 'Shock',
            AttackType::None => 'None',
        }
    }
}

impl AttackTypeIntoU8 of Into<AttackType, u8> {
    fn into(self: AttackType) -> u8 {
        match self {
            AttackType::Slash => 0_u8,
            AttackType::Beam => 1_u8,
            AttackType::Wave => 2_u8,
            AttackType::Punch => 3_u8,
            AttackType::Kick => 4_u8,
            AttackType::Blast => 5_u8,
            AttackType::Crush => 6_u8,
            AttackType::Pierce => 7_u8,
            AttackType::Smash => 8_u8,
            AttackType::Burn => 9_u8,
            AttackType::Freeze => 10_u8,
            AttackType::Shock => 11_u8,
            AttackType::None => 12_u8,
        }
    }
}

impl U8IntoAttackType of Into<u8, AttackType> {
    fn into(self: u8) -> AttackType {
        match self {
            0 => AttackType::Slash,
            1 => AttackType::Beam,
            2 => AttackType::Wave,
            3 => AttackType::Punch,
            4 => AttackType::Kick,
            5 => AttackType::Blast,
            6 => AttackType::Crush,
            7 => AttackType::Pierce,
            8 => AttackType::Smash,
            9 => AttackType::Burn,
            10 => AttackType::Freeze,
            11 => AttackType::Shock,
            _ => AttackType::None, // Default/fallback case
        }
    }
}

#[cfg(test)]
mod tests {
    use super::AttackType;
    use core::traits::Into;

    #[test]
    fn test_attacktype_into_felt252() {
        assert(AttackType::Slash.into() == 'Slash', 'Slash into felt252');
        assert(AttackType::Beam.into() == 'Beam', 'Beam into felt252');
        assert(AttackType::Wave.into() == 'Wave', 'Wave into felt252');
        assert(AttackType::Punch.into() == 'Punch', 'Punch into felt252');
        assert(AttackType::Kick.into() == 'Kick', 'Kick into felt252');
        assert(AttackType::Blast.into() == 'Blast', 'Blast into felt252');
        assert(AttackType::Crush.into() == 'Crush', 'Crush into felt252');
        assert(AttackType::Pierce.into() == 'Pierce', 'Pierce into felt252');
        assert(AttackType::Smash.into() == 'Smash', 'Smash into felt252');
        assert(AttackType::Burn.into() == 'Burn', 'Burn into felt252');
        assert(AttackType::Freeze.into() == 'Freeze', 'Freeze into felt252');
        assert(AttackType::Shock.into() == 'Shock', 'Shock into felt252');
        assert(AttackType::None.into() == 'None', 'None into felt252');
    }

    #[test]
    fn test_attacktype_into_u8() {
        assert(AttackType::Slash.into() == 0_u8, 'Slash into u8');
        assert(AttackType::Beam.into() == 1_u8, 'Beam into u8');
        assert(AttackType::Wave.into() == 2_u8, 'Wave into u8');
        assert(AttackType::Punch.into() == 3_u8, 'Punch into u8');
        assert(AttackType::Kick.into() == 4_u8, 'Kick into u8');
        assert(AttackType::Blast.into() == 5_u8, 'Blast into u8');
        assert(AttackType::Crush.into() == 6_u8, 'Crush into u8');
        assert(AttackType::Pierce.into() == 7_u8, 'Pierce into u8');
        assert(AttackType::Smash.into() == 8_u8, 'Smash into u8');
        assert(AttackType::Burn.into() == 9_u8, 'Burn into u8');
        assert(AttackType::Freeze.into() == 10_u8, 'Freeze into u8');
        assert(AttackType::Shock.into() == 11_u8, 'Shock into u8');
        assert(AttackType::None.into() == 12_u8, 'None into u8');
    }

    #[test]
    fn test_u8_into_attacktype() {
        assert(Into::<u8, AttackType>::into(0_u8) == AttackType::Slash, '0 into Slash');
        assert(Into::<u8, AttackType>::into(1_u8) == AttackType::Beam, '1 into Beam');
        assert(Into::<u8, AttackType>::into(2_u8) == AttackType::Wave, '2 into Wave');
        assert(Into::<u8, AttackType>::into(3_u8) == AttackType::Punch, '3 into Punch');
        assert(Into::<u8, AttackType>::into(4_u8) == AttackType::Kick, '4 into Kick');
        assert(Into::<u8, AttackType>::into(5_u8) == AttackType::Blast, '5 into Blast');
        assert(Into::<u8, AttackType>::into(6_u8) == AttackType::Crush, '6 into Crush');
        assert(Into::<u8, AttackType>::into(7_u8) == AttackType::Pierce, '7 into Pierce');
        assert(Into::<u8, AttackType>::into(8_u8) == AttackType::Smash, '8 into Smash');
        assert(Into::<u8, AttackType>::into(9_u8) == AttackType::Burn, '9 into Burn');
        assert(Into::<u8, AttackType>::into(10_u8) == AttackType::Freeze, '10 into Freeze');
        assert(Into::<u8, AttackType>::into(11_u8) == AttackType::Shock, '11 into Shock');
        assert(Into::<u8, AttackType>::into(12_u8) == AttackType::None, '12 into None');
        assert(Into::<u8, AttackType>::into(13_u8) == AttackType::None, '13 into None (fallback)');
        assert(Into::<u8, AttackType>::into(255_u8) == AttackType::None, '255 into None (fallback)');
    }
} 