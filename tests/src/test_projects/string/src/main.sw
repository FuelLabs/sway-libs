contract;

use std::{
    assert::assert,
    intrinsics::size_of,
    mem::{addr_of, read},
    option::Option,
    vec::Vec,
};
use sway_libs::string::String;

abi StringTest {
    fn test_as_bytes();
    fn test_capacity();
    fn test_clear();
    fn test_is_empty();
    fn test_len();
    fn test_new();
    fn test_push();
    fn test_push_str();
    fn test_with_capacity();
}

impl StringTest for Contract {
    fn test_as_bytes() {

    }

    fn test_capacity() {
        let mut string = ~String::new();

        let number0 = 0u8;
        let number1 = 1u8;
        let number2 = 2u8;
        let number3 = 3u8;
        let number4 = 4u8;
        let number5 = 5u8;
        let number6 = 6u8;
        let number7 = 7u8;
        let number8 = 8u8;

        assert(string.capacity() == 0);

        string.push(number0);
        assert(string.capacity() == 1);

        string.push(number1);
        assert(string.capacity() == 2);

        string.push(number2);
        assert(string.capacity() == 4);

        string.push(number3);
        assert(string.capacity() == 4);

        string.push(number4);
        assert(string.capacity() == 8);

        string.push(number5);
        assert(string.capacity() == 8);

        string.push(number6);
        string.push(number7);
        assert(string.capacity() == 8);

        string.push(number8);
        assert(string.capacity() == 16);
        
        string.clear();
        assert(string.capacity() == 16);

        string.push(number0);
        assert(string.capacity() == 16);
    }

    fn test_clear() {
        let mut string = ~String::new();

        let number0 = 0u8;
        let number1 = 1u8;
        let number2 = 2u8;
        let number3 = 3u8;
        let number4 = 4u8;
        let number5 = 5u8;
        let number6 = 6u8;
        let number7 = 7u8;
        let number8 = 8u8;

        assert(string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(number0);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(number0);
        string.push(number1);
        string.push(number2);
        string.push(number3);
        string.push(number4);
        string.push(number5);
        string.push(number6);
        string.push(number7);
        string.push(number8);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(number0);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());
    }

    fn test_is_empty() {
        let mut string = ~String::new();

        assert(string.is_empty());      

        string.push(0u8);
        assert(!string.is_empty()); 

        string.push(1u8);
        assert(!string.is_empty()); 

        string.clear();
        assert(string.is_empty()); 

        string.push(0u8);
        assert(!string.is_empty()); 

        string.push(1u8);
        assert(!string.is_empty()); 

        // TODO: Pop and check if empty
    }

    fn test_len() {
        let mut string = ~String::new();

        assert(string.len() == 0);

        let number0 = 0u8;
        let number1 = 1u8;
        let number2 = 2u8;
        let number3 = 3u8;
        let number4 = 4u8;
        let number5 = 5u8;
        let number6 = 6u8;
        let number7 = 7u8;
        let number8 = 8u8;

        string.push(number0);
        assert(string.len() == 1);

        string.push(number1);
        assert(string.len() == 2);

        string.push(number2);
        assert(string.len() == 3);

        string.push(number3);
        assert(string.len() == 4);

        string.push(number4);
        assert(string.len() == 5);

        string.push(number5);
        assert(string.len() == 6);

        string.push(number6);
        assert(string.len() == 7);

        string.push(number7);
        assert(string.len() == 8);

        string.push(number8);
        assert(string.len() == 9);
    }

    fn test_new() {
        let mut string = ~String::new();
        
        assert(string.len() == 0);
        assert(string.is_empty()); 
        assert(string.capacity() == 0);
    }

