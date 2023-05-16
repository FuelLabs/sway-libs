library;
//! The `Stack` type corresponds to the same called data structure.
//! A Stack is defined as a linear data structure that is open at the only ends and the operations are performed in Last In First Out order.

pub struct Stack<T> {
    vec: Vec<T>,
}

impl<T> Stack<T> {
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

    pub fn push(self, value: T) {
        self.vec.push(value);
    }

    pub fn pop(self) -> Option<T> {
        self.vec.pop()
    }

    pub fn peek(self) -> Option<T> {
        if self.vec.is_empty() {
            Option::None
        } else {
            self.vec.get(self.vec.len() - 1)
        }
    }
}

#[test]
fn test_new_stack_is_empty() {
    let stack: Stack<i32> = Stack::new();
    assert(stack.is_empty());
}

#[test]
fn test_push_single_element() {
    let mut stack = Stack::new();
    stack.push(42);
    assert(stack.len() == 1);
    assert(!stack.is_empty());
}

#[test]
fn test_push_multiple_elements() {
    let mut stack = Stack::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    assert(stack.len() == 3);
    assert(!stack.is_empty());
}

#[test]
fn test_pop_empty_stack() {
    let mut stack: Stack<i32> = Stack::new();
    let popped = stack.pop();
    assert(popped.is_none());
    assert(stack.len() == 0);
    assert(stack.is_empty());
}

#[test]
fn test_pop_single_element() {
    let mut stack = Stack::new();
    stack.push(42);
    let popped = stack.pop();
    assert(popped.unwrap() == 42);
    assert(stack.len() == 0);
    assert(stack.is_empty());
}

#[test]
fn test_pop_multiple_elements() {
    let mut stack = Stack::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    let popped1 = stack.pop();
    assert(popped1.unwrap() == 3);
    assert(stack.len() == 2);
    assert(!stack.is_empty());

    let popped2 = stack.pop();
    assert(popped2.unwrap() == 2);
    assert(stack.len() == 1);
    assert(!stack.is_empty());

    let popped3 = stack.pop();
    assert(popped3.unwrap() == 1);
    assert(stack.len() == 0);
    assert(stack.is_empty());

    let popped4 = stack.pop();
    assert(popped4.is_none());
    assert(stack.len() == 0);
    assert(stack.is_empty());
}

#[test]
fn test_peek_empty_stack() {
    let stack: Stack<i32> = Stack::new();
    let peeked = stack.peek();
    assert(peeked.is_none());
    assert(stack.len() == 0);
    assert(stack.is_empty());
}

#[test]
fn test_peek_single_element() {
    let mut stack = Stack::new();
    stack.push(42);
    let peeked = stack.peek();
    assert(peeked.unwrap() == 42);
    assert(stack.len() == 1);
    assert(!stack.is_empty());
}

#[test]
fn test_peek_multiple_elements() {
    let mut stack = Stack::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    let peeked = stack.peek();
    assert(peeked.unwrap() == 3);
    assert(stack.len() == 3);
    assert(!stack.is_empty());
}
