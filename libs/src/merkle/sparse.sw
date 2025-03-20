library;

// TODO: Replace `Vec<b256>` with `ProofSet` when https://github.com/FuelLabs/fuels-rs/issues/1603 is resolved
use ::merkle::common::{LEAF, MerkleRoot, node_digest, ProofError};
use std::{alloc::alloc_bytes, bytes::Bytes, hash::{Hash, sha256}};

/// Error used when something goes wrong while computing or verifying Sparse Merkle Proofs.
pub enum SparseMerkleError {
    /// Error variant used when no leaf data is provided.
    NoLeafData: (),
    /// Error variant used when leaf data is provided.
    LeafData: (),
}

/// The key associated with a leaf of a Sparse Merkle Tree.
pub type MerkleTreeKey = b256;

/// An Inclusion Proof for a Sparse Merkle Tree.
pub struct InclusionProof {
    /// The underlying proof set.
    proof_set: Vec<b256>,
}

impl InclusionProof {
    /// Instantiates a new `InclusionProof` from a `ProofSet`.
    ///
    /// # Arguments
    ///
    /// * `proof_set`: [ProofSet] - A raw `ProofSet` of hashes.
    ///
    /// # Returns
    ///
    /// [InclusionProof] - A newly created `InclusionProof`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::InclusionProof;
    ///
    /// fn foo() {
    ///     let proof_set = ProofSet::new()
    ///     let new_proof = InclusionProof::new(proof_set);
    /// }
    /// ```
    pub fn new(proof_set: Vec<b256>) -> Self {
        Self { proof_set }
    }

    /// Returns the underlying `ProofSet` of the `InclusionProof`.
    ///
    /// # Returns
    ///
    /// * [ProofSet] - The underlying proof set that defines the inclusion proof.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::InclusionProof;
    ///
    /// fn foo() {
    ///     let new_proof_set = ProofSet::new()
    ///     let new_proof = InclusionProof::new(new_proof_set);
    ///     let result_proof_set = new_proof.proof_set();
    ///     assert(result_proof_set.len() == new_proof_set.len());
    /// }
    /// ```
    pub fn proof_set(self) -> Vec<b256> {
        self.proof_set.clone()
    }

    /// Verifies some data is included in a Sparse Merkle Tree against this inclusion proof.
    ///
    /// # Arguments
    ///
    /// * `root`: [MerkleRoot] - The root of the Sparse Merkle Tree.
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_data`: [Bytes] - The raw data of the leaf.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the verification is successful, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::InclusionProof;
    ///
    /// fn foo(proof: InclusionProof, root: MerkleRoot, key: MerkleTreeKey, leaf_data: Bytes) {
    ///     assert(proof.verify(root, key, leaf_data));
    /// }
    /// ```
    pub fn verify(self, root: MerkleRoot, key: MerkleTreeKey, leaf_data: Bytes) -> bool {
        let mut current_hash = leaf_digest(key, sha256(leaf_data));
        _compute_root(self.proof_set, current_hash, key) == root
    }

    /// Verifies hashed data is included in a Sparse Merkle Tree against this inclusion proof.
    ///
    /// # Arguments
    ///
    /// * `root`: [MerkleRoot] - The root of the Sparse Merkle Tree.
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_hash`: [b256] - The hashed data of the leaf.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the verification is successful, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::InclusionProof;
    ///
    /// fn foo(proof: InclusionProof, root: MerkleRoot, key: MerkleTreeKey, leaf_hash: b256) {
    ///     assert(proof.verify(root, key, leaf_data));
    /// }
    /// ```
    pub fn verify_hash(self, root: MerkleRoot, key: MerkleTreeKey, leaf_hash: b256) -> bool {
        let mut current_hash = leaf_digest(key, leaf_hash);
        _compute_root(self.proof_set, current_hash, key) == root
    }