    fn test_push() {
        let mut string = ~String::new();

        // TODO: Eq will be needed for Vec
        //assert(string.as_bytes() == ~Vec::new());
        assert(string.len() == 0);
        assert(string.is_empty()); 
        assert(string.capacity() == 0);

        let number0 = 0u8;
        let number1 = 1u8;
        let number2 = 2u8;
        let number3 = 3u8;
        let number4 = 4u8;
        let number5 = 5u8;
        let number6 = 6u8;
        let number7 = 7u8;
        let number8 = 8u8;

        string.push(number0);
        // assert(string.get(0) == number0);
        assert(string.len() == 1);

        string.push(number1);
        // assert(string.get(1) == number1);
        assert(string.len() == 2);

        string.push(number2);
        // assert(string.get(2) == number2);
        assert(string.len() == 3);

        string.push(number3);
        // assert(string.get(3) == number3);
        assert(string.len() == 4);

        string.push(number4);
        // assert(string.get(4) == number4);
        assert(string.len() == 5);

        string.push(number5);
        // assert(string.get(5) == number5);
        assert(string.len() == 6);

        string.push(number6);
        // assert(string.get(6) == number6);
        assert(string.len() == 7);

        string.push(number7);
        // assert(string.get(7) == number7);
        assert(string.len() == 8);

        string.push(number8);
        // assert(string.get(8) == number8);
        assert(string.len() == 9);

        string.push(number1);
        // assert(string.get(9) == number1);
        assert(string.len() == 10);

        string.clear();
        assert(string.len() == 0);
        assert(string.is_empty()); 

        string.push(number1);
        // assert(string.get(0) == number1);
        assert(string.len() == 1);

        string.push(number1);
        // assert(string.get(1) == number1);
        assert(string.len() == 2);

        string.push(number0);
        // assert(string.get(2) == number0);
        assert(string.len() == 3);
    }

    fn test_push_str() {
        let mut string = ~String::new();

        let fuel_str: str[4] = "fuel";
        let ptr: u64 = addr_of(fuel_str);

        string.push_str(ptr, 4);

        let byte1: u8 = read(ptr);
        let byte2: u8 = read(ptr + 1);
        let byte3: u8 = read(ptr + 2);
        let byte4: u8 = read(ptr + 3);

        assert(string.len() == 4);
        assert(string.nth(0).unwrap() == byte1);
        assert(string.nth(1).unwrap() == byte2);
        assert(string.nth(2).unwrap() == byte3);
        assert(string.nth(3).unwrap() == byte4);

        // let f: str[1] = "f";
        // let u: str[1] = "u";
        // let e: str[1] = "e";
        // let l: str[1] = "l";

        // let ptr_f: u64 = addr_of(f);
        // let ptr_u: u64 = addr_of(u);
        // let ptr_e: u64 = addr_of(e);
        // let ptr_l: u64 = addr_of(l);

        // let byte_f: u8 = read(ptr_f);
        // let byte_u: u8 = read(ptr_u);
        // let byte_e: u8 = read(ptr_e);
        // let byte_l: u8 = read(ptr_l);

        // assert(string.nth(0).unwrap() == byte_f);
        // assert(string.nth(1).unwrap() == byte_u);
        // assert(string.nth(2).unwrap() == byte_e);
        // assert(string.nth(3).unwrap() == byte_l);
    }

    fn test_with_capacity() {

        let mut iterator = 0;

        while iterator < 16 {
            let mut string = ~String::with_capacity(iterator);
            assert(string.capacity() == iterator);

            iterator += 1;
        }

        let number0 = 0u8;
        let number1 = 1u8;
        let number2 = 2u8;
        let number3 = 3u8;
        let number4 = 4u8;

        let mut string = ~String::with_capacity(0);
        assert(string.capacity() == 0);

        string.push(number0);
        assert(string.capacity() == 1);
        string.push(number1);
        assert(string.capacity() == 2);
        string.push(number2);
        assert(string.capacity() == 4);
        string.clear();
        assert(string.capacity() == 4);
    
        let mut string = ~String::with_capacity(4);
        assert(string.capacity() == 4);

        string.push(number0);
        assert(string.capacity() == 4);
        string.push(number1);
        assert(string.capacity() == 4);
        string.push(number2);
        assert(string.capacity() == 4);
        string.push(number3);
        assert(string.capacity() == 4);
        string.push(number4);
        assert(string.capacity() == 8);
    }
}
