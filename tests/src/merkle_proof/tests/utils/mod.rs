use fuel_merkle::binary::in_memory::MerkleTree;
use fuel_merkle::sparse::in_memory::MerkleTree as SparseTree;
use fuel_merkle::sparse::MerkleTreeKey as SparseTreeKey;
use fuel_merkle::sparse::proof::Proof as FuelProof;
use fuel_merkle::sparse::proof::ExclusionLeaf as FuelExclusionLeaf;
use fuel_tx::Bytes32;
use fuels::{
    prelude::{
        abigen, launch_provider_and_get_wallet, Contract, LoadConfiguration, TxPolicies,
        WalletUnlocked,
    },
    types::{Bits256, Bytes},
};
use sha2::{Digest, Sha256};

abigen!(Contract(
    name = "TestMerkleProofLib",
    abi = "src/merkle_proof/out/release/merkle_proof_test-abi.json"
));

pub const NODE: u8 = 0x01;
pub const LEAF: u8 = 0x00;

pub mod abi_calls {

    use super::*;

    pub async fn binary_leaf_digest(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        data: Bits256,
    ) -> Bits256 {
        contract
            .methods()
            .binary_leaf_digest(data)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn node_digest(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        left: Bits256,
        right: Bits256,
    ) -> Bits256 {
        contract
            .methods()
            .node_digest(left, right)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn binary_process_proof(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: u64,
        leaf: Bits256,
        num_leaves: u64,
        proof: Vec<Bits256>,
    ) -> Bits256 {
        contract
            .methods()
            .binary_process_proof(key, leaf, num_leaves, proof)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn binary_verify_proof(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: u64,
        leaf: Bits256,
        root: Bits256,
        num_leaves: u64,
        proof: Vec<Bits256>,
    ) -> bool {
        contract
            .methods()
            .binary_verify_proof(key, leaf, root, num_leaves, proof)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn sparse_root(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: Bits256,
        leaf: Option<Bytes>,
        proof: Proof,
    ) -> Bits256 {
        contract
            .methods()
            .sparse_root(key, leaf, proof)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn sparse_root_hash(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: Bits256,
        leaf: Bits256,
        proof: Proof,
    ) -> Bits256 {
        contract
            .methods()
            .sparse_root_hash(key, leaf, proof)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn sparse_verify(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: Bits256,
        leaf: Option<Bytes>,
        root: Bits256,
        proof: Proof,
    ) -> bool {
        contract
            .methods()
            .sparse_verify(key, leaf, proof, root)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn sparse_verify_hash(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: Bits256,
        leaf: Bits256,
        root: Bits256,
        proof: Proof,
    ) -> bool {
        contract
            .methods()
            .sparse_verify_hash(key, leaf, proof, root)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn sparse_leaf_digest(
        contract: &TestMerkleProofLib<WalletUnlocked>,
        key: Bits256,
        data: Bits256,
    ) -> Bits256 {
        contract
            .methods()
            .sparse_leaf_digest(key, data)
            .call()
            .await
            .unwrap()
            .value
    }
}

pub mod test_helpers {

    use super::*;

    #[derive(Clone)]
    struct Node {
        hash: Bytes32,
        left: Option<usize>,
        right: Option<usize>,
    }

    impl Node {
        pub fn new(hash: [u8; 32]) -> Self {
            Node {
                hash: hash.into(),
                left: None,
                right: None,
            }
        }

        pub fn left(mut self, node: usize) -> Self {
            self.left = Some(node);
            self
        }

        pub fn right(mut self, node: usize) -> Self {
            self.right = Some(node);
            self
        }
    }

    pub async fn build_tree(
        leaves: Vec<[u8; 1]>,
        key: u64,
    ) -> (MerkleTree, Bits256, Bits256, Vec<Bits256>) {
        let mut tree = MerkleTree::new();
        let num_leaves = leaves.len();
        let mut leaf_hash = [0u8; 32];

        for n in 0..num_leaves {
            let mut hasher = Sha256::new();
            hasher.update(&leaves[n]);
            let hash = hasher.finalize();

            if n == key as usize {
                leaf_hash = hash.into();
            }

            let _ = tree.push(&hash);
        }

        let (merkle_root, proof) = tree.prove(key).unwrap();
        let merkle_leaf = leaf_sum(&leaf_hash);

        let mut final_proof: Vec<Bits256> = Vec::new();

        for itterator in proof {
            final_proof.push(Bits256(itterator.clone()));
        }

        (
            tree,
            Bits256(merkle_root),
            Bits256(merkle_leaf),
            final_proof,
        )
    }

    pub async fn build_tree_manual(
        leaves: Vec<[u8; 1]>,
        height: usize,
        key: usize,
    ) -> (Bits256, Vec<Bits256>, Bits256) {
        let num_leaves = leaves.len();
        let mut nodes: Vec<Node> = Vec::new();
        let mut leaf_hash = [0u8; 32];
        let mut proof: Vec<Bits256> = Vec::new();

        assert!(key <= num_leaves);

        // Hash leaves and create leaf nodes
        for n in 0..num_leaves {
            let mut hasher = Sha256::new();
            hasher.update(&[LEAF]);
            hasher.update(&leaves[n]);
            let hash = hasher.finalize();

            let new_node = Node::new(hash.into());
            nodes.push(new_node);
            if n == key {
                leaf_hash = hash.into();
            }
        }

        let mut itterator = 0;
        // Build tree
        for i in 0..height {
            let current_num_leaves = itterator + 2usize.pow((height - i).try_into().unwrap());

            // Create new depth
            while itterator < current_num_leaves {
                let mut hasher = Sha256::new();
                hasher.update(&[NODE]);
                hasher.update(&nodes[itterator].hash);
                hasher.update(&nodes[itterator + 1].hash);
                let hash = hasher.finalize().into();

                let new_node = Node::new(hash).left(itterator).right(itterator + 1);
                nodes.push(new_node);
                itterator += 2;
            }
        }

        // Get proof
        let mut key = key;
        let mut index = nodes.len() - 1;
        for i in 0..height {
            let node = nodes[index].clone();

            if node.left == None && node.right == None {
                break;
            }

            let number_subtree_elements = (2usize.pow(((height - i) + 1).try_into().unwrap())) / 2;

            if key <= number_subtree_elements {
                // Go left
                index = node.left.unwrap();
                let proof_node = node.right.unwrap();
                proof.push(Bits256(*nodes[proof_node].hash));
            } else {
                // Go right
                index = node.right.unwrap();
                let proof_node = node.left.unwrap();
                proof.push(Bits256(*nodes[proof_node].hash));

                key = key - number_subtree_elements;
            }
        }

        proof.reverse();

        (
            Bits256(leaf_hash),
            proof,
            Bits256(*nodes.last().unwrap().hash),
        )
    }

    pub async fn build_sparse_tree(
        leaves: Vec<[u8; 1]>,
        key: u64,
    ) -> (SparseTree, Bits256, Bytes, SparseTreeKey) {
        let mut tree = SparseTree::new();
        let num_leaves = leaves.len();
        let mut leaf_hash = [0u8; 32];
        let mut leaf_key = SparseTreeKey::new(leaf_hash);

        for n in 0..num_leaves {
            let mut hasher = Sha256::new();
            hasher.update(&leaves[n]);
            let hash = hasher.finalize();

            if n == key as usize {
                leaf_hash = hash.into();
                leaf_key = SparseTreeKey::new(hash);
            }

            let _ = tree.update(SparseTreeKey::new(hash), &hash);
        }

        let merkle_root = tree.root();

        (
            tree,
            Bits256(merkle_root),
            Bytes(leaf_hash.into()),
            leaf_key
        )
    }

    pub async fn sparse_proof(tree: SparseTree, key: SparseTreeKey) -> FuelProof {
        tree.generate_proof(&key).unwrap()
    }

    pub async fn leaves_with_depth(depth: u32) -> Vec<[u8; 1]> {
        let num_elements_in_tree = 2_i32.pow(depth);
        let mut return_vec: Vec<[u8; 1]> = Vec::new();

        for n in 0..num_elements_in_tree {
            let n_u8: u8 = (n % i32::from(u8::MAX)).try_into().unwrap();
            return_vec.push([n_u8]);
        }

        return_vec
    }

    pub async fn merkle_proof_instance() -> TestMerkleProofLib<WalletUnlocked> {
        let wallet = launch_provider_and_get_wallet().await.unwrap();

        let contract_id = Contract::load_from(
            "./src/merkle_proof/out/release/merkle_proof_test.bin",
            LoadConfiguration::default(),
        )
        .unwrap()
        .deploy(&wallet, TxPolicies::default())
        .await
        .unwrap();

        let instance = TestMerkleProofLib::new(contract_id.clone(), wallet.clone());

        instance
    }

    pub fn leaf_sum(data: &[u8]) -> [u8; 32] {
        let mut hash = Sha256::new();

        hash.update(&[LEAF]);
        hash.update(data);

        hash.finalize().into()
    }

    pub fn sparse_leaf(key: &[u8; 32], data: &[u8]) -> [u8; 32] {
        let mut hash_1 = Sha256::new();
        hash_1.update(data);

        let hashed_data: [u8; 32] = hash_1.finalize().into();

        let mut hash_2 = Sha256::new();
        hash_2.update(&[LEAF]);
        hash_2.update(key);
        hash_2.update(hashed_data);

        hash_2.finalize().into()
    }

    pub fn fuel_to_sway_sparse_proof(fuel_proof: FuelProof) -> Proof {
        let mut proof_bits: Vec<Bits256> = Vec::new();
        for iterator in fuel_proof.proof_set().iter() {
            proof_bits.push(Bits256(iterator.clone()));
        }

        match fuel_proof {
            FuelProof::Exclusion(exlcusion_proof) => {
                Proof::Exclusion(ExclusionProof { 
                    proof_set: proof_bits, 
                    leaf: match exlcusion_proof.leaf {
                        FuelExclusionLeaf::Leaf(leaf_data) => ExclusionLeaf::Leaf(ExclusionLeafData{ leaf_key: Bits256(leaf_data.leaf_key), leaf_value: Bits256(leaf_data.leaf_value) }),
                        FuelExclusionLeaf::Placeholder => ExclusionLeaf::Placeholder,
                    },
                })
            },
            FuelProof::Inclusion(_) => {
                Proof::Inclusion(InclusionProof { proof_set: proof_bits })
            }
        }
    }
}
