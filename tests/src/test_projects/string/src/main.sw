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
    fn test_from_utf8();
    fn test_insert();
    fn test_is_empty();
    fn test_len();
    fn test_new();
    fn test_nth();
    fn test_pop();
    fn test_push();
    fn test_remove();
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

    fn test_from_utf8() {

    }

    fn test_insert() {

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

        string.pop();
        assert(!string.is_empty()); 

        string.pop();
        assert(string.is_empty()); 
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

    fn test_nth() {

    }

    fn test_pop() {

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

    fn test_remove() {

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
