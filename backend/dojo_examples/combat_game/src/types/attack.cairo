#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum AttackType {
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
    Default,
}