    /// Computes the root of a Sparse Merkle Tree from the proof and data.
    ///
    /// # Arguments
    ///
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_data`: [Bytes] - The raw data of the leaf.
    ///
    /// # Returns
    ///
    /// * [MerkleRoot] - The computed merkle root.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::InclusionProof;
    ///
    /// fn foo(proof: InclusionProof, key: MerkleTreeKey, leaf_data: Bytes) {
    ///     assert(proof.root(root, key, leaf_data) != b256::zero());
    /// }
    /// ```
    pub fn root(self, key: MerkleTreeKey, leaf_data: Bytes) -> MerkleRoot {
        let mut current_hash = leaf_digest(key, sha256(leaf_data));
        _compute_root(self.proof_set, current_hash, key)
    }

    /// Computes the root of a Sparse Merkle Tree from the proof and hashed data.
    ///
    /// # Arguments
    ///
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_hash`: [b256] - The hashed data of the leaf.
    ///
    /// # Returns
    ///
    /// * [MerkleRoot] - The computed merkle root.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::InclusionProof;
    ///
    /// fn foo(proof: InclusionProof, key: MerkleTreeKey, leaf_hash: b256) {
    ///     assert(proof.root(root, key, leaf_hash) != b256::zero());
    /// }
    /// ```
    pub fn root_from_hash(self, key: MerkleTreeKey, leaf_data: b256) -> MerkleRoot {
        let mut current_hash = leaf_digest(key, leaf_data);
        _compute_root(self.proof_set, current_hash, key)
    }
}

impl PartialEq for InclusionProof {
    fn eq(self, other: Self) -> bool {
        if self.proof_set.len() != other.proof_set.len() {
            return false;
        }

        let mut iter = 0;
        while iter < self.proof_set.len() {
            if self.proof_set.get(iter).unwrap() != other.proof_set.get(iter).unwrap()
            {
                return false;
            }

            iter += 1;
        }

        true
    }
}

impl Eq for InclusionProof {}

impl Clone for InclusionProof {
    fn clone(self) -> Self {
        Self {
            proof_set: self.proof_set.clone(),
        }
    }
}

/// An Exclusion Proof Leaf data for a Sparse Merkle Tree.
pub struct ExclusionLeafData {
    /// The leaf key.
    leaf_key: MerkleTreeKey,
    /// Hash of the value of the leaf.
    leaf_value: b256,
}

impl ExclusionLeafData {
    /// Instantiates a new `ExclusionLeafData` from a `MerkleTreeKey` and `b256`.
    ///
    /// # Arguments
    ///
    /// * `leaf_key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_value`: [b256] - The hashed value of a particular leaf in the Sparse Merkle Tree.
    ///
    /// # Returns
    ///
    /// [ExclusionLeafData] - A newly created `ExclusionLeafData`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionLeafData;
    ///
    /// fn foo() {
    ///     let leaf_key = MerkleTreeKey::zero()
    ///     let leaf_value = b256::zero()
    ///     let new_leaf = ExclusionLeafData::new(leaf_key, leaf_value);
    /// }
    /// ```
    pub fn new(leaf_key: MerkleTreeKey, leaf_value: b256) -> Self {
        Self {
            leaf_key,
            leaf_value,
        }
    }

    /// Returns the underlying `MerkleTreeKey` of the exclusion leaf.
    ///
    /// # Returns
    ///
    /// * [MerkleTreeKey] - The underlying `MerkleTreeKey` for this exclusion leaf.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionLeafData;
    ///
    /// fn foo() {
    ///     let leaf_key = MerkleTreeKey::zero()
    ///     let leaf_value = b256::zero()
    ///     let new_leaf = ExclusionLeafData::new(leaf_key, leaf_value);
    ///     let result_key = new_leaf.leaf_key();
    ///     assert(result_key == leaf_key);
    /// }
    /// ```
    pub fn leaf_key(self) -> MerkleTreeKey {
        self.leaf_key
    }

    /// Returns the underlying `b256` of the exclusion leaf data.
    ///
    /// # Returns
    ///
    /// * [b256] - The underlying `b256` data for this exclusion leaf.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionLeafData;
    ///
    /// fn foo() {
    ///     let leaf_key = MerkleTreeKey::zero()
    ///     let leaf_value = b256::zero()
    ///     let new_leaf = ExclusionLeafData::new(leaf_key, leaf_value);
    ///     let result_hash = new_leaf.leaf_key();
    ///     assert(result_hash == leaf_value);
    /// }
    /// ```
    pub fn leaf_value(self) -> b256 {
        self.leaf_value
    }
}

impl PartialEq for ExclusionLeafData {
    fn eq(self, other: Self) -> bool {
        self.leaf_key == other.leaf_key && self.leaf_value == other.leaf_value
    }
}

impl Eq for ExclusionLeafData {}

/// An Exclusion Proof Leaf for a Sparse Merkle Tree.
pub enum ExclusionLeaf {
    /// Data for the exclusion proof leaf.
    Leaf: ExclusionLeafData,
    /// A placeholder for no data.
    Placeholder: (),
}

impl ExclusionLeaf {
    /// Returns whether the exclusion leaf is the `Leaf` variant.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if this is a `Leaf`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionLeaf;
    ///
    /// fn foo(exclusion_leaf: ExclusionLeaf) {
    ///     assert(exclusion_leaf.is_leaf());
    /// }
    /// ```
    pub fn is_leaf(self) -> bool {
        match self {
            ExclusionLeaf::Leaf(_) => true,
            ExclusionLeaf::Placeholder => false,
        }
    }

    /// Returns whether the exclusion leaf is the `Placeholder` variant.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if this is a `Placeholder`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionLeaf;
    ///
    /// fn foo(exclusion_leaf: ExclusionLeaf) {
    ///     assert(exclusion_leaf.is_placeholder());
    /// }
    /// ```
    pub fn is_placeholder(self) -> bool {
        match self {
            ExclusionLeaf::Leaf(_) => false,
            ExclusionLeaf::Placeholder => true,
        }
    }

    /// Returns the exclusion leaf as the `Leaf` variant.
    ///
    /// # Returns
    ///
    /// * [Option<ExclusionLeafData>] - `Some` if this is a `Leaf`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{ExclusionLeaf, ExclusionLeafData};
    ///
    /// fn foo(exclusion_leaf: ExclusionLeaf) {
    ///     let leaf = exclusion_leaf.as_leaf();
    ///     assert(leaf.leaf_value != b256::zero());
    /// }
    /// ```
    pub fn as_leaf(self) -> Option<ExclusionLeafData> {
        match self {
            ExclusionLeaf::Leaf(leaf) => Some(leaf),
            ExclusionLeaf::Placeholder => None,
        }
    }
}

impl PartialEq for ExclusionLeaf {
    fn eq(self, other: Self) -> bool {
        match (self, other) {
            (ExclusionLeaf::Leaf(leaf_data_1), ExclusionLeaf::Leaf(leaf_data_2)) => leaf_data_1 == leaf_data_2,
            (ExclusionLeaf::Placeholder, ExclusionLeaf::Placeholder) => true,
            _ => false,
        }
    }
}

impl Eq for ExclusionLeaf {}

/// An Exclusion Proof for a Sparse Merkle Tree.
pub struct ExclusionProof {
    /// The underlying proof set.
    proof_set: Vec<b256>,
    /// The leaf associated with the exclusion proof.
    leaf: ExclusionLeaf,
}

impl ExclusionProof {
    /// Instantiates a new `ExclusionProof` from a `ProofSet` and `ExclusionLeaf`.
    ///
    /// # Arguments
    ///
    /// * `proof_set`: [ProofSet] - A raw `ProofSet` of hashes.
    /// * `leaf`: [ExclusionLeaf] - The leaf associated with the exclusion proof.
    ///
    /// # Returns
    ///
    /// [ExclusionProof] - A newly created `ExclusionProof`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{ExclusionProof, ExclusionLeaf};
    ///
    /// fn foo() {
    ///     let proof_set = ProofSet::new()
    ///     let leaf = ExclusionLeaf::Placeholder;
    ///     let new_proof = ExclusionProof::new(proof_set, leaf);
    /// }
    /// ```
    pub fn new(proof_set: Vec<b256>, leaf: ExclusionLeaf) -> Self {
        Self {
            proof_set,
            leaf,
        }
    }

    /// Returns the underlying `ProofSet` of the `ExclusionProof`.
    ///
    /// # Returns
    ///
    /// * [ProofSet] - The underlying proof set that defines the exclusion proof.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{ExclusionProof, ExclusionLeaf};
    ///
    /// fn foo() {
    ///     let new_proof_set = ProofSet::new()
    ///     let leaf = ExclusionLeaf::Placeholder;
    ///     let new_proof = ExclusionProof::new(new_proof_set, leaf);
    ///     let result_proof_set = new_proof.proof_set();
    ///     assert(result_proof_set.len() == new_proof_set.len());
    /// }
    /// ```
    pub fn proof_set(self) -> Vec<b256> {
        self.proof_set.clone()
    }

    /// Returns the underlying `ExclusionLeaf` of the `ExclusionProof`.
    ///
    /// # Returns
    ///
    /// * [ExclusionLeaf] - The underlying leaf that defines the exclusion proof.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{ExclusionProof, ExclusionLeaf};
    ///
    /// fn foo() {
    ///     let new_proof_set = ProofSet::new()
    ///     let leaf = ExclusionLeaf::Placeholder;
    ///     let new_proof = ExclusionProof::new(new_proof_set, leaf);
    ///     let result_leaf = new_proof.leaf();
    ///     assert(result_leaf == leaf);
    /// }
    /// ```
    pub fn leaf(self) -> ExclusionLeaf {
        self.leaf
    }

    /// Verifies some leaf is excluded in a Sparse Merkle Tree against this exclusion proof.
    ///
    /// # Arguments
    ///
    /// * `root`: [MerkleRoot] - The root of the Sparse Merkle Tree.
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the verification is successful, otherwise false.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionProof;
    ///
    /// fn foo(proof: ExclusionProof, root: MerkleRoot, key: MerkleTreeKey) {
    ///     assert(proof.verify(root, key));
    /// }
    /// ```
    pub fn verify(self, root: MerkleRoot, key: MerkleTreeKey) -> bool {
        let mut current_hash = match self.leaf {
            ExclusionLeaf::Leaf(data) => {
                leaf_digest(data.leaf_key, data.leaf_value)
            }
            ExclusionLeaf::Placeholder => b256::zero(),
        };

        _compute_root(self.proof_set, current_hash, key) == root
    }

    /// Computes the root of a Sparse Merkle Tree from the proof and data.
    ///
    /// # Arguments
    ///
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    ///
    /// # Returns
    ///
    /// * [MerkleRoot] - The computed merkle root.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::ExclusionProof;
    ///
    /// fn foo(proof: ExclusionProof, key: MerkleTreeKey) {
    ///     assert(proof.root(root, key) != b256::zero());
    /// }
    /// ```
    pub fn root(self, key: MerkleTreeKey) -> MerkleRoot {
        let mut current_hash = match self.leaf {
            ExclusionLeaf::Leaf(data) => {
                leaf_digest(data.leaf_key, data.leaf_value)
            }
            ExclusionLeaf::Placeholder => b256::zero(),
        };

        _compute_root(self.proof_set, current_hash, key)
    }
}

impl PartialEq for ExclusionProof {
    fn eq(self, other: Self) -> bool {
        if self.proof_set.len() != other.proof_set.len()
            || self.leaf != other.leaf
        {
            return false;
        }

        let mut iter = 0;
        while iter < self.proof_set.len() {
            if self.proof_set.get(iter).unwrap() != other.proof_set.get(iter).unwrap()
            {
                return false;
            }

            iter += 1;
        }

        true
    }
}

impl Eq for ExclusionProof {}

impl Clone for ExclusionProof {
    fn clone(self) -> Self {
        Self {
            proof_set: self.proof_set.clone(),
            leaf: self.leaf,
        }
    }
}

/// A wrapper on inclusion and exclusion proofs for a Sparse Merkle Tree proof.
pub enum Proof {
    /// An inclusion proof for a Sparse Merkle Tree.
    Inclusion: InclusionProof,
    /// An exclusion proof for a Sparse Merkle Tree.
    Exclusion: ExclusionProof,
}

