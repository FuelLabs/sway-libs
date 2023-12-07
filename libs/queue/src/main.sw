library;
/// The `Queue` type corresponds to the same called data structure.
///
/// # Additional Information
///
/// A Queue is defined as a linear data structure that is open at both ends and the operations are performed in First In First Out order.
/// Meaning additions to the list are made at one end, and all deletions from the list are made at the other end.
pub struct Queue<T> {
    /// The underlying vector that stored the elements of the `Queue`.
    vec: Vec<T>,
}

impl<T> Queue<T> {
    /// Create a new `Queue`.
    ///
    /// # Returns
    ///
    /// * [Queue] - The newly created `Queue` struct.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use queue::Queue;
    ///
    /// fn foo() {
    ///     let queue = Queue::new::<u64>();
    ///     assert(queue.is_empty());
    /// }
    /// ```
    pub fn new() -> Self {
        Self {
            vec: Vec::new(),
        }
    }

    /// Checks a `Queue` for emptiness.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` indicated that the queue does not contain any elements, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use queue::Queue;
    ///
    /// fn foo() {
    ///     let queue = Queue::new::<u64>();
    ///     assert(queue.is_empty());
    /// }
    /// ```
    pub fn is_empty(self) -> bool {
        self.vec.is_empty()
    }

    /// Gets the number of elements in the `Queue`.
    ///
    /// # Returns
    ///
    /// * [u64] - The total number of elements.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use queue::Queue;
    ///
    /// fn foo() {
    ///     let mut queue = Queue::new::<u64>();
    ///     assert(queue.len() == 0);
    ///     queue.enqueue(5);
    ///     assert(queue.len() == 1);
    /// }
    /// ```
    pub fn len(self) -> u64 {
        self.vec.len()
    }

    /// Enqueues an element in the `Queue`, adding it to the end of the queue.
    ///
    /// # Arguments
    ///
    /// * `item`: [T] - The value to enqueue.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use queue::Queue;
    ///
    /// fn foo() {
    ///     let mut queue = Queue::new::<u64>();
    ///     queue.enqueue(5);
    ///     assert(queue.peek().unwrap() == 5);
    /// }
    /// ```
    pub fn enqueue(ref mut self, item: T) {
        self.vec.push(item);
    }

    /// Dequeues the `Queue` and returns the oldest element.
    ///
    /// # Returns
    ///
    /// * [Option<T>] - The first element to be enqueued or `None` if the queue is empty.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use queue::Queue;
    ///
    /// fn foo() {
    ///     let mut queue = Queue::new::<u64>();
    ///     queue.enqueue(5);
    ///     let element = queue.dequeue().unwrap();
    ///     assert(element == 5);
    ///     assert(queue.len() == 0);
    /// }
    /// ```
    pub fn dequeue(ref mut self) -> Option<T> {
        if self.vec.is_empty() {
            return Option::None;
        }

        return Option::Some(self.vec.remove(0));
    }

    /// Gets the head of the queue without dequeueing the element.
    ///
    /// # Returns
    ///
    /// * [Option<T>] - The first element to be enqueued or `None` if the queue is empty.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use queue::Queue;
    ///
    /// fn foo() {
    ///     let mut queue = Queue::new::<u64>();
    ///     queue.enqueue(5);
    ///     let element = queue.peek().unwrap();
    ///     assert(queue.len() == 1);
    /// }
    /// ```
    //      assert(element == 5);
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
    assert(queue_len == 1);
    queue_for_enqueue.enqueue(2);
    assert(queue_for_enqueue.len() == queue_len + 1);
}

#[test()]
fn test_dequeue() {
    let mut queue_for_dequeue: Queue<u64> = Queue::new();
    queue_for_dequeue.enqueue(1);
    queue_for_dequeue.enqueue(2);
    queue_for_dequeue.enqueue(3);
    assert(queue_for_dequeue.len() == 3);
    assert(queue_for_dequeue.dequeue().unwrap() == 1);
    assert(queue_for_dequeue.len() == 2);
    assert(queue_for_dequeue.dequeue().unwrap() == 2);
    assert(queue_for_dequeue.len() == 1);
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
