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
    /// 
    /// # Arguments
    /// 
    /// * `vec` - The vector of `u8` bytes which should be converted into a `String`.
    pub fn from_utf8(vec: Vec<u8>) -> String<S> {
        String { bytes: vec }
    }

    /// Inserts a byte at the index within the `String`.
    /// 
    /// # Arguments
    /// 
    /// * `byte` - The element which is to be added to the `String`.
    /// * `index` - The position in the `String` where the element is to be inserted.
    pub fn insert(self, byte: u8, index: u64) {
        self.bytes.insert(index, byte);
    }

    /// Returns `true` if the vector contains no elements.
    pub fn is_empty(self) -> bool {
        self.bytes.is_empty()
    }

    /// Returns the number of elements in the `String`, also referred to
    /// as its 'length'.
    pub fn len(self) -> u64 {
        self.bytes.len()
    }

    /// Constructs a new, empty `String`.
    pub fn new() -> Self {
        Self {
            bytes: ~Vec::new(),
        }
    }

    /// Returns the element found at the index of given.
    /// 
    /// # Arguments
    /// 
    /// * `index` - The position of the element to be returned from the `String`.
    pub fn nth(self, index: u64) -> Option<u8> {
        self.bytes.get(index)
    }

    /// Removes the last character from the `String` buffer and returns it.
    pub fn pop(self) -> Option<u8> {
        self.bytes.pop()
    }

    /// Appends an element to the back of the `String`.
    /// 
    /// # Arguments
    /// 
    /// * `byte` - The element to be appended to the end of the `String`.
    pub fn push(self, byte: u8) {
        self.bytes.push(byte);
    }

    /// Removes and returns the element at the specified index within the `String`.
    /// 
    /// # Arguments
    /// 
    /// * `index` - The position of the element in the `String` to be removed.
    pub fn remove(self, index: u64) -> u8 {
        self.bytes.remove(index)
    }

    /// Constructs a new, empty `String` with the specified capacity.
    /// 
    /// # Arguments
    /// 
    /// * `capacity` - The specified amount of memory on the heap to be allocated for the `String`.
    pub fn with_capacity(capacity: u64) -> Self {
        Self {
            bytes: ~Vec::with_capacity(capacity),
        }
    }
}
