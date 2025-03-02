#[derive(Clone, Drop, Serde, Debug)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub id: ContractAddress,
    pub player: Player<u256>,
    pub beast_type: Beast,