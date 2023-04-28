// The `Queue` type corresponds to the same data structure.
library;

pub struct Queue<T> {
    vec: Vec<T>,
}

impl<T> Queue<T> {
    /// Create a new `Queue`
    pub fn new() -> Self {
        Self {
            vec: Vec::new(),
        }
    }

    /// Checks a `Queue` for emptiness
    pub fn is_empty(self) -> bool {
        self.vec.is_empty()
    }

    /// Gets the number of elements in the `Queue`
    pub fn len(self) -> u64 {
        self.vec.len()
    }

    /// Enqueues a `Queue`
    pub fn enqueue(ref mut self, item: T) {
        self.vec.push(item);
    }

    /// Dequeues a `Queue`
    pub fn dequeue(ref mut self) -> Option<T> {
        if self.vec.is_empty() {
            return Option::None;
        }

        return Option::Some(self.vec.remove(0));
    }

    /// Gets the head of the queue
    pub fn peek(self) -> Option<T> {
        self.vec.get(0)
    }
}

#[test()]
fn test_new_queue() {
    let new_queue: Queue<u64> = Queue::new();
    assert(new_queue.is_empty());
    assert(new_queue.len() == 0);
}

#[test()]
fn test_enqueue() {
    let mut queue_for_enqueue: Queue<u64> = Queue::new();
    queue_for_enqueue.enqueue(1);
    let queue_len = queue_for_enqueue.len();
    queue_for_enqueue.enqueue(2);
    assert(queue_for_enqueue.len() == queue_len + 1);
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
    let mut queue_for_empty: Queue<u64> = Queue::new();
    assert(queue_for_empty.is_empty());
    queue_for_empty.enqueue(1);
    assert(!queue_for_empty.is_empty());
    let _ = queue_for_empty.dequeue();
    assert(queue_for_empty.is_empty());
}
