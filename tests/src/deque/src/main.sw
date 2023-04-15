script;

use deque::Deque;
use std::assert::assert;

fn main() -> bool {
    let mut deque_push_front = Deque::new();
    deque_push_front.push_front(1);
    deque_push_front.push_front(2);
    deque_push_front.push_front(3);

    assert(deque_push_front.pop_front().unwrap() == 3);
    assert(deque_push_front.pop_front().unwrap() == 2);
    assert(deque_push_front.pop_front().unwrap() == 1);
    assert(deque_push_front.pop_front().is_none());

    let mut deque_push_back = Deque::new();
    deque_push_back.push_back(1);
    deque_push_back.push_back(2);
    deque_push_back.push_back(3);

    assert(deque_push_back.pop_front().unwrap() == 1);
    assert(deque_push_back.pop_front().unwrap() == 2);
    assert(deque_push_back.pop_front().unwrap() == 3);
    assert(deque_push_back.pop_front().is_none());

    let mut deque = Deque::new();
    assert(deque.len() == 0);
    deque.push_front(1);
    assert(deque.len() == 1);
    deque.push_front(2);
    assert(deque.len() == 2);
    let _ = deque.pop_front();
    assert(deque.len() == 1);

    true
}