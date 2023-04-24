library;

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

    pub fn enqueue(ref mut self, item: T) {
        self.vec.push(item);
    }

    pub fn dequeue(ref mut self) -> Option<T> {
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

#[test()]
fn test_new_queue() {
    let new_queue: Queue<u64> = Queue::new();
    assert(new_queue.is_empty() == true);
    assert(new_queue.len() == 0);
}


#[test()]
fn test_enqueue() {
    let mut queue_for_enqueue: Queue<u64> = Queue::new();
    queue_for_enqueue.enqueue(1);
    queue_for_enqueue.enqueue(2);
    queue_for_enqueue.enqueue(3);
    assert(queue_for_enqueue.len() == 3);
}

#[test()]
fn test_dequeue() {
    let mut queue_for_dequeue: Queue<u64> = Queue::new();
    queue_for_dequeue.enqueue(1);
    queue_for_dequeue.enqueue(2);
    queue_for_dequeue.enqueue(3);
    assert(queue_for_dequeue.dequeue().unwrap() == 1);
    assert(queue_for_dequeue.dequeue().unwrap() == 2);
    assert(queue_for_dequeue.dequeue().unwrap() == 3);
    assert(queue_for_dequeue.dequeue().is_none());
    assert(queue_for_dequeue.len() == 0);
}

#[test()]
fn test_queue_peek() {
    let mut queue_for_peek: Queue<u64> = Queue::new();
    queue_for_peek.enqueue(1);
    queue_for_peek.enqueue(2);
    assert(queue_for_peek.peek().unwrap() == 1);
    assert(queue_for_peek.peek().unwrap() == 1);
    let _ = queue_for_peek.dequeue();
    assert(queue_for_peek.peek().unwrap() == 2);
    let _ = queue_for_peek.dequeue();
    assert(queue_for_peek.peek().is_none());
}

#[test()]
fn test_queue_empty() {
    let mut ve: Vec<u64> = Vec::new();
    ve.push(1);
    std::logging::log(ve.len());
    let _ = ve.remove(0);
    std::logging::log(ve.len());
    let mut queue_for_empty: Queue<u64> = Queue::new();
    assert(queue_for_empty.is_empty());
    queue_for_empty.enqueue(1002000);
    // queue_for_empty.enqueue(1002000);
    assert(!queue_for_empty.is_empty());
    // let _ = queue_for_empty.dequeue();
    let _ = queue_for_empty.dequeue();
    // assert(queue_for_empty.is_empty());
}
