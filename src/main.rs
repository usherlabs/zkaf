#![no_main]
#![feature(const_trait_impl)]
#![feature(effects)]

use getrandom_runtime_seeded::init_getrandom;
use hex;
use zkaf::utils::verify_proof;
use std::str;

#[circuit]
pub fn main(enc_proof: &str, enc_pub_key: &str) -> bool {
    // use a real seed here from a secure source (not a hardcoded one)
    init_getrandom([0u8; 32]);

    // compile proof verification route
    // basically take in the proof as a stringified json
    // then verify it
    // basically the same logic as the verifier in the mpc tls process

    let proof_bytes = hex::decode(enc_proof).unwrap();
    let pub_key_bytes = hex::decode(enc_pub_key).unwrap();
    let proof = str::from_utf8(&proof_bytes).unwrap();
    let pub_key = str::from_utf8(&pub_key_bytes).unwrap();

    let res = verify_proof(&proof.to_string(), &pub_key.to_string());

    return match res {
        Ok(_) => true,
        Err(_) => false,
    }
}