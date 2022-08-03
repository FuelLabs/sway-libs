library string;

use std::{
    vec::Vec,
};

struct String<S> {
    bytes: Vec<u8>
}

impl<S> String<S> {

    /// Appends an element to the back of the `String<S>`.
    pub fn append(mut self, value: u8) {
        bytes.push(value);
    }

    /// Returns the bytes stored for the `String<S>`.
    pub fn as_bytes(self) -> Vec<u8> {
        self.vec
    }

    // Not possible?
    // pub fn as_str(self) -> S {
    //     self
    // }

    /// Gets the capacity of the allocation.
    pub fn capacity(self) -> u64 {
        self.vec.capacity()
    }

    /// Truncates this `String`, removing all contents.
    ///
    /// While this means the `String` will have a length of zero, it does not
    /// touch its capacity.
    pub fn clear(mut self) {
        self.vec.clear()
    }

    /// Attempts to convert a static `str` to a `String<S>`
    pub fn from_str(mut self, value: S) {
        let len = size_of::<value>();
        let mut ptr = addr_of(value);
        let mut iterator = 0;

        while iterator < len {
            self.bytes.push(read(ptr + iterator));
            iterator += 1;
        }
    }

    /// Returns `true` if the vector contains no elements.
    pub fn is_empty(self) -> bool {
        self.vec.is_empty()
    }

    /// Returns the number of elements in the vector, also referred to
    /// as its 'length'.
    pub fn len(self) -> u64 {
        self.bytes.len()
    }

    /// Constructs a new, empty `String<S>`.
    pub fn new() -> Self {
        Self {
            bytes: ~Vec::new()
        }
    }

    /// Constructs a new, empty `String<S>` with the specified capacity.
    pub fn with_capacity(capacity: u64) -> Self {
        Self {
            bytes:: ~Vec::with_capacity(capacity)
        }
    }
}
