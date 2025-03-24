#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct BeastStats {
    #[key]
    pub beast_id: u256,
    pub base_hp: u16,
    pub attack: u16,
    pub defense: u16,
    pub special_attack: u16,
    pub special_defense: u16,
    pub speed: u16,
    pub accuracy: u8, 
    pub evasion: u8,
    pub critical_hit_rate: u8, 
    pub growth_rate: u8,
}
