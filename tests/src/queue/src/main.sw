script;

use queue::Queue;
use std::assert::assert;

fn main() -> bool {
    let new_queue: Queue<u64> = Queue::new();
    assert(new_queue.is_empty() == true);
    assert(new_queue.len() == 0);

    let mut queue_for_enqueue: Queue<u64> = Queue::new();
    queue_for_enqueue.enqueue(1);
    queue_for_enqueue.enqueue(2);
    queue_for_enqueue.enqueue(3);
    assert(queue_for_enqueue.len() == 3);

    let mut queue_for_dequeue: Queue<u64> = Queue::new();
    queue_for_dequeue.enqueue(1);
    queue_for_dequeue.enqueue(2);
    queue_for_dequeue.enqueue(3);
    assert(queue_for_dequeue.dequeue().unwrap() == 1);
    assert(queue_for_dequeue.dequeue().unwrap() == 2);
    assert(queue_for_dequeue.dequeue().unwrap() == 3);
    assert(queue_for_dequeue.dequeue().is_none());
    assert(queue_for_dequeue.len() == 0);

    let mut queue_for_peek: Queue<u64> = Queue::new();
    queue_for_peek.enqueue(1);
    queue_for_peek.enqueue(2);
    assert(queue_for_peek.peek().unwrap() == 1);
    assert(queue_for_peek.peek().unwrap() == 1);
    let _ = queue_for_peek.dequeue();
    assert(queue_for_peek.peek().unwrap() == 2);
    let _ = queue_for_peek.dequeue();
    assert(queue_for_peek.peek().is_none());

    let mut queue_for_empty: Queue<u64> = Queue::new();
    assert(queue_for_empty.is_empty());
    queue_for_empty.enqueue(1);
    assert(!queue_for_empty.is_empty());
    let _ = queue_for_empty.dequeue();
    assert(queue_for_empty.is_empty());

    true
}
