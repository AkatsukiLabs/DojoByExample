#[derive(Copy, Drop, Debug)]
pub struct BeastStats {
    pub beast_id: u256,
    pub max_hp: u16,
    pub current_hp: u16,
    pub attack: u16,
    pub defense: u16,
    pub speed: u16,
    pub accuracy: u8,
    pub evasion: u8,
    pub status_condition: u8,
    pub last_timestamp: u64,
}
