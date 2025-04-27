#[derive(Introspect, Copy, Drop, Serde, Debug, PartialEq)]
pub enum AttackType {
    Beam,
    Slash,
    Wave,
    Punch,
    Kick,
    Pierce,
    Blast,
    Freeze,
    Burn,
    Smash,
    Crush,
    Shock,
}

#[generate_trait]
pub impl AttackTypeImpl of AttackTypeTrait {
    fn base_damage(self: @AttackType) -> u16 {
        match self {
            AttackType::Slash => 40,
            AttackType::Beam => 45,
            AttackType::Wave => 35,
            AttackType::Punch => 30,
            AttackType::Kick => 35,
            AttackType::Blast => 50,
            AttackType::Crush => 45,
            AttackType::Pierce => 40,
            AttackType::Smash => 50,
            AttackType::Burn => 40,
            AttackType::Freeze => 40,
            AttackType::Shock => 45,
            _ => 30,
        }
    }
}
