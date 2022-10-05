library string;

use std::{option::Option, vec::Vec};

pub struct String<S> {
    bytes: Vec<u8>,
}

impl<S> String<S> {
    /// Returns the bytes stored for the `String<S>`.
    pub fn as_bytes(self) -> Vec<u8> {
        self.bytes
    }

    /// Gets the capacity of the allocation.
    pub fn capacity(self) -> u64 {
        self.bytes.capacity()
    }

    /// Truncates this `String`, removing all contents.
    /// 
    /// While this means the `String` will have a length of zero, it does not
    /// touch its capacity.
    pub fn clear(self) {
        self.bytes.clear()
    }

    /// Converts a vector of bytes to a `String`.
    pub fn from_utf8(vec: Vec<u8>) -> String<S> {
        String { bytes: vec }
    }

    // Inserts a character at the index within the string.
    pub fn insert(self, index: u64, character: u8) {
        self.bytes.insert(index, character);
    }

    /// Returns `true` if the vector contains no elements.
    pub fn is_empty(self) -> bool {
        self.bytes.is_empty()
    }

    /// Returns the number of elements in the vector, also referred to
    /// as its 'length'.
    pub fn len(self) -> u64 {
        self.bytes.len()
    }

    /// Constructs a new, empty `String<S>`.
    pub fn new() -> Self {
        Self {
            bytes: ~Vec::new(),
        }
    }

    /// Returns the element found at the index of given.
    pub fn nth(self, index: u64) -> Option<u8> {
        self.bytes.get(index)
    }

    /// Removes the last character from the string buffer and returns it.
    pub fn pop(self) -> Option<u8> {
        self.bytes.pop()
    }

    /// Appends an element to the back of the `String<S>`.
    pub fn push(self, value: u8) {
        self.bytes.push(value);
    }

    /// Removes and returns the element at position `index` within the string.
    pub fn remove(self, index: u64) -> u8 {
        self.bytes.remove(index)
    }

    /// Constructs a new, empty `String<S>` with the specified capacity.
    pub fn with_capacity(capacity: u64) -> Self {
        Self {
            bytes: ~Vec::with_capacity(capacity),
        }
    }
}
