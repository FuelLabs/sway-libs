library string;

use std::bytes::Bytes;

pub struct String {
    bytes: Bytes,
}

impl String {
    /// Returns the bytes stored for the `String`.
    pub fn as_bytes(self) -> Bytes {
        self.bytes
    }

    /// Returns a `Vec<u8>` of the bytes stored for the `String`.
    pub fn as_vec(self) -> Vec<u8> {
        self.bytes.into_vec_u8()
    }

    /// Gets the amount of memory on the heap allocated to the `String`.
    pub fn capacity(self) -> u64 {
        self.bytes.capacity()
    }

    /// Truncates this `String` to a length of zero, removing all contents.
    pub fn clear(self) {
        self.bytes.clear()
    }

    /// Converts bytes to a `String`.
    ///
    /// # Arguments
    ///
    /// * `bytes` - The bytes which will be converted into a `String`.
    pub fn from_bytes(bytes: Bytes) -> String {
        String { bytes }
    }

    /// Converts a vector of bytes to a `String`.
    ///
    /// # Arguments
    ///
    /// * `bytes` - The vector of `u8` bytes which will be converted into a `String`.
    pub fn from_utf8(mut bytes: Vec<u8>) -> String {
        String { bytes: Bytes::from_vec_u8(bytes) }
    }

    /// Inserts a byte at the index within the `String`.
    ///
    /// # Arguments
    ///
    /// * `byte` - The element which will be added to the `String`.
    /// * `index` - The position in the `String` where the byte will be inserted.
    pub fn insert(self, byte: u8, index: u64) {
        self.bytes.insert(index, byte);
    }

    /// Returns `true` if the vector contains no bytes.
    pub fn is_empty(self) -> bool {
        self.bytes.is_empty()
    }

    /// Returns the number of bytes in the `String`, also referred to
    /// as its 'length'.
    pub fn len(self) -> u64 {
        self.bytes.len()
    }

    /// Constructs a new instance of the `String` type.
    pub fn new() -> Self {
        Self {
            bytes: Bytes::new(),
        }
    }

    /// Returns the byte at the specified index.
    ///
    /// # Arguments
    ///
    /// * `index` - The position of the byte that will be returned.
    pub fn nth(self, index: u64) -> Option<u8> {
        self.bytes.get(index)
    }

    /// Removes the last byte from the `String` buffer and returns it.
    pub fn pop(self) -> Option<u8> {
        self.bytes.pop()
    }

    /// Appends a byte to the end of the `String`.
    ///
    /// # Arguments
    ///
    /// * `byte` - The element to be appended to the end of the `String`.
    pub fn push(self, byte: u8) {
        self.bytes.push(byte);
    }

    /// Removes and returns the byte at the specified index.
    ///
    /// # Arguments
    ///
    /// * `index` - The position of the byte that will be removed.
    pub fn remove(self, index: u64) -> u8 {
        self.bytes.remove(index)
    }

    /// Updates a byte at position `index` with a new byte `value`.
    ///
    /// # Arguments
    ///
    /// * `index` - The index of the byte to be set.
    /// * `byte` - The value of the byte to be set.
    pub fn set(self, index: u64, byte: u8) {
        self.bytes.set(index, value);
    }

    /// Swaps two bytes.
    ///
    /// # Arguments
    ///
    /// * `byte1_index` - The index of the first byte.
    /// * `byte2_index` - The index of the second byte.
    pub fn swap(ref mut self, byte1_index: u64, byte2_index: u64) {
        self.bytes.swap(byte1_index, byte2_index);
    }

    /// Constructs a new instance of the `String` type with the specified capacity.
    ///
    /// # Arguments
    ///
    /// * `capacity` - The specified amount of memory on the heap to be allocated for the `String`.
    pub fn with_capacity(capacity: u64) -> Self {
        Self {
            bytes: Bytes::with_capacity(capacity),
        }
    }
}

// Need to use seperate impl blocks for now: https://github.com/FuelLabs/sway/issues/1548
impl String {
    /// Joins two `String`s into a single larger `String`.
    ///
    /// # Arguments
    ///
    /// * `other` - The String to join to self.
    pub fn join(ref mut self, other: self) -> Self {
        String::from_bytes(self.bytes.join(other.as_bytes()))
    }

    /// Splits a `String` at the given index, modifying the original and returning the right-hand side `String`.
    ///
    /// # Arguments
    ///
    /// * `index` - The index to split the original String at.
    pub fn split(ref mut self, index: u64) -> String {
        String::from_bytes(self.bytes.split(index))
    }
}
