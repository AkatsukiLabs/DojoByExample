// Dojo achievements import
use achievement::types::task::{Task, TaskTrait};

// Into trait import
use core::traits::Into;

#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum Achievement {
    FirstBlood,
    Warrior,
    Veteran,
    Champion,
    Legend,
    None,
}

#[generate_trait]
pub impl AchievementImpl of AchievementTrait {
    #[inline]
    fn identifier(self: Achievement) -> felt252 {
        match self {
            Achievement::None => '',
            Achievement::FirstBlood => 'first blood',
            Achievement::Warrior => 'warrior',
            Achievement::Veteran => 'veteran',
            Achievement::Champion => 'champion',
            Achievement::Legend => 'legend',
        }
    }

    #[inline]
    fn hidden(self: Achievement) -> bool {
        match self {
            Achievement::None => true,
            _ => false,
        }
    }

    #[inline]
    fn index(self: Achievement) -> u8 {
        match self {
            Achievement::None => 0,
            Achievement::FirstBlood => 1,
            Achievement::Warrior => 2,
            Achievement::Veteran => 3,
            Achievement::Champion => 4,
            Achievement::Legend => 5,
        }
    }

    #[inline]
    fn points(self: Achievement) -> u8 {
        match self {
            Achievement::None => 0,
            Achievement::FirstBlood => 10,
            Achievement::Warrior => 25,
            Achievement::Veteran => 50,
            Achievement::Champion => 100,
            Achievement::Legend => 200,
        }
    }

    #[inline]
    fn group(self: Achievement) -> felt252 {
        match self {
            Achievement::None => '',
            Achievement::FirstBlood => 'Battle Master',
            Achievement::Warrior => 'Battle Master',
            Achievement::Veteran => 'Battle Master',
            Achievement::Champion => 'Battle Master',
            Achievement::Legend => 'Battle Master',
        }
    }

    #[inline]
    fn icon(self: Achievement) -> felt252 {
        match self {
            Achievement::None => '',
            Achievement::FirstBlood => 'fa-sword',
            Achievement::Warrior => 'fa-shield',
            Achievement::Veteran => 'fa-crown',
            Achievement::Champion => 'fa-trophy',
            Achievement::Legend => 'fa-dragon',
        }
    }

    #[inline]
    fn title(self: Achievement) -> felt252 {
        match self {
            Achievement::None => '',
            Achievement::FirstBlood => 'First Blood',
            Achievement::Warrior => 'Seasoned Warrior',
            Achievement::Veteran => 'Seasoned Veteran',
            Achievement::Champion => 'Seasoned Champion',
            Achievement::Legend => 'Seasoned Legend',
        }
    }

    #[inline]
    fn description(self: Achievement) -> ByteArray {
        match self {
            Achievement::None => "",
            Achievement::FirstBlood => "You've won your first battle, a true novice.",
            Achievement::Warrior => "You've won 5 battles, a prodigy in the making.",
            Achievement::Veteran => "You've won 15 battles, a heroic gamer.",
            Achievement::Champion => "You've won 30 battles, an ultimate champion.",
            Achievement::Legend => "You've won 50 battles, the one and only.",
        }
    }

    #[inline]
    fn tasks(self: Achievement) -> Span<Task> {
        match self {
            Achievement::None => [].span(),
            Achievement::FirstBlood => array![TaskTrait::new('First Blood', 1, "Win a game")].span(),
            Achievement::Warrior => array![TaskTrait::new('Warrior', 5, "Win 5 games")].span(),
            Achievement::Veteran => array![TaskTrait::new('Veteran', 15, "Win 15 games")].span(),
            Achievement::Champion => array![TaskTrait::new('Champion', 30, "Win 30 games")].span(),
            Achievement::Legend => array![TaskTrait::new('Legend', 50, "Win 50 games")].span(),
        }
    }

    #[inline]
    fn start(self: Achievement) -> ByteArray {
        ""
    }

    #[inline]
    fn end(self: Achievement) -> ByteArray {
        ""
    }

    #[inline]
    fn data(self: Achievement) -> ByteArray {
        ""
    }
}


pub impl IntoAchievementU8 of Into<Achievement, u8> {
    #[inline]
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
    #[inline]
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