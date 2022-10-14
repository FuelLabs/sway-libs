library string;

pub struct String {
    bytes: Vec<u8>,
}

impl String {
    /// Returns the bytes stored for the `String`.
    pub fn as_bytes(self) -> Vec<u8> {
        self.bytes
    }

    /// Gets the amount of memory on the heap allocated to the `String`.
    pub fn capacity(self) -> u64 {
        self.bytes.capacity()
    }

    /// Truncates this `String` to a length of zero, removing all contents.
    pub fn clear(self) {
        self.bytes.clear()
    }

    /// Converts a vector of bytes to a `String`.
    ///
    /// # Arguments
    ///
    /// * `bytes` - The vector of `u8` bytes which will be converted into a `String`.
    pub fn from_utf8(bytes: Vec<u8>) -> String {
        String { bytes }
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
            bytes: ~Vec::new(),
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

    /// Constructs a new instance of the `String` type with the specified capacity.
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
