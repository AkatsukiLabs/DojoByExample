use core::byte_array::ByteArrayTrait;

#[derive(Drop, Serde, IntrospectPacked, Debug)]
pub enum Rarity {
    Basic,
    Common,
    Uncommon,
    Rare,
    VeryRare,
    Epic,
    Unique,
}

#[generate_trait]
pub impl RarityImpl of RarityTrait {
    fn is_rare(self: @Rarity) -> bool {
        match self {
            Rarity::Rare | Rarity::VeryRare | Rarity::Epic | Rarity::Unique => true,
            _ => false,
        }
    }
}

pub impl RarityDisplay of core::fmt::Display<Rarity> {
    fn fmt(self: @Rarity, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            Rarity::Basic => "Basic",
            Rarity::Common => "Common",
            Rarity::Uncommon => "Uncommon",
            Rarity::Rare => "Rare",
            Rarity::VeryRare => "Very Rare",
            Rarity::Epic => "Epic",
            Rarity::Unique => "Unique",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
