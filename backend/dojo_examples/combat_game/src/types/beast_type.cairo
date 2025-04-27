#[derive(Introspect, Copy, Drop, Serde, Debug, PartialEq)]
pub enum BeastType {
    Light,
    Magic,
    Shadow,
}

pub impl BeastTypeDisplay of core::fmt::Display<BeastType> {
    fn fmt(self: @BeastType, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            BeastType::Light => "Light",
            BeastType::Magic => "Magic",
            BeastType::Shadow => "Shadow",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
