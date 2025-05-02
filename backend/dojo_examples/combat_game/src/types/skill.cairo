#[derive(Copy, Drop, Serde, Introspect, Debug, PartialEq)]
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

pub impl SkillTypeDisplay of core::fmt::Display<SkillType> {
    fn fmt(self: @SkillType, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            SkillType::Beam => "Beam",
            SkillType::Slash => "Slash",
            SkillType::Wave => "Wave",
            SkillType::Punch => "Punch",
            SkillType::Kick => "Kick",
            SkillType::Pierce => "Pierce",
            SkillType::Blast => "Blast",
            SkillType::Freeze => "Freeze",
            SkillType::Burn => "Burn",
            SkillType::Smash => "Smash",
            SkillType::Crush => "Crush",
            SkillType::Shock => "Shock",
            SkillType::Default => "Default",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
