#[derive(Introspect, Copy, Drop, Serde, Debug, PartialEq)]
pub enum BeastType {
    Light,
    Magic,
    Shadow,
}
