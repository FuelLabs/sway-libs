library;

// TODO: Replace `Vec<b256>` with `ProofSet` when https://github.com/FuelLabs/fuels-rs/issues/1603 is resolved
use ::merkle::common::{LEAF, MerkleRoot, node_digest, ProofError};
use std::alloc::alloc_bytes;
use std::hash::{Hash, sha256};
use std::bytes::Bytes;

pub type MerkleTreeKey = b256;

/// An Inclusion Proof for a Sparse Merkle Tree.
pub struct InclusionProof {
    /// The underlying proof set.
    proof_set: Vec<b256>,
}

impl InclusionProof {
    /// Instantiates a new `InclusionProof` from a `Vec<b256>`.
    pub fn new(proof_set: Vec<b256>) -> Self {
        Self { proof_set }
    }

    /// Returns the underlying `Vec<b256>` of the `InclusionProof`.
    pub fn proof_set(self) -> Vec<b256> {
        self.proof_set.clone()
    }
}

pub struct ExclusionLeafData {
    /// The leaf key.
    leaf_key: MerkleTreeKey,
    /// Hash of the value of the leaf.
    leaf_value: b256,
}

impl ExclusionLeafData {
    pub fn new(leaf_key: MerkleTreeKey, leaf_value: b256) -> Self {
        Self {
            leaf_key,
            leaf_value,
        }
    }

    pub fn leaf_key(self) -> b256 {
        self.leaf_key
    }

    pub fn leaf_value(self) -> b256 {
        self.leaf_value
    }
}

pub enum ExclusionLeaf {
    Leaf: ExclusionLeafData,
    Placeholder: (),
}

pub struct ExclusionProof {
    proof_set: Vec<b256>,
    leaf: ExclusionLeaf,
}

impl ExclusionProof {
    pub fn new(proof_set: Vec<b256>, leaf: ExclusionLeaf) -> Self {
        Self {
            proof_set,
            leaf,
        }
    }

    pub fn proof_set(self) -> Vec<b256> {
        self.proof_set.clone()
    }

    pub fn leaf(self) -> ExclusionLeaf {
        self.leaf
    }
}

pub enum Proof {
    Inclusion: InclusionProof,
    Exclusion: ExclusionProof,
}

impl Proof {
    pub fn proof_set(self) -> Vec<b256> {
        match self {
            Proof::Inclusion(proof) => proof.proof_set,
            Proof::Exclusion(proof) => proof.proof_set,
        }
    }

    pub fn is_inclusion(self) -> bool {
        match self {
            Proof::Inclusion(_) => true,
            Proof::Exclusion(_) => false,
        }
    }

    pub fn is_exclusion(self) -> bool {
        match self {
            Proof::Inclusion(_) => false,
            Proof::Exclusion(_) => true,
        }
    }

    pub fn as_inclusion(self) -> InclusionProof {
        match self {
            Proof::Inclusion(proof) => proof,
            Proof::Exclusion(_) => revert(0),
        }
    }

    pub fn as_exclusion(self) -> ExclusionProof {
        match self {
            Proof::Inclusion(_) => revert(0),
            Proof::Exclusion(proof) => proof,
        }
    }
}

/// This function will compute and return the root of a Sparse Merkle Tree given a leaf, key, and corresponding proof.
///
/// # Arguments
///
/// * `key`: [MerkleTreeKey] - The key or index of the leaf to prove.
/// * `leaf_data`: [Option<Bytes>] - `Some` data that makes up the leaf on the Sparse Merkle Tree, `None` if this is an exclusion proof.
/// * `proof`: [Proof] - The Sparse Merkle proof that will be used to traverse the Sparse Merkle Tree and compute a root.
///
/// # Reverts
///
/// * When the proof is greater than 256 elements.
///
/// # Returns
///
/// * [MerkleRoot] - The calculated root.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::{sparse::{process_proof, MerkleTreeKey, Proof, InclusionProof}, common::{Vec<b256>, MerkleRoot}};
///
/// fn foo() {
///     let key = MerkleTreeKey::zero();
///     let leaf = b256::zero();
///     let mut proof_set = Vec<b256>::new();
///     proof_set.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
///     let proof = Proof::Inclusion(InclusionProof::new(proof_set));
///     let root: MerkleRoot = process_proof(key, leaf, proof);
///     assert(root == 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47);
/// }
/// ```
pub fn process_proof(key: MerkleTreeKey, leaf_data: Option<Bytes>, proof: Proof) -> MerkleRoot {
    let (mut proof_set, mut current_hash) = match proof {
        Proof::Inclusion(in_proof) => {
            require(leaf_data.is_some(), "No leaf data");
            (in_proof.proof_set, leaf_digest(key, sha256(leaf_data.unwrap())))
        },
        Proof::Exclusion(ex_proof) => {
            require(leaf_data.is_none(), "Leaf data provided");
            let leaf_hash = match ex_proof.leaf {
                ExclusionLeaf::Leaf(data) => {
                    leaf_digest(data.leaf_key, data.leaf_value)
                }
                ExclusionLeaf::Placeholder => b256::zero(),
            };
            (ex_proof.proof_set, leaf_hash)
        },
    };

    let mut iter = 0;
    for sibling_hash in proof_set.iter() {
        let index = proof_set.len() - 1 - iter;
        current_hash = match bit_at_index(key, index) {
            false => node_digest(current_hash, sibling_hash),
            true => node_digest(sibling_hash, current_hash),
        };
        iter += 1;
    }

    current_hash
}

