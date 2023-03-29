library queue;

use std::vec::Vec;

pub struct Queue<T> {
    vec: Vec<T>,
}

impl<T> Queue<T> {
    pub fn new() -> Self {
        Self {
            vec: Vec::new(),
        }
    }

    pub fn is_empty(self) -> bool {
        self.vec.is_empty()
    }

    pub fn len(self) -> u64 {
        self.vec.len()
    }

    pub fn enqueue(mut self, item: T) {
        self.vec.push(item);
    }

    pub fn dequeue(mut self) -> Option<T> {
        if self.vec.is_empty() {
            Option::None
        } else {
            Option::Some(self.vec.remove(0))
        }
    }

    pub fn peek(self) -> Option<T> {
        self.vec.get(0)
    }
}
