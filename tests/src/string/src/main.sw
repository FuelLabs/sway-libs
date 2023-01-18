contract;

use string::String;

const NUMBER0 = 0u8;
const NUMBER1 = 1u8;
const NUMBER2 = 2u8;
const NUMBER3 = 3u8;
const NUMBER4 = 4u8;
const NUMBER5 = 5u8;
const NUMBER6 = 6u8;
const NUMBER7 = 7u8;
const NUMBER8 = 8u8;

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
        let mut string = String::new();

        let bytes: Vec<u8> = string.as_bytes();
        assert(bytes.len() == string.len());
        assert(bytes.capacity() == string.capacity());

        string.push(NUMBER0);
        let bytes: Vec<u8> = string.as_bytes();
        assert(bytes.len() == string.len());
        assert(bytes.capacity() == string.capacity());
        assert(bytes.get(0).unwrap() == string.nth(0).unwrap());

        string.push(NUMBER1);
        let mut bytes: Vec<u8> = string.as_bytes();
        assert(bytes.len() == string.len());
        assert(bytes.capacity() == string.capacity());
        assert(bytes.get(1).unwrap() == string.nth(1).unwrap());

        let result_string = string.pop().unwrap();
        let result_bytes = bytes.pop().unwrap();
        assert(result_bytes == result_string);
        assert(bytes.len() == string.len());
        assert(bytes.capacity() == string.capacity());
        assert(bytes.get(0).unwrap() == string.nth(0).unwrap());
    }

    fn test_capacity() {
        let mut string = String::new();

        assert(string.capacity() == 0);

        string.push(NUMBER0);
        assert(string.capacity() == 1);

        string.push(NUMBER1);
        assert(string.capacity() == 2);

        string.push(NUMBER2);
        assert(string.capacity() == 4);
        string.push(NUMBER3);
        assert(string.capacity() == 4);

        string.push(NUMBER4);
        assert(string.capacity() == 8);
        string.push(NUMBER5);
        assert(string.capacity() == 8);
        string.push(NUMBER6);
        string.push(NUMBER7);
        assert(string.capacity() == 8);

        string.push(NUMBER8);
        assert(string.capacity() == 16);

        string.clear();
        assert(string.capacity() == 16);

        string.push(NUMBER0);
        assert(string.capacity() == 16);
    }

    fn test_clear() {
        let mut string = String::new();

        assert(string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(NUMBER0);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(NUMBER0);
        string.push(NUMBER1);
        string.push(NUMBER2);
        string.push(NUMBER3);
        string.push(NUMBER4);
        string.push(NUMBER5);
        string.push(NUMBER6);
        string.push(NUMBER7);
        string.push(NUMBER8);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(NUMBER0);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());
    }

    fn test_from_utf8() {
        let mut vec: Vec<u8> = Vec::new();

        vec.push(NUMBER0);
        vec.push(NUMBER1);
        vec.push(NUMBER2);
        vec.push(NUMBER3);
        vec.push(NUMBER4);

        let string_from_uft8 = String::from_utf8(vec);
        assert(vec.len() == string_from_uft8.len());
        assert(vec.capacity() == string_from_uft8.capacity());
        assert(vec.get(0).unwrap() == string_from_uft8.nth(0).unwrap());
        assert(vec.get(1).unwrap() == string_from_uft8.nth(1).unwrap());
        assert(vec.get(2).unwrap() == string_from_uft8.nth(2).unwrap());
    }

    fn test_insert() {
        let mut string = String::new();

        assert(string.len() == 0);

        string.insert(NUMBER0, 0);
        assert(string.len() == 1);
        assert(string.nth(0).unwrap() == NUMBER0);

        string.push(NUMBER1);
        string.push(NUMBER2);
        string.insert(NUMBER3, 0);
        assert(string.len() == 4);
        assert(string.nth(0).unwrap() == NUMBER3);

        string.insert(NUMBER4, 1);
        assert(string.nth(1).unwrap() == NUMBER4);

        string.insert(NUMBER5, string.len() - 1);
        assert(string.nth(string.len() - 2).unwrap() == NUMBER5);
    }

    fn test_is_empty() {
        let mut string = String::new();

        assert(string.is_empty());

        string.push(NUMBER0);
        assert(!string.is_empty());

        string.push(NUMBER1);
        assert(!string.is_empty());

        string.clear();
        assert(string.is_empty());

        string.push(NUMBER0);
        assert(!string.is_empty());

        string.push(NUMBER1);
        assert(!string.is_empty());

        let _result = string.pop();
        assert(!string.is_empty());

        let _result = string.pop();
        assert(string.is_empty());
    }

    fn test_len() {
        let mut string = String::new();

        assert(string.len() == 0);

        string.push(NUMBER0);
        assert(string.len() == 1);

        string.push(NUMBER1);
        assert(string.len() == 2);

        string.push(NUMBER2);
        assert(string.len() == 3);

        string.push(NUMBER3);
        assert(string.len() == 4);

        string.push(NUMBER4);
        assert(string.len() == 5);

        string.push(NUMBER5);
        assert(string.len() == 6);

        string.push(NUMBER6);
        assert(string.len() == 7);

        string.push(NUMBER7);
        assert(string.len() == 8);

        string.push(NUMBER8);
        assert(string.len() == 9);

        let _result = string.pop();
        assert(string.len() == 8);

        string.clear();
        assert(string.len() == 0);
    }

    fn test_new() {
        let mut string = String::new();

        assert(string.len() == 0);
        assert(string.is_empty());
        assert(string.capacity() == 0);
    }

    fn test_nth() {
        let mut string = String::new();

        string.push(NUMBER0);
        assert(string.nth(0).unwrap() == NUMBER0);

        string.push(NUMBER1);
        assert(string.nth(0).unwrap() == NUMBER0);
        assert(string.nth(1).unwrap() == NUMBER1);

        string.push(NUMBER2);
        assert(string.nth(0).unwrap() == NUMBER0);
        assert(string.nth(1).unwrap() == NUMBER1);
        assert(string.nth(2).unwrap() == NUMBER2);

        string.push(NUMBER3);
        assert(string.nth(0).unwrap() == NUMBER0);
        assert(string.nth(1).unwrap() == NUMBER1);
        assert(string.nth(2).unwrap() == NUMBER2);
        assert(string.nth(3).unwrap() == NUMBER3);

        string.push(NUMBER4);
        assert(string.nth(0).unwrap() == NUMBER0);
        assert(string.nth(1).unwrap() == NUMBER1);
        assert(string.nth(2).unwrap() == NUMBER2);
        assert(string.nth(3).unwrap() == NUMBER3);
        assert(string.nth(4).unwrap() == NUMBER4);

        string.clear();
        string.push(NUMBER5);
        string.push(NUMBER6);
        assert(string.nth(0).unwrap() == NUMBER5);
        assert(string.nth(1).unwrap() == NUMBER6);

        assert(string.nth(2).is_none());
    }

    fn test_pop() {
        let mut string = String::new();

        string.push(NUMBER0);
        string.push(NUMBER1);
        string.push(NUMBER2);
        string.push(NUMBER3);
        string.push(NUMBER4);

        assert(string.len() == 5);
        assert(string.pop().unwrap() == NUMBER4);

        assert(string.len() == 4);
        assert(string.pop().unwrap() == NUMBER3);

        assert(string.len() == 3);
        assert(string.pop().unwrap() == NUMBER2);

        assert(string.len() == 2);
        assert(string.pop().unwrap() == NUMBER1);

        assert(string.len() == 1);
        assert(string.pop().unwrap() == NUMBER0);

        assert(string.len() == 0);
        assert(string.pop().is_none());
        string.push(NUMBER5);
        assert(string.pop().unwrap() == NUMBER5);
    }

    fn test_push() {
        let mut string = String::new();

        assert(string.len() == 0);
        assert(string.is_empty());
        assert(string.capacity() == 0);

        string.push(NUMBER0);
        assert(string.nth(0).unwrap() == NUMBER0);
        assert(string.len() == 1);

        string.push(NUMBER1);
        assert(string.nth(1).unwrap() == NUMBER1);
        assert(string.len() == 2);

        string.push(NUMBER2);
        assert(string.nth(2).unwrap() == NUMBER2);
        assert(string.len() == 3);

        string.push(NUMBER3);
        assert(string.nth(3).unwrap() == NUMBER3);
        assert(string.len() == 4);

        string.push(NUMBER4);
        assert(string.nth(4).unwrap() == NUMBER4);
        assert(string.len() == 5);

        string.push(NUMBER5);
        assert(string.nth(5).unwrap() == NUMBER5);
        assert(string.len() == 6);

        string.push(NUMBER6);
        assert(string.nth(6).unwrap() == NUMBER6);
        assert(string.len() == 7);

        string.push(NUMBER7);
        assert(string.nth(7).unwrap() == NUMBER7);
        assert(string.len() == 8);

        string.push(NUMBER8);
        assert(string.nth(8).unwrap() == NUMBER8);
        assert(string.len() == 9);

        string.push(NUMBER1);
        assert(string.nth(9).unwrap() == NUMBER1);
        assert(string.len() == 10);

        string.clear();
        assert(string.len() == 0);
        assert(string.is_empty());

        string.push(NUMBER1);
        assert(string.nth(0).unwrap() == NUMBER1);
        assert(string.len() == 1);

        string.push(NUMBER1);
        assert(string.nth(1).unwrap() == NUMBER1);
        assert(string.len() == 2);

        string.push(NUMBER0);
        assert(string.nth(2).unwrap() == NUMBER0);
        assert(string.len() == 3);
    }

    fn test_remove() {
        let mut string = String::new();

        string.push(NUMBER0);
        string.push(NUMBER1);
        string.push(NUMBER2);
        string.push(NUMBER3);
        string.push(NUMBER4);
        string.push(NUMBER5);

        assert(string.len() == 6);

        assert(string.remove(0) == NUMBER0);
        assert(string.len() == 5);

        assert(string.remove(0) == NUMBER1);
        assert(string.len() == 4);

        assert(string.remove(1) == NUMBER3);
        assert(string.len() == 3);

        assert(string.remove(string.len() - 1) == NUMBER5);
        assert(string.len() == 2);

        assert(string.remove(1) == NUMBER4);
        assert(string.len() == 1);

        assert(string.remove(0) == NUMBER2);
        assert(string.len() == 0);

        string.push(NUMBER6);
        assert(string.remove(0) == NUMBER6);
        assert(string.len() == 0);
    }

    fn test_with_capacity() {
        let mut iterator = 0;

        while iterator < 16 {
            let mut string = String::with_capacity(iterator);
            assert(string.capacity() == iterator);
            iterator += 1;
        }

        let mut string = String::with_capacity(0);
        assert(string.capacity() == 0);

        string.push(NUMBER0);
        assert(string.capacity() == 1);

        string.push(NUMBER1);
        assert(string.capacity() == 2);

        string.push(NUMBER2);
        assert(string.capacity() == 4);

        string.clear();
        assert(string.capacity() == 4);

        let mut string = String::with_capacity(4);

        assert(string.capacity() == 4);

        string.push(NUMBER0);
        assert(string.capacity() == 4);
        string.push(NUMBER1);
        assert(string.capacity() == 4);

        string.push(NUMBER2);
        assert(string.capacity() == 4);

        string.push(NUMBER3);
        assert(string.capacity() == 4);

        string.push(NUMBER4);
        assert(string.capacity() == 8);
    }
}
