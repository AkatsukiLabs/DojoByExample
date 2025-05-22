#[derive(Copy, Drop, Serde, Debug, PartialEq)]
#[dojo::model]
pub struct BeastSkill {
    #[key]
    pub beast_id: u16,
    pub skills_ids: Span<u256>,
}
