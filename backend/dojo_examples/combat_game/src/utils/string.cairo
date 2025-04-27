pub fn get_short_string_length(s: felt252) -> u32 {
    let mut value: u256 = s.into();
    let mut len = 0_u32;

    loop {
        if value == 0 {
            break len;
        }
        value /= 0x100;
        len += 1;
    }
}

pub fn stringify(s: felt252) -> ByteArray {
    let mut name: ByteArray = "";
    name.append_word(s, get_short_string_length(s));
    name
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_get_short_string_length() {
        assert_eq!(get_short_string_length(''), 0, "bad len('')");
        assert_eq!(get_short_string_length('hello'), 5, "bad len('hello')");
        assert_eq!(
            get_short_string_length('very very very very long string'),
            31,
            "bad len('very very very very long string')",
        );
    }

    #[test]
    fn test_stringify() {
        assert_eq!(stringify(''), "", "bad stringify('')");
        assert_eq!(stringify('hello'), "hello", "bad stringify('hello')");
        assert_eq!(
            stringify('very very very very long string'),
            "very very very very long string",
            "bad stringify('very very very very long string')",
        );
    }
}
