library;

use hash_map::*;

fn new() {
    // ANCHOR: new
    let map: HashMap<u64, u64> = HashMap::new();
    // ANCHOR_END: new
}

fn with_capacity() {
    // ANCHOR: with_capacity
    let map: HashMap<u64, u64> = HashMap::with_capacity(100);
    // ANCHOR_END: with_capacity
}

fn insert() {
    let mut map: HashMap<u64, u64> = HashMap::new();
    // ANCHOR: insert
    // New insertion
    let res = map.insert(1, 10);
    assert(res.is_none()); 

    // Updates
    let res = map.insert(1, 20);
    assert(res == Some(10));
    // ANCHOR_END: insert
}

fn try_insert() {
    let mut map: HashMap<u64, u64> = HashMap::new();
    // ANCHOR: try_insert
    // New insertion
    let res = map.try_insert(1, 10);
    assert(res.is_ok()); 

    // Update
    let res = map.try_insert(1, 20);
    assert(res == Err(HashMapError::OccupiedError(10)));
    // ANCHOR_END: try_insert
}

fn remove() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: remove    
    map.insert(1, 10);

    let res = map.remove(1);
    assert(res == Some(10));

    let res = map.remove(1);
    assert(res.is_none());
    // ANCHOR_END: remove
}

fn get() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: get    
    map.insert(1, 10);

    let res = map.get(1);
    assert(res == Some(10));

    let res = map.get(2);
    assert(res.is_none());
    // ANCHOR_END: get
}

fn contains_key() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: contains_key    
    map.insert(1, 10);

    assert(map.contains_key(1));
    assert(!map.contains_key(2));
    // ANCHOR_END: contains_key
}

fn keys() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: keys    
    map.insert(1, 10);
    map.insert(2, 20);

    let keys: Vec<u64> = map.keys();
    assert(keys.len() == 2);
    // ANCHOR_END: keys
}

fn values() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: values    
    map.insert(1, 10);
    map.insert(2, 20);
    map.insert(3, 30);

    let values: Vec<u64> = map.values();
    assert(values.len() == 3);
    // ANCHOR_END: values
}

fn len() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: len    
    assert(map.len() == 0);

    map.insert(1, 10);
    assert(map.len() == 1);
    // ANCHOR_END: len
}

fn capacity() {
    // ANCHOR: capacity    
    let map: HashMap<u64, u64> = HashMap::with_capacity(10);
    assert(map.capacity() == 10);
    // ANCHOR_END: capacity
}

fn is_empty() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: is_empty    
    assert(map.is_empty());

    map.insert(1, 10);
    assert(!map.is_empty());
    // ANCHOR_END: is_empty
}

fn iter() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: iter    
    map.insert(1, 10);

    let mut iter = map.iter();
    assert(iter.next() == Some((1, 10)));
    assert(iter.next().is_none());
    // ANCHOR_END: iter
}

fn for_loop() {
    let mut map: HashMap<u64, u64> = HashMap::new();

    // ANCHOR: for   
    for (key, value) in map.iter() {
        // Process pairs
    }
    // ANCHOR_END: for
}
