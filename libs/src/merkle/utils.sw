library;

/// Calculates the starting bit of the path to a leaf
///
/// # Additional Information
///
/// **WARNING:** This function will be private when https://github.com/FuelLabs/sway/issues/5765 is resolved.
///
/// # Arguments
///
/// * `num_leaves`: [u64] - The number of leaves in the Merkle Tree.
///
/// # Returns
///
/// * [u64] - The starting bit.
pub fn starting_bit(num_leaves: u64) -> u64 {
    let mut starting_bit = 0;

    while (1 << starting_bit) < num_leaves {
        starting_bit = starting_bit + 1;
    }

    starting_bit
}

/// Calculates the length of the path to a leaf
///
/// # Additional Information
///
/// **WARNING:** This function will be private when https://github.com/FuelLabs/sway/issues/5765 is resolved.
///
/// # Arguments
///
/// * `key`: [u64] - The key or index of the leaf.
/// * `num_leaves`: [u64] - The total number of leaves in the Merkle Tree.
///
/// # Returns
///
/// * [u64] - The length from the leaf to a root.
pub fn path_length_from_key(key: u64, num_leaves: u64) -> u64 {
    let mut total_length = 0;
    let mut num_leaves = num_leaves;
    let mut key = key;

    while true {
        // The height of the left subtree is equal to the offset of the starting bit of the path
        let path_length = starting_bit(num_leaves);
        // Determine the number of leaves in the left subtree
        let num_leaves_left_sub_tree = (1 << (path_length - 1));

        if key <= (num_leaves_left_sub_tree - 1) {
            // If the leaf is in the left subtreee, path length is full height of the left subtree
            total_length = total_length + path_length;
            break;
        } else if num_leaves_left_sub_tree == 1 {
            // If the left sub tree has only one leaf, path has one additional step
            total_length = total_length + 1;
            break;
        } else if (num_leaves - num_leaves_left_sub_tree) <= 1 {
            // If the right sub tree only has one leaf, path has one additonal step
            total_length = total_length + 1;
            break;
        } else {
            // Otherwise add 1 to height and loop
            total_length = total_length + 1;
            key = key - num_leaves_left_sub_tree;
            num_leaves = num_leaves - num_leaves_left_sub_tree;
        }
    }

    total_length
}
