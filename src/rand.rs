// use getrandom::register_custom_getrandom;
// use core::num::NonZeroU32;
// use getrandom::Error;

// // Some application-specific error code
// const MY_CUSTOM_ERROR_CODE: u32 = Error::CUSTOM_START + 42;
// pub fn always_fail(buf: &mut [u8]) -> Result<(), Error> {
//     let code = NonZeroU32::new(MY_CUSTOM_ERROR_CODE).unwrap();
//     Err(Error::from(code))
// }

// pub fn generated_random(buf: &mut [u8]) -> Result<(), Error> {

// }