impl Proof {
    /// Returns the underlying `ProofSet` of the `Proof`.
    ///
    /// # Returns
    ///
    /// * [ProofSet] - The underlying proof set that defines the proof.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::Proof;
    ///
    /// fn foo() {
    ///     let new_proof_set = ProofSet::new()
    ///     let leaf = ExclusionLeaf::Placeholder;
    ///     let new_proof = Proof::Exclusion(ExclusionProof::new(new_proof_set, leaf));
    ///     let result_proof_set = new_proof.proof_set();
    ///     assert(result_proof_set.len() == new_proof_set.len());
    /// }
    /// ```
    pub fn proof_set(self) -> Vec<b256> {
        match self {
            Proof::Inclusion(proof) => proof.proof_set(),
            Proof::Exclusion(proof) => proof.proof_set(),
        }
    }

    /// Returns whether the proof is the `Inclusion` variant.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if this is a `Inclusion`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::Proof;
    ///
    /// fn foo(proof: Proof) {
    ///     assert(proof.is_inclusion());
    /// }
    /// ```
    pub fn is_inclusion(self) -> bool {
        match self {
            Proof::Inclusion(_) => true,
            Proof::Exclusion(_) => false,
        }
    }

    /// Returns whether the proof is the `Exclusion` variant.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if this is a `Exclusion`, otherwise `false`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::Proof;
    ///
    /// fn foo(proof: Proof) {
    ///     assert(proof.is_exclusion());
    /// }
    /// ```
    pub fn is_exclusion(self) -> bool {
        match self {
            Proof::Inclusion(_) => false,
            Proof::Exclusion(_) => true,
        }
    }

    /// Returns the proof as the `Inclusion` variant.
    ///
    /// # Returns
    ///
    /// * [Option<InclusionProof>] - `Some` if this is a `Inclusion`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{Proof, InclusionProof};
    ///
    /// fn foo(proof: Proof) {
    ///     let in_proof = proof.as_inclusion();
    ///     assert(in_proof.proof_set.len() != 0);
    /// }
    /// ```
    pub fn as_inclusion(self) -> Option<InclusionProof> {
        match self {
            Proof::Inclusion(proof) => Some(proof),
            Proof::Exclusion(_) => None,
        }
    }

    /// Returns the proof as the `Exclusion` variant.
    ///
    /// # Returns
    ///
    /// * [Option<ExclusionProof>] - `Some` if this is a `Exclusion`, otherwise `None`.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{Proof, v};
    ///
    /// fn foo(proof: Proof) {
    ///     let ex_proof = proof.as_exclusion();
    ///     assert(ex_proof.proof_set.len() != 0);
    /// }
    /// ```
    pub fn as_exclusion(self) -> Option<ExclusionProof> {
        match self {
            Proof::Inclusion(_) => None,
            Proof::Exclusion(proof) => Some(proof),
        }
    }

    /// Determines whether the computed root matches the root given on the proof.
    ///
    /// # Arguments
    ///
    /// * `root`: [MerkleRoot] - The pre-computed Sparse Merkle root that will be used to verify the leaf and proof.
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_data`: [Option<Bytes>] - `Some` data that makes up the leaf on the Sparse Merkle Tree, `None` if this is an exclusion proof.
    ///
    /// # Returns
    ///
    /// * [bool] - `true` if the computed root matches the provided root, otherwise 'false'.
    ///
    /// # Reverts
    ///
    /// * When `leaf_data` is `None` and this is an `Inclusion` proof.
    /// * When `leaf_data` is `Some` and this is an `Exclusion` proof.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{Proof, MerkleTreeKey, InclusionProof};
    /// use sway_libs::merkle::common::{ProofSet, MerkleRoot};
    /// use std::bytes::Bytes;
    ///
    /// fn foo() {
    ///     let key = MerkleTreeKey::zero();
    ///     let mut leaf = Bytes::new();
    ///     leaf.push(1u8);
    ///     let mut proof_set = ProofSet::new();
    ///     proof_set.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
    ///     let proof = Proof::Inclusion(InclusionProof::new(proof_set));
    ///     let root: MerkleRoot = 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47;
    ///
    ///     assert(proof.verify(root, key, Some(leaf)) == true);
    /// }
    /// ```
    pub fn verify(
        self,
        root: MerkleRoot,
        key: MerkleTreeKey,
        leaf_data: Option<Bytes>,
) -> bool {
        match self {
            Self::Inclusion(in_proof) => {
                require(leaf_data.is_some(), SparseMerkleError::NoLeafData);
                in_proof.verify(root, key, leaf_data.unwrap())
            },
            Self::Exclusion(ex_proof) => {
                require(leaf_data.is_none(), SparseMerkleError::LeafData);
                ex_proof.verify(root, key)
            },
        }
    }

