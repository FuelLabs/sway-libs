library;
//! The `Deque` type corresponds to the same called data structure.
//! A Deque is defined as a linear data structure that allows insertion and removal of elements from both ends in other words it's a double-ended queue.

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

    // Returns an element from front, in case the `Deque` is empty `None` is returned
    pub fn pop_front(ref mut self) -> Option<T> {
        if self.front.is_empty() {
            if !self.back.is_empty() {
                self.front.push(self.back.remove(0))
            }
        }
        self.front.pop()
    }

    // Returns an element from back, in case the `Deque` is empty `None` is returned
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

#[test()]
fn test_new_deque() {
    let new_deque: Deque<u64> = Deque::new();
    assert(new_deque.is_empty());
    assert(new_deque.len() == 0);
}

#[test()]
fn test_deque_push_front() {
    let mut deque_push_front = Deque::new();
    let mut deque_len = deque_push_front.len();
    assert(deque_len == 0);
    deque_push_front.push_front(1);
    assert(deque_push_front.len() == deque_len + 1);
    deque_len = deque_push_front.len();
    deque_push_front.push_front(2);
    assert(deque_push_front.len() == deque_len + 1);
    deque_len = deque_push_front.len();
    deque_push_front.push_front(3);
    assert(deque_push_front.len() == deque_len + 1);

    deque_len = deque_push_front.len();
    assert(deque_push_front.pop_front().unwrap() == 3);
    assert(deque_push_front.len() == deque_len - 1);
    deque_len = deque_push_front.len();
    assert(deque_push_front.pop_front().unwrap() == 2);
    assert(deque_push_front.len() == deque_len - 1);
    deque_len = deque_push_front.len();
    assert(deque_push_front.pop_front().unwrap() == 1);
    assert(deque_push_front.len() == deque_len - 1);
    assert(deque_push_front.pop_front().is_none());
}

#[test()]
fn test_deque_push_front_push_back_pop_front() {
    let mut deque_push_back = Deque::new();
    let mut deque_len = deque_push_back.len();
    assert(deque_len == 0);
    deque_push_back.push_front(1);
    assert(deque_push_back.len() == deque_len + 1);
    deque_len = deque_push_back.len();
    deque_push_back.push_back(1);
    assert(deque_push_back.len() == deque_len + 1);
    deque_len = deque_push_back.len();
    deque_push_back.push_back(2);
    assert(deque_push_back.len() == deque_len + 1);
    deque_len = deque_push_back.len();
    deque_push_back.push_back(3);
    assert(deque_push_back.len() == deque_len + 1);

    deque_len = deque_push_back.len();
    assert(deque_push_back.pop_front().unwrap() == 1);
    assert(deque_push_back.len() == deque_len - 1);
    deque_len = deque_push_back.len();
    assert(deque_push_back.pop_front().unwrap() == 1);
    assert(deque_push_back.len() == deque_len - 1);
    deque_len = deque_push_back.len();
    assert(deque_push_back.pop_front().unwrap() == 2);
    assert(deque_push_back.len() == deque_len - 1);
    deque_len = deque_push_back.len();
    assert(deque_push_back.pop_front().unwrap() == 3);
    assert(deque_push_back.len() == deque_len - 1);
    assert(deque_push_back.pop_front().is_none());
}

#[test()]
fn test_deque_push_pop_front() {
    let mut deque = Deque::new();
    assert(deque.len() == 0);
    deque.push_front(1);
    assert(deque.len() == 1);
    deque.push_front(2);
    assert(deque.len() == 2);
    let _ = deque.pop_front();
    assert(deque.len() == 1);
}
