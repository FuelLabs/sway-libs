library;
//! The `Deque` type corresponds to the same called data structure.
//! A Deque is defined as a linear data structure that allows insertion and removal of elements from both ends.

pub struct Deque<T> {
    front: Vec<T>,
    back: Vec<T>,
}

impl<T> Deque<T> {
    /// Creates a new, empty deque.
    pub fn new() -> Self {
        Self {
            front: Vec::new(),
            back: Vec::new(),
        }
    }

    /// Creates a new, empty deque with the specified capacity.
    pub fn with_capacity(capacity: u64) -> Self {
        Self {
            front: Vec::with_capacity(capacity),
            back: Vec::with_capacity(capacity),
        }
    }

    /// Appends an element to the back of the deque.
    pub fn push_back(ref mut self, value: T) {
        self.back.push(value);
    }

    /// Inserts an element at the front of the deque.
    pub fn push_front(ref mut self, value: T) {
        self.front.push(value);
    }

    pub fn pop_front(ref mut self) -> Option<T> {
        if self.front.is_empty() {
            if !self.back.is_empty() {
                self.front.push(self.back.remove(0))
            }
        }
        self.front.pop()
    }

    pub fn pop_back(ref mut self) -> Option<T> {
        if self.back.is_empty() {
            if !self.front.is_empty() {
                self.back.push(self.front.remove(0))
            }
        }
        self.back.pop()
    }

    /// Returns the number of elements in the deque.
    pub fn len(self) -> u64 {
        self.front.len() + self.back.len()
    }

    /// Returns `true` if the deque is empty.
    pub fn is_empty(self) -> bool {
        self.front.is_empty() && self.back.is_empty()
    }

    /// Removes all elements from the deque.
    pub fn clear(self) {
        self.front.clear();
        self.back.clear();
    }

    /// Returns the maximum number of elements the deque can hold without reallocating.
    pub fn capacity(self) -> u64 {
        self.front.capacity() + self.back.capacity()
    }
}
