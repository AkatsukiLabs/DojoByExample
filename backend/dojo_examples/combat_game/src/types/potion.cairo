#[derive(Copy, Drop, Serde, Debug, PartialEq, Introspect)]
pub enum Potion {
    Empty,
    Health,
    Mana,
    Stamina,
}