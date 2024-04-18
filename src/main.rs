#![no_main]
#![feature(const_trait_impl)]
#![feature(effects)]

pub mod utils;

use getrandom_runtime_seeded::init_getrandom;

#[circuit]
pub fn main(a: i32, b: i32) -> bool {
    // use a real seed here from a secure source (not a hardcoded one)
    init_getrandom([0u8; 32]);

    // compile proof verification route
    // basically take in the proof as a stringified json
    // then verify it
    // basically the same logic as the verifier in the mpc tls process

    //test would be if the libraries can be compiled to the correct target
    return a == b
}