#[derive(Default, Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerStats {
    #[key]
    pub id: u256,
    pub highest_score: (u256, u256),
    pub tournaments_participated: Array<u256>,
    pub rewards: Array<u256>,
    pub win_count: u64,
    pub matchup_list: Array<u256>,
}