#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct Reward {
    #[key]
    pub id: u256,
    pub reward_type: u256,
    pub amount: u256,
    pub description: ByteArray,
    pub associated_event: u256,
    pub issued_at: u64,
}
