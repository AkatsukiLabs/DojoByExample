#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum Achievement {
    FirstBlood,
    Warrior,
    Veteran,
    Champion,
    Legend,
    None,
}

pub impl IntoAchievementU8 of Into<Achievement, u8> {
    #[inline(always)]
    fn into(self: Achievement) -> u8 {
        match self {
            Achievement::None => 0,
            Achievement::FirstBlood => 1,
            Achievement::Warrior => 2,
            Achievement::Veteran => 3,
            Achievement::Champion => 4,
            Achievement::Legend => 5,
        }
    }
}

pub impl IntoU8Achievement of Into<u8, Achievement> {
    #[inline(always)]
    fn into(self: u8) -> Achievement {
        match self {
            0 => Achievement::None,
            1 => Achievement::FirstBlood,
            2 => Achievement::Warrior,
            3 => Achievement::Veteran,
            4 => Achievement::Champion,
            5 => Achievement::Legend,
            _ => Achievement::None,
        }
    }
}