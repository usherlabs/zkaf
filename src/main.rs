#![no_main]

// use hex;
use zkaf::utils::verify_proof;
// use std::str;

#[circuit]
pub fn main() -> bool {

    // compile proof verification route
    // basically take in the proof as a stringified json
    // then verify it
    // basically the same logic as the verifier in the mpc tls process

    // let proof = String::from_utf8(_proof).unwrap();
    // let pub_key = String::from_utf8(*_pub_key).unwrap();
    // let proof_bytes = hex::decode(enc_proof).unwrap();
    // let pub_key_bytes = hex::decode(enc_pub_key).unwrap();
    // let proof = str::from_utf8(&proof_bytes).unwrap();
    // let pub_key = str::from_utf8(&pub_key_bytes).unwrap();

    // let proof = PROOF;
    // let pub_key = PUB_KEY;
    // let res = verify_proof(&proof.to_string(), &pub_key.to_string());

    // return match res {
    //     Ok(_) => true,
    //     Err(_) => false,
    // }

    return true;
}