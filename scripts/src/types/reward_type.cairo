#[derive(Serde, Drop, Introspect)]
pub enum RewardType {
    Tokens,
    Item,
    Experience,
}