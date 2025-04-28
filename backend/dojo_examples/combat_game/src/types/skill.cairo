#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum SkillType {
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