    /// Computes the root of a Sparse Merkle Tree from the proof.
    ///
    /// # Arguments
    ///
    /// * `key`: [MerkleTreeKey] - The key associated with the particular leaf in the Sparse Merkle Tree.
    /// * `leaf_data`: [Option<Bytes>] - `Some` data that makes up the leaf on the Sparse Merkle Tree, `None` if this is an exclusion proof.
    ///
    /// # Returns
    ///
    /// * [MerkleRoot] - The computed merkle root.
    ///
    /// # Reverts
    ///
    /// * When `leaf_data` is `None` and this is an `Inclusion` proof.
    /// * When `leaf_data` is `Some` and this is an `Exclusion` proof.
    ///
    /// # Examples
    ///
    /// ```sway
    /// use sway_libs::merkle::sparse::{Proof, MerkleTreeKey, InclusionProof};
    /// use sway_libs::merkle::common::{ProofSet, MerkleRoot};
    ///
    /// fn foo() {
    ///     let key = MerkleTreeKey::zero();
    ///     let mut leaf = Bytes::new();
    ///     leaf.push(1u8);
    ///     let mut proof_set = ProofSet::new();
    ///     proof_set.push(0xb51fc5c7f5b6393a5b13bb6068de2247ac09df1d3b1bec17627502cb1d1a6ac6);
    ///     let proof = Proof::Inclusion(InclusionProof::new(proof_set));
    ///
    ///     let root: MerkleRoot = proof.root(key, Some(leaf));
    ///     assert(root == 0xed84ee783dcb8999206160218e4fe8a1dc5ccb056e3b98f0a6fa633ca5896a47);
    /// }
    /// ```
    pub fn root(self, key: MerkleTreeKey, leaf_data: Option<Bytes>) -> MerkleRoot {
        match self {
            Self::Inclusion(in_proof) => {
                require(leaf_data.is_some(), SparseMerkleError::NoLeafData);
                in_proof.root(key, leaf_data.unwrap())
            },
            Self::Exclusion(ex_proof) => {
                require(leaf_data.is_none(), SparseMerkleError::LeafData);
                ex_proof.root(key)
            },
        }
    }
}

impl PartialEq for Proof {
    fn eq(self, other: Self) -> bool {
        match (self, other) {
            (Proof::Inclusion(in_proof_1), Proof::Inclusion(in_proof_2)) => in_proof_1 == in_proof_2,
            (Proof::Exclusion(ex_proof_1), Proof::Exclusion(ex_proof_2)) => ex_proof_1 == ex_proof_2,
            _ => false,
        }
    }
}

impl Eq for Proof {}

/// Returns the computed leaf hash of "MTH(D[n]) = SHA-256(0x00 || MTH(D[0:k]) || MTH(D[k:n]))".
///
/// # Arguments
///
/// * `key`: [b256] - The key of the leaf in the Sparse Merkle Tree.
/// * `leaf_hash`: [b256] - The sha256 hash that makes up the leaf.
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
///     let data = b256::new();
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

// Computes whether a bit at an index is 0 or 1.
fn bit_at_index(key: b256, index: u64) -> bool {
    // The byte that contains the bit
    let byte_index = index / 8;
    // The bit within the containing byte
    let byte_bit_index = index % 8;
    let mask = (1 << (7 - byte_bit_index)).try_as_u8().unwrap();
    let byte = __addr_of(key).add::<u8>(byte_index).read_byte();
    byte & mask != 0u8
}

// Computes the root of a sparse merkle tree given a proof set, leaf, and key.
fn _compute_root(proof_set: Vec<b256>, leaf_hash: b256, key: MerkleTreeKey) -> b256 {
    let mut current_hash = leaf_hash;
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
