use fuel_merkle::{
    binary::in_memory::MerkleTree,
    common::{empty_sum_sha256, Bytes32, LEAF},
};
use fuels::prelude::*;
use sha2::{Digest, Sha256};

abigen!(
    TestMerkleProofLib,
    "test_projects/merkle_proof/out/debug/merkle_proof-abi.json"
);

pub mod abi_calls {

    use super::*;

    pub async fn leaf_digest(contract: &TestMerkleProofLib, data: Bits256) -> Bits256 {
        contract
            .methods()
            .leaf_digest(data)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn node_digest(
        contract: &TestMerkleProofLib,
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

    pub async fn process_proof(
        contract: &TestMerkleProofLib,
        key: u64,
        leaf: Bits256,
        num_leaves: u64,
        proof: Vec<Bits256>,
    ) -> Bits256 {
        contract
            .methods()
            .process_proof(key, leaf, num_leaves, proof)
            .call()
            .await
            .unwrap()
            .value
    }

    pub async fn verify_proof(
        contract: &TestMerkleProofLib,
        key: u64,
        leaf: Bits256,
        root: Bits256,
        num_leaves: u64,
        proof: Vec<Bits256>,
    ) -> bool {
        contract
            .methods()
            .verify_proof(key, root, leaf, num_leaves, proof)
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
        pub fn new(hash: Bytes32) -> Self {
            Node {
                hash,
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
        leaves: Vec<&[u8]>,
        key: u64,
    ) -> (MerkleTree, Bits256, Bits256, Vec<Bits256>) {
        let mut tree = MerkleTree::new();

        for datum in leaves.iter() {
            let _ = tree.push(datum);
        }

        let merkle_root = tree.root();
        let mut proof = tree.prove(key).unwrap();
        let merkle_leaf = proof.1[0];
        proof.1.remove(0);

        let mut final_proof: Vec<Bits256> = Vec::new();

        for itterator in proof.1 {
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
        let mut leaf_hash: Bytes32 = *empty_sum_sha256();
        let mut proof: Vec<Bits256> = Vec::new();

        assert!(key <= num_leaves);

        // Hash leaves and create leaf nodes
        for n in 0..num_leaves {
            let mut hasher = Sha256::new();
            hasher.update(&[LEAF]);
            hasher.update(&leaves[n]);
            let hash: Bytes32 = hasher.finalize().try_into().unwrap();

            let new_node = Node::new(hash);
            nodes.push(new_node);
            if n == key {
                leaf_hash = hash.clone();
            }
        }

        let node_u64: u64 = 1;
        let mut itterator = 0;
        // Build tree
        for i in 0..height {
            let current_num_leaves = itterator + 2usize.pow((height - i).try_into().unwrap());

            // Create new depth
            while itterator < current_num_leaves {
                let mut hasher = Sha256::new();
                hasher.update(node_u64.to_be_bytes());
                hasher.update(&nodes[itterator].hash);
                hasher.update(&nodes[itterator + 1].hash);
                let hash: Bytes32 = hasher.finalize().try_into().unwrap();

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
                proof.push(Bits256(nodes[proof_node].hash));
            } else {
                // Go right
                index = node.right.unwrap();
                let proof_node = node.left.unwrap();
                proof.push(Bits256(nodes[proof_node].hash));

                key = key - number_subtree_elements;
            }
        }

        proof.reverse();

        (
            Bits256(leaf_hash),
            proof,
            Bits256(nodes.last().unwrap().hash),
        )
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

    pub async fn merkle_proof_instance() -> TestMerkleProofLib {
        let wallet = launch_provider_and_get_wallet().await;

        let contract_id = Contract::deploy(
            "./test_projects/merkle_proof/out/debug/merkle_proof.bin",
            &wallet,
            TxParameters::default(),
            StorageConfiguration::default(),
        )
        .await
        .unwrap();

        let instance = TestMerkleProofLib::new(contract_id.clone(), wallet.clone());

        instance
    }
}
