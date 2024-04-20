// mod rand;

pub mod utils;

use getrandom::register_custom_getrandom;

// This function will replace the default getrandom behavior
pub fn seeded_getrandom(buf: &mut [u8]) -> Result<(), getrandom::Error> {
    // TODO: use a real seed here from a secure source (not a hardcoded one)
    // For example purposes, fill the buffer with a fixed value
    for byte in buf.iter_mut() {
        *byte = 0x55; // Arbitrary choice for example purposes
    }
    Ok(())
}

// register_custom_getrandom!(rand::generated_random);
register_custom_getrandom!(seeded_getrandom);
