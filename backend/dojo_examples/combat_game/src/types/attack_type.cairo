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


pub impl AttackTypeDisplay of core::fmt::Display<AttackType> {
    fn fmt(self: @AttackType, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            AttackType::Beam => "Beam",
            AttackType::Slash => "Slash",
            AttackType::Wave => "Wave",
            AttackType::Punch => "Punch",
            AttackType::Kick => "Kick",
            AttackType::Pierce => "Pierce",
            AttackType::Blast => "Blast",
            AttackType::Freeze => "Freeze",
            AttackType::Burn => "Burn",
            AttackType::Smash => "Smash",
            AttackType::Crush => "Crush",
            AttackType::Shock => "Shock",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