/// This function will take a Sparse Merkle leaf and proof and return whether the computed root matches the root given.
///
/// # Arguments
///
/// * `key`: [MerkleTreeKey] - The key or index of the leaf to verify.
/// * `leaf_data`: [Option<Bytes>] - `Some` data that makes up the leaf on the Sparse Merkle Tree, `None` if this is an exclusion proof.
/// * `proof`: [Proof] - The Sparse Merkle proof that will be used to traverse the Sparse Merkle Tree and compute a root.
/// * `root`: [b256] - The pre-computed Sparse Merkle root that will be used to verify the leaf and proof.
///
/// # Returns
///
/// * [bool] - `true` if the computed root matches the provided root, otherwise 'false'.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::{sparse::{verify_proof, MerkleTreeKey, Proof, InclusionProof}, common::{Vec<b256>, MerkleRoot}};
///
/// fn foo() {
///     let key = MerkleTreeKey::zero();
///     let leaf = b256::zero();
///     let mut proof_set = Vec<b256>::new();
///     proof_set.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
///     let proof = Proof::Inclusion(InclusionProof::new(proof_set));
///     let root: MerkleRoot = 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47;
///
///     assert(verify_proof(key, leaf, proof, root) == true);
/// }
/// ```
pub fn verify_proof(
    key: MerkleTreeKey,
    leaf_data: Option<Bytes>,
    proof: Proof,
    root: MerkleRoot,
) -> bool {
    root == process_proof(key, leaf_data, proof)
}

/// Returns the computed leaf hash of "MTH(D[n]) = SHA-256(0x00 || MTH(D[0:k]) || MTH(D[k:n]))".
///
/// # Arguments
///
/// * `key`: [b256] - The key of the leaf in the Sparse Merkle Tree.
/// * `data`: [Bytes] - The data that makes up the leaf.
///
/// # Returns
///
/// * [b256] - The computed leaf hash.
///
/// # Examples
///
/// ```sway
/// use sway_libs::merkle::sparse::leaf_digest;
/// use std::bytes::Bytes;
///
/// fn foo() {
///     let data = Bytes::new();
///     let key = b256::zero();
///     let digest = leaf_digest(key, data);
///     assert(digest == 0x54f05a87f5b881780cdc40e3fddfebf72e3ba7e5f65405ab121c7f22d9849ab4);
/// }
/// ```
pub fn leaf_digest(key: b256, leaf_hash: b256) -> b256 {
    let ptr = alloc_bytes(65);
    ptr.write_byte(LEAF);
    __addr_of(key).copy_bytes_to(ptr.add_uint_offset(1), 32);
    __addr_of(leaf_hash)
        .copy_bytes_to(ptr.add_uint_offset(33), 32);

    sha256(Bytes::from(raw_slice::from_parts::<u8>(ptr, 65)))
}

/// Computes whether a bit at an index is 0 or 1.
fn bit_at_index(key: b256, index: u64) -> bool {
    // The byte that contains the bit
    let byte_index = index / 8;
    // The bit within the containing byte
    let byte_bit_index = index % 8;
    let mask = (1 << (7 - byte_bit_index)).try_as_u8().unwrap();
    let byte = __addr_of(key).add::<u8>(byte_index).read_byte();
    byte & mask != 0u8
}
