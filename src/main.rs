#![no_main]
#![feature(const_trait_impl)]
#![feature(effects)]

pub mod utils;

#[circuit]
pub fn main(a: i32, b: i32) -> bool {
    // compile proof verification route
    // basically take in the proof as a stringified json
    // then verify it
    // basically the same logic as the verifier in the mpc tls process

    //test would be if the libraries can be compiled to the correct target
    return a == b
}