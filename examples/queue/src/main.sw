library;

// ANCHOR: import
use queue::*;
// ANCHOR_END: import

fn instantiate() {
    // ANCHOR: instantiate
    let mut queue = Queue::new();
    // ANCHOR_END: instantiate
}

fn enqueue() {
    let mut queue = Queue::new();

    // ANCHOR: enqueue
    // Enqueue an element to the queue
    queue.enqueue(10u8);
    // ANCHOR_END: enqueue
}

fn dequeue() {
    let mut queue = Queue::new();
    queue.enqueue(10u8);

    // ANCHOR: dequeue
    // Dequeue the first element and unwrap the value
    let first_item = queue.dequeue().unwrap();
    // ANCHOR_END: dequeue
}

fn peek() {
    let mut queue = Queue::new();
    queue.enqueue(10u8);

    // ANCHOR: peek
    // Peek at the head of the queue
    let head_item = queue.peek();
    // ANCHOR_END: peek
}

fn length() {
    let mut queue = Queue::new();
    // ANCHOR: length
    // Checks if queue is empty (returns True or False)
    let is_queue_empty = queue.is_empty();

    // Returns length of queue
    let queue_length = queue.len();
    // ANCHOR_END: length
}
