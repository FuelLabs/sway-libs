contract;

use sway_libs::merkle::common::node_digest;
use sway_libs::merkle::sparse::{
    ExclusionLeaf,
    ExclusionLeafData,
    ExclusionProof,
    InclusionProof,
    Proof,
};
use std::bytes::Bytes;

abi MerkleProofTest {
    fn binary_leaf_digest(data: b256) -> b256;
    fn node_digest(left: b256, right: b256) -> b256;
    fn binary_process_proof(
        key: u64,
        merkle_leaf: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> b256;
    fn binary_verify_proof(
        key: u64,
        merkle_leaf: b256,
        merkle_root: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> bool;
    fn sparse_root(key: b256, merkle_leaf: Option<Bytes>, proof: Proof) -> b256;
    fn sparse_root_hash(key: b256, merkle_leaf: b256, proof: Proof) -> b256;
    fn sparse_verify(
        key: b256,
        merkle_leaf: Option<Bytes>,
        proof: Proof,
        merkle_root: b256,
    ) -> bool;
    fn sparse_verify_hash(
        key: b256,
        merkle_leaf: b256,
        proof: Proof,
        merkle_root: b256,
    ) -> bool;
    fn sparse_leaf_digest(key: b256, data: b256) -> b256;
}

impl MerkleProofTest for Contract {
    fn binary_leaf_digest(data: b256) -> b256 {
        sway_libs::merkle::binary::leaf_digest(data)
    }

    fn node_digest(left: b256, right: b256) -> b256 {
        node_digest(left, right)
    }

    fn binary_process_proof(
        key: u64,
        merkle_leaf: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> b256 {
        sway_libs::merkle::binary::process_proof(key, merkle_leaf, num_leaves, proof)
    }

    fn binary_verify_proof(
        key: u64,
        merkle_leaf: b256,
        merkle_root: b256,
        num_leaves: u64,
        proof: Vec<b256>,
    ) -> bool {
        sway_libs::merkle::binary::verify_proof(key, merkle_leaf, merkle_root, num_leaves, proof)
    }

    fn sparse_leaf_digest(key: b256, data: b256) -> b256 {
        sway_libs::merkle::sparse::leaf_digest(key, data)
    }

    fn sparse_root(key: b256, merkle_leaf: Option<Bytes>, proof: Proof) -> b256 {
        proof.root(key, merkle_leaf)
    }

    fn sparse_root_hash(key: b256, merkle_leaf: b256, proof: Proof) -> b256 {
        proof.as_inclusion().unwrap().root_from_hash(key, merkle_leaf)
    }

    fn sparse_verify(
        key: b256,
        merkle_leaf: Option<Bytes>,
        proof: Proof,
        merkle_root: b256,
    ) -> bool {
        proof.verify(merkle_root, key, merkle_leaf)
    }

    fn sparse_verify_hash(
        key: b256,
        merkle_leaf: b256,
        proof: Proof,
        merkle_root: b256,
    ) -> bool {
        proof.as_inclusion().unwrap().verify_hash(merkle_root, key, merkle_leaf)
    }
}

#[test]
fn inclusion_proof_new() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    let in_proof_1 = InclusionProof::new(proof_set_1);
    assert(in_proof_1.proof_set().len() == proof_set_1.len());
    assert(in_proof_1.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let mut proof_set_2: Vec<b256> = Vec::new();
    let in_proof_2 = InclusionProof::new(proof_set_2);
    assert(in_proof_2.proof_set().len() == proof_set_2.len());
    assert(in_proof_2.proof_set().get(0).is_none());

    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    let in_proof_3 = InclusionProof::new(proof_set_3);
    assert(in_proof_3.proof_set().len() == proof_set_3.len());
    assert(in_proof_3.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(in_proof_3.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(in_proof_3.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(in_proof_3.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(in_proof_3.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(in_proof_3.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_4.push(b256::max());
    let in_proof_4 = InclusionProof::new(proof_set_4);
    assert(in_proof_4.proof_set().len() == proof_set_4.len());
    assert(in_proof_4.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());
}

#[test]
fn inclusion_proof_proof_set() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    let in_proof_1 = InclusionProof::new(proof_set_1);
    assert(in_proof_1.proof_set().ptr() != proof_set_1.ptr());
    assert(in_proof_1.proof_set().len() == proof_set_1.len());
    assert(in_proof_1.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let mut proof_set_2: Vec<b256> = Vec::new();
    proof_set_2.push(b256::max());
    let in_proof_2 = InclusionProof::new(proof_set_2);
    assert(in_proof_2.proof_set().ptr() != proof_set_2.ptr());
    assert(in_proof_2.proof_set().len() == proof_set_2.len());
    assert(in_proof_2.proof_set().get(0).unwrap() == proof_set_2.get(0).unwrap());

    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    let in_proof_3 = InclusionProof::new(proof_set_3);
    assert(in_proof_3.proof_set().ptr() != proof_set_3.ptr());
    assert(in_proof_3.proof_set().len() == proof_set_3.len());
    assert(in_proof_3.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(in_proof_3.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(in_proof_3.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(in_proof_3.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(in_proof_3.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(in_proof_3.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());
}

#[test]
fn inclusion_proof_eq() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_2.push(b256::max());
    proof_set_3.push(b256::max());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());

    let in_proof_1 = InclusionProof::new(proof_set_1);
    let in_proof_2 = InclusionProof::new(proof_set_1);
    let in_proof_3 = InclusionProof::new(proof_set_2);
    let in_proof_4 = InclusionProof::new(proof_set_2);
    let in_proof_5 = InclusionProof::new(proof_set_3);
    let in_proof_6 = InclusionProof::new(proof_set_3);

    assert(in_proof_1 == in_proof_1);
    assert(in_proof_1 == in_proof_2);
    assert(in_proof_3 == in_proof_4);
    assert(in_proof_5 == in_proof_6);

    assert(in_proof_1 != in_proof_3);
    assert(in_proof_1 != in_proof_5);

    assert(in_proof_3 != in_proof_5);
}

#[test]
fn inclusion_proof_clone() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_2.push(b256::max());
    proof_set_3.push(b256::max());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());

    let in_proof_1 = InclusionProof::new(proof_set_1);
    let in_proof_2 = InclusionProof::new(proof_set_2);
    let in_proof_3 = InclusionProof::new(proof_set_3);

    let cloned_proof_1 = in_proof_1.clone();
    assert(cloned_proof_1 == in_proof_1);

    let cloned_proof_2 = in_proof_2.clone();
    assert(cloned_proof_2 == in_proof_2);

    let cloned_proof_3 = in_proof_3.clone();
    assert(cloned_proof_3 == in_proof_3);
}

#[test]
fn exclusion_leaf_data_new() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_1 = ExclusionLeafData::new(hash_1, hash_1);
    assert(leaf_1.leaf_key() == hash_1);
    assert(leaf_1.leaf_value() == hash_1);

    let leaf_2 = ExclusionLeafData::new(hash_1, hash_2);
    assert(leaf_2.leaf_key() == hash_1);
    assert(leaf_2.leaf_value() == hash_2);

    let leaf_3 = ExclusionLeafData::new(hash_2, hash_2);
    assert(leaf_3.leaf_key() == hash_2);
    assert(leaf_3.leaf_value() == hash_2);

    let leaf_4 = ExclusionLeafData::new(hash_2, hash_1);
    assert(leaf_4.leaf_key() == hash_2);
    assert(leaf_4.leaf_value() == hash_1);

    let leaf_5 = ExclusionLeafData::new(hash_3, hash_1);
    assert(leaf_5.leaf_key() == hash_3);
    assert(leaf_5.leaf_value() == hash_1);

    let leaf_6 = ExclusionLeafData::new(hash_3, hash_3);
    assert(leaf_6.leaf_key() == hash_3);
    assert(leaf_6.leaf_value() == hash_3);
}

#[test]
fn exclusion_leaf_data_leaf_key() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_1 = ExclusionLeafData::new(hash_1, hash_1);
    assert(leaf_1.leaf_key() == hash_1);

    let leaf_2 = ExclusionLeafData::new(hash_2, hash_1);
    assert(leaf_2.leaf_key() == hash_2);

    let leaf_3 = ExclusionLeafData::new(hash_3, hash_1);
    assert(leaf_3.leaf_key() == hash_3);
}

#[test]
fn exclusion_leaf_data_leaf_value() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_1 = ExclusionLeafData::new(hash_1, hash_1);
    assert(leaf_1.leaf_value() == hash_1);

    let leaf_2 = ExclusionLeafData::new(hash_1, hash_2);
    assert(leaf_2.leaf_value() == hash_2);

    let leaf_3 = ExclusionLeafData::new(hash_2, hash_3);
    assert(leaf_3.leaf_value() == hash_3);
}

#[test]
fn exclusion_leaf_data_eq() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_2 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_3 = ExclusionLeafData::new(hash_3, hash_1);
    let leaf_4 = ExclusionLeafData::new(hash_3, hash_1);
    let leaf_5 = ExclusionLeafData::new(hash_2, hash_3);
    let leaf_6 = ExclusionLeafData::new(hash_2, hash_3);

    assert(leaf_1 == leaf_2);
    assert(leaf_3 == leaf_4);
    assert(leaf_5 == leaf_6);

    assert(leaf_1 != leaf_3);
    assert(leaf_1 != leaf_5);

    assert(leaf_3 != leaf_5);
}

#[test]
fn exclusion_leaf_is_leaf() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_3);
    let leaf_data_3 = ExclusionLeafData::new(hash_3, hash_3);

    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Leaf(leaf_data_3);
    let leaf_4 = ExclusionLeaf::Placeholder;

    assert(leaf_1.is_leaf());
    assert(leaf_2.is_leaf());
    assert(leaf_3.is_leaf());
    assert(!leaf_4.is_leaf());
}

#[test]
fn exclusion_leaf_is_placeholder() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_3);
    let leaf_data_3 = ExclusionLeafData::new(hash_3, hash_3);

    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Leaf(leaf_data_3);
    let leaf_4 = ExclusionLeaf::Placeholder;

    assert(!leaf_1.is_placeholder());
    assert(!leaf_2.is_placeholder());
    assert(!leaf_3.is_placeholder());
    assert(leaf_4.is_placeholder());
}

#[test]
fn exclusion_leaf_as_leaf() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_3);
    let leaf_data_3 = ExclusionLeafData::new(hash_3, hash_3);

    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Leaf(leaf_data_3);
    let leaf_4 = ExclusionLeaf::Placeholder;

    assert(leaf_1.as_leaf().unwrap() == leaf_data_1);
    assert(leaf_2.as_leaf().unwrap() == leaf_data_2);
    assert(leaf_3.as_leaf().unwrap() == leaf_data_3);
    assert(leaf_4.as_leaf().is_none());
}

#[test]
fn exclusion_leaf_eq() {
    let hash_1 = b256::zero();
    let hash_2 = b256::max();
    let hash_3 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_3);
    let leaf_data_3 = ExclusionLeafData::new(hash_3, hash_3);

    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_3 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_4 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_5 = ExclusionLeaf::Leaf(leaf_data_3);
    let leaf_6 = ExclusionLeaf::Leaf(leaf_data_3);
    let leaf_7 = ExclusionLeaf::Placeholder;
    let leaf_8 = ExclusionLeaf::Placeholder;

    assert(leaf_1 == leaf_1);
    assert(leaf_1 == leaf_2);
    assert(leaf_3 == leaf_4);
    assert(leaf_5 == leaf_6);
    assert(leaf_7 == leaf_8);

    assert(leaf_1 != leaf_3);
    assert(leaf_1 != leaf_5);
    assert(leaf_1 != leaf_7);

    assert(leaf_3 != leaf_5);
    assert(leaf_3 != leaf_7);

    assert(leaf_5 != leaf_7);
}

#[test]
fn exclusion_proof_new() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let ex_proof_1 = ExclusionProof::new(proof_set_1, leaf_1);
    assert(ex_proof_1.proof_set().len() == proof_set_1.len());
    assert(ex_proof_1.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());
    assert(ex_proof_1.leaf() == leaf_1);

    let ex_proof_2 = ExclusionProof::new(proof_set_2, leaf_1);
    assert(ex_proof_2.proof_set().len() == proof_set_2.len());
    assert(ex_proof_2.proof_set().get(0).is_none());
    assert(ex_proof_2.leaf() == leaf_1);

    let ex_proof_3 = ExclusionProof::new(proof_set_3, leaf_1);
    assert(ex_proof_3.proof_set().len() == proof_set_3.len());
    assert(ex_proof_3.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_3.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_3.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_3.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_3.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_3.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());
    assert(ex_proof_3.leaf() == leaf_1);

    let ex_proof_4 = ExclusionProof::new(proof_set_4, leaf_1);
    assert(ex_proof_4.proof_set().len() == proof_set_4.len());
    assert(ex_proof_4.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());
    assert(ex_proof_4.leaf() == leaf_1);

    let ex_proof_5 = ExclusionProof::new(proof_set_1, leaf_2);
    assert(ex_proof_5.proof_set().len() == proof_set_1.len());
    assert(ex_proof_5.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());
    assert(ex_proof_5.leaf() == leaf_2);

    let ex_proof_6 = ExclusionProof::new(proof_set_2, leaf_2);
    assert(ex_proof_6.proof_set().len() == proof_set_2.len());
    assert(ex_proof_6.proof_set().get(0).is_none());
    assert(ex_proof_6.leaf() == leaf_2);

    let ex_proof_7 = ExclusionProof::new(proof_set_3, leaf_2);
    assert(ex_proof_7.proof_set().len() == proof_set_3.len());
    assert(ex_proof_7.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_7.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_7.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_7.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_7.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_7.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());
    assert(ex_proof_7.leaf() == leaf_2);

    let ex_proof_8 = ExclusionProof::new(proof_set_4, leaf_2);
    assert(ex_proof_8.proof_set().len() == proof_set_4.len());
    assert(ex_proof_8.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());
    assert(ex_proof_8.leaf() == leaf_2);

    let ex_proof_9 = ExclusionProof::new(proof_set_1, leaf_3);
    assert(ex_proof_9.proof_set().len() == proof_set_1.len());
    assert(ex_proof_9.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());
    assert(ex_proof_9.leaf() == leaf_3);

    let ex_proof_10 = ExclusionProof::new(proof_set_2, leaf_3);
    assert(ex_proof_10.proof_set().len() == proof_set_2.len());
    assert(ex_proof_10.proof_set().get(0).is_none());
    assert(ex_proof_10.leaf() == leaf_3);

    let ex_proof_11 = ExclusionProof::new(proof_set_3, leaf_3);
    assert(ex_proof_11.proof_set().len() == proof_set_3.len());
    assert(ex_proof_11.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_11.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_11.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_11.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_11.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_11.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());
    assert(ex_proof_11.leaf() == leaf_3);

    let ex_proof_12 = ExclusionProof::new(proof_set_4, leaf_3);
    assert(ex_proof_12.proof_set().len() == proof_set_4.len());
    assert(ex_proof_12.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());
    assert(ex_proof_12.leaf() == leaf_3);
}

#[test]
fn exclusion_proof_proof_set() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let ex_proof_1 = ExclusionProof::new(proof_set_1, leaf_1);
    assert(ex_proof_1.proof_set().ptr() != proof_set_1.ptr());
    assert(ex_proof_1.proof_set().len() == proof_set_1.len());
    assert(ex_proof_1.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let ex_proof_2 = ExclusionProof::new(proof_set_2, leaf_1);
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(ex_proof_2.proof_set().ptr() != proof_set_2.ptr());
    assert(ex_proof_2.proof_set().len() == proof_set_2.len());
    assert(ex_proof_2.proof_set().get(0).is_none());

    let ex_proof_3 = ExclusionProof::new(proof_set_3, leaf_1);
    assert(ex_proof_3.proof_set().ptr() != proof_set_3.ptr());
    assert(ex_proof_3.proof_set().len() == proof_set_3.len());
    assert(ex_proof_3.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_3.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_3.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_3.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_3.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_3.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_4 = ExclusionProof::new(proof_set_4, leaf_1);
    assert(ex_proof_4.proof_set().ptr() != proof_set_4.ptr());
    assert(ex_proof_4.proof_set().len() == proof_set_4.len());
    assert(ex_proof_4.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());

    let ex_proof_5 = ExclusionProof::new(proof_set_1, leaf_2);
    assert(ex_proof_5.proof_set().ptr() != proof_set_1.ptr());
    assert(ex_proof_5.proof_set().len() == proof_set_1.len());
    assert(ex_proof_5.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let ex_proof_6 = ExclusionProof::new(proof_set_2, leaf_2);
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(ex_proof_6.proof_set().ptr() != proof_set_2.ptr());
    assert(ex_proof_6.proof_set().len() == proof_set_2.len());
    assert(ex_proof_6.proof_set().get(0).is_none());

    let ex_proof_7 = ExclusionProof::new(proof_set_3, leaf_2);
    assert(ex_proof_7.proof_set().ptr() != proof_set_3.ptr());
    assert(ex_proof_7.proof_set().len() == proof_set_3.len());
    assert(ex_proof_7.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_7.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_7.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_7.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_7.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_7.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_8 = ExclusionProof::new(proof_set_4, leaf_1);
    assert(ex_proof_8.proof_set().ptr() != proof_set_4.ptr());
    assert(ex_proof_8.proof_set().len() == proof_set_4.len());
    assert(ex_proof_8.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());

    let ex_proof_9 = ExclusionProof::new(proof_set_1, leaf_3);
    assert(ex_proof_9.proof_set().ptr() != proof_set_1.ptr());
    assert(ex_proof_9.proof_set().len() == proof_set_1.len());
    assert(ex_proof_9.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let ex_proof_10 = ExclusionProof::new(proof_set_2, leaf_3);
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(ex_proof_10.proof_set().ptr() != proof_set_2.ptr());
    assert(ex_proof_10.proof_set().len() == proof_set_2.len());
    assert(ex_proof_10.proof_set().get(0).is_none());

    let ex_proof_11 = ExclusionProof::new(proof_set_3, leaf_3);
    assert(ex_proof_11.proof_set().ptr() != proof_set_3.ptr());
    assert(ex_proof_11.proof_set().len() == proof_set_3.len());
    assert(ex_proof_11.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_11.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_11.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_11.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_11.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_11.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_12 = ExclusionProof::new(proof_set_4, leaf_3);
    assert(ex_proof_12.proof_set().ptr() != proof_set_4.ptr());
    assert(ex_proof_12.proof_set().len() == proof_set_4.len());
    assert(ex_proof_12.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());
}

#[test]
fn exclusion_proof_leaf() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let ex_proof_1 = ExclusionProof::new(proof_set_1, leaf_1);
    assert(ex_proof_1.leaf() == leaf_1);

    let ex_proof_2 = ExclusionProof::new(proof_set_2, leaf_1);
    assert(ex_proof_2.leaf() == leaf_1);

    let ex_proof_3 = ExclusionProof::new(proof_set_3, leaf_1);
    assert(ex_proof_3.leaf() == leaf_1);

    let ex_proof_4 = ExclusionProof::new(proof_set_4, leaf_1);
    assert(ex_proof_4.leaf() == leaf_1);

    let ex_proof_5 = ExclusionProof::new(proof_set_1, leaf_2);
    assert(ex_proof_5.leaf() == leaf_2);

    let ex_proof_6 = ExclusionProof::new(proof_set_2, leaf_2);
    assert(ex_proof_6.leaf() == leaf_2);

    let ex_proof_7 = ExclusionProof::new(proof_set_3, leaf_2);
    assert(ex_proof_7.leaf() == leaf_2);

    let ex_proof_8 = ExclusionProof::new(proof_set_4, leaf_2);
    assert(ex_proof_8.leaf() == leaf_2);

    let ex_proof_9 = ExclusionProof::new(proof_set_1, leaf_3);
    assert(ex_proof_9.leaf() == leaf_3);

    let ex_proof_10 = ExclusionProof::new(proof_set_2, leaf_3);
    assert(ex_proof_10.leaf() == leaf_3);

    let ex_proof_11 = ExclusionProof::new(proof_set_3, leaf_3);
    assert(ex_proof_11.leaf() == leaf_3);

    let ex_proof_12 = ExclusionProof::new(proof_set_4, leaf_3);
    assert(ex_proof_12.leaf() == leaf_3);
}

#[test]
fn exclusion_proof_eq() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::max());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let ex_proof_1 = ExclusionProof::new(proof_set_1, leaf_1);
    let ex_proof_2 = ExclusionProof::new(proof_set_1, leaf_1);
    let ex_proof_3 = ExclusionProof::new(proof_set_1, leaf_2);
    let ex_proof_4 = ExclusionProof::new(proof_set_1, leaf_2);
    let ex_proof_5 = ExclusionProof::new(proof_set_2, leaf_1);
    let ex_proof_6 = ExclusionProof::new(proof_set_2, leaf_1);
    let ex_proof_7 = ExclusionProof::new(proof_set_2, leaf_2);
    let ex_proof_8 = ExclusionProof::new(proof_set_2, leaf_2);
    let ex_proof_9 = ExclusionProof::new(proof_set_3, leaf_1);
    let ex_proof_10 = ExclusionProof::new(proof_set_3, leaf_1);
    let ex_proof_11 = ExclusionProof::new(proof_set_3, leaf_2);
    let ex_proof_12 = ExclusionProof::new(proof_set_3, leaf_2);

    assert(ex_proof_1 == ex_proof_1);
    assert(ex_proof_1 == ex_proof_2);
    assert(ex_proof_3 == ex_proof_4);
    assert(ex_proof_5 == ex_proof_6);
    assert(ex_proof_7 == ex_proof_8);
    assert(ex_proof_9 == ex_proof_10);
    assert(ex_proof_11 == ex_proof_12);

    assert(ex_proof_1 != ex_proof_3);
    assert(ex_proof_1 != ex_proof_5);
    assert(ex_proof_1 != ex_proof_7);
    assert(ex_proof_1 != ex_proof_9);
    assert(ex_proof_1 != ex_proof_11);

    assert(ex_proof_3 != ex_proof_5);
    assert(ex_proof_3 != ex_proof_7);
    assert(ex_proof_3 != ex_proof_9);
    assert(ex_proof_3 != ex_proof_11);

    assert(ex_proof_5 != ex_proof_7);
    assert(ex_proof_5 != ex_proof_9);
    assert(ex_proof_5 != ex_proof_11);

    assert(ex_proof_7 != ex_proof_9);
    assert(ex_proof_7 != ex_proof_11);

    assert(ex_proof_9 != ex_proof_11);
}

#[test]
fn exclusion_proof_clone() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_2.push(b256::max());
    proof_set_3.push(b256::max());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let ex_proof_1 = ExclusionProof::new(proof_set_1, leaf_1);
    let ex_proof_2 = ExclusionProof::new(proof_set_1, leaf_2);
    let ex_proof_3 = ExclusionProof::new(proof_set_1, leaf_3);
    let ex_proof_4 = ExclusionProof::new(proof_set_2, leaf_1);
    let ex_proof_5 = ExclusionProof::new(proof_set_2, leaf_2);
    let ex_proof_6 = ExclusionProof::new(proof_set_2, leaf_3);
    let ex_proof_7 = ExclusionProof::new(proof_set_3, leaf_1);
    let ex_proof_8 = ExclusionProof::new(proof_set_3, leaf_2);
    let ex_proof_9 = ExclusionProof::new(proof_set_3, leaf_3);

    let cloned_proof_1 = ex_proof_1.clone();
    assert(cloned_proof_1 == ex_proof_1);

    let cloned_proof_2 = ex_proof_2.clone();
    assert(cloned_proof_2 == ex_proof_2);

    let cloned_proof_3 = ex_proof_3.clone();
    assert(cloned_proof_3 == ex_proof_3);

    let cloned_proof_4 = ex_proof_4.clone();
    assert(cloned_proof_4 == ex_proof_4);

    let cloned_proof_5 = ex_proof_5.clone();
    assert(cloned_proof_5 == ex_proof_5);

    let cloned_proof_6 = ex_proof_6.clone();
    assert(cloned_proof_6 == ex_proof_6);

    let cloned_proof_7 = ex_proof_7.clone();
    assert(cloned_proof_7 == ex_proof_7);

    let cloned_proof_8 = ex_proof_8.clone();
    assert(cloned_proof_8 == ex_proof_8);

    let cloned_proof_9 = ex_proof_9.clone();
    assert(cloned_proof_9 == ex_proof_9);
}

#[test]
fn proof_proof_set() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let in_proof_1 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    assert(in_proof_1.proof_set().ptr() != proof_set_1.ptr());
    assert(in_proof_1.proof_set().len() == proof_set_1.len());
    assert(in_proof_1.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let in_proof_2 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(in_proof_2.proof_set().ptr() != proof_set_2.ptr());
    assert(in_proof_2.proof_set().len() == proof_set_2.len());
    assert(in_proof_2.proof_set().get(0).is_none());

    let in_proof_3 = Proof::Inclusion(InclusionProof::new(proof_set_3));
    assert(in_proof_3.proof_set().ptr() != proof_set_3.ptr());
    assert(in_proof_3.proof_set().len() == proof_set_3.len());
    assert(in_proof_3.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(in_proof_3.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(in_proof_3.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(in_proof_3.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(in_proof_3.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(in_proof_3.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_1 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    assert(ex_proof_1.proof_set().ptr() != proof_set_1.ptr());
    assert(ex_proof_1.proof_set().len() == proof_set_1.len());
    assert(ex_proof_1.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let ex_proof_2 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(ex_proof_2.proof_set().ptr() != proof_set_2.ptr());
    assert(ex_proof_2.proof_set().len() == proof_set_2.len());
    assert(ex_proof_2.proof_set().get(0).is_none());

    let ex_proof_3 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    assert(ex_proof_3.proof_set().ptr() != proof_set_3.ptr());
    assert(ex_proof_3.proof_set().len() == proof_set_3.len());
    assert(ex_proof_3.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_3.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_3.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_3.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_3.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_3.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_4 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_4.proof_set().ptr() != proof_set_4.ptr());
    assert(ex_proof_4.proof_set().len() == proof_set_4.len());
    assert(ex_proof_4.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());

    let ex_proof_5 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    assert(ex_proof_5.proof_set().ptr() != proof_set_1.ptr());
    assert(ex_proof_5.proof_set().len() == proof_set_1.len());
    assert(ex_proof_5.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let ex_proof_6 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(ex_proof_6.proof_set().ptr() != proof_set_2.ptr());
    assert(ex_proof_6.proof_set().len() == proof_set_2.len());
    assert(ex_proof_6.proof_set().get(0).is_none());

    let ex_proof_7 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));
    assert(ex_proof_7.proof_set().ptr() != proof_set_3.ptr());
    assert(ex_proof_7.proof_set().len() == proof_set_3.len());
    assert(ex_proof_7.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_7.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_7.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_7.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_7.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_7.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_8 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_8.proof_set().ptr() != proof_set_4.ptr());
    assert(ex_proof_8.proof_set().len() == proof_set_4.len());
    assert(ex_proof_8.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());

    let ex_proof_9 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_3));
    assert(ex_proof_9.proof_set().ptr() != proof_set_1.ptr());
    assert(ex_proof_9.proof_set().len() == proof_set_1.len());
    assert(ex_proof_9.proof_set().get(0).unwrap() == proof_set_1.get(0).unwrap());

    let ex_proof_10 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_3));
    // TODO: Uncomment when https://github.com/FuelLabs/sway/issues/6956 is resolved
    // assert(ex_proof_10.proof_set().ptr() != proof_set_2.ptr());
    assert(ex_proof_10.proof_set().len() == proof_set_2.len());
    assert(ex_proof_10.proof_set().get(0).is_none());

    let ex_proof_11 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_3));
    assert(ex_proof_11.proof_set().ptr() != proof_set_3.ptr());
    assert(ex_proof_11.proof_set().len() == proof_set_3.len());
    assert(ex_proof_11.proof_set().get(0).unwrap() == proof_set_3.get(0).unwrap());
    assert(ex_proof_11.proof_set().get(1).unwrap() == proof_set_3.get(1).unwrap());
    assert(ex_proof_11.proof_set().get(2).unwrap() == proof_set_3.get(2).unwrap());
    assert(ex_proof_11.proof_set().get(3).unwrap() == proof_set_3.get(3).unwrap());
    assert(ex_proof_11.proof_set().get(4).unwrap() == proof_set_3.get(4).unwrap());
    assert(ex_proof_11.proof_set().get(5).unwrap() == proof_set_3.get(5).unwrap());

    let ex_proof_12 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_3));
    assert(ex_proof_12.proof_set().ptr() != proof_set_4.ptr());
    assert(ex_proof_12.proof_set().len() == proof_set_4.len());
    assert(ex_proof_12.proof_set().get(0).unwrap() == proof_set_4.get(0).unwrap());
}

#[test]
fn proof_is_inclusion() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let in_proof_1 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    assert(in_proof_1.is_inclusion());

    let in_proof_2 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    assert(in_proof_2.is_inclusion());

    let in_proof_3 = Proof::Inclusion(InclusionProof::new(proof_set_3));
    assert(in_proof_3.is_inclusion());

    let ex_proof_1 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    assert(!ex_proof_1.is_inclusion());

    let ex_proof_2 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    assert(!ex_proof_2.is_inclusion());

    let ex_proof_3 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    assert(!ex_proof_3.is_inclusion());

    let ex_proof_4 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(!ex_proof_4.is_inclusion());

    let ex_proof_5 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    assert(!ex_proof_5.is_inclusion());

    let ex_proof_6 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    assert(!ex_proof_6.is_inclusion());

    let ex_proof_7 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));
    assert(!ex_proof_7.is_inclusion());

    let ex_proof_8 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(!ex_proof_8.is_inclusion());

    let ex_proof_9 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_3));
    assert(!ex_proof_9.is_inclusion());

    let ex_proof_10 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_3));
    assert(!ex_proof_10.is_inclusion());

    let ex_proof_11 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_3));
    assert(!ex_proof_11.is_inclusion());

    let ex_proof_12 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_3));
    assert(!ex_proof_12.is_inclusion());
}

#[test]
fn proof_is_exclusion() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let in_proof_1 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    assert(!in_proof_1.is_exclusion());

    let in_proof_2 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    assert(!in_proof_2.is_exclusion());

    let in_proof_3 = Proof::Inclusion(InclusionProof::new(proof_set_3));
    assert(!in_proof_3.is_exclusion());

    let ex_proof_1 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    assert(ex_proof_1.is_exclusion());

    let ex_proof_2 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    assert(ex_proof_2.is_exclusion());

    let ex_proof_3 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    assert(ex_proof_3.is_exclusion());

    let ex_proof_4 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_4.is_exclusion());

    let ex_proof_5 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    assert(ex_proof_5.is_exclusion());

    let ex_proof_6 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    assert(ex_proof_6.is_exclusion());

    let ex_proof_7 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));
    assert(ex_proof_7.is_exclusion());

    let ex_proof_8 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_8.is_exclusion());

    let ex_proof_9 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_3));
    assert(ex_proof_9.is_exclusion());

    let ex_proof_10 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_3));
    assert(ex_proof_10.is_exclusion());

    let ex_proof_11 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_3));
    assert(ex_proof_11.is_exclusion());

    let ex_proof_12 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_3));
    assert(ex_proof_12.is_exclusion());
}

#[test]
fn proof_as_inclusion() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let in_proof_1 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    assert(in_proof_1.as_inclusion().is_some());

    let in_proof_2 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    assert(in_proof_2.as_inclusion().is_some());

    let in_proof_3 = Proof::Inclusion(InclusionProof::new(proof_set_3));
    assert(in_proof_3.as_inclusion().is_some());

    let ex_proof_1 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    assert(ex_proof_1.as_inclusion().is_none());

    let ex_proof_2 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    assert(ex_proof_2.as_inclusion().is_none());

    let ex_proof_3 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    assert(ex_proof_3.as_inclusion().is_none());

    let ex_proof_4 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_4.as_inclusion().is_none());

    let ex_proof_5 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    assert(ex_proof_5.as_inclusion().is_none());

    let ex_proof_6 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    assert(ex_proof_6.as_inclusion().is_none());

    let ex_proof_7 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));
    assert(ex_proof_7.as_inclusion().is_none());

    let ex_proof_8 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_8.as_inclusion().is_none());

    let ex_proof_9 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_3));
    assert(ex_proof_9.as_inclusion().is_none());

    let ex_proof_10 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_3));
    assert(ex_proof_10.as_inclusion().is_none());

    let ex_proof_11 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_3));
    assert(ex_proof_11.as_inclusion().is_none());

    let ex_proof_12 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_3));
    assert(ex_proof_12.as_inclusion().is_none());
}

#[test]
fn proof_as_exclusion() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    let mut proof_set_4: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_4.push(b256::max());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let in_proof_1 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    assert(in_proof_1.as_exclusion().is_none());

    let in_proof_2 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    assert(in_proof_2.as_exclusion().is_none());

    let in_proof_3 = Proof::Inclusion(InclusionProof::new(proof_set_3));
    assert(in_proof_3.as_exclusion().is_none());

    let ex_proof_1 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    assert(ex_proof_1.as_exclusion().is_some());

    let ex_proof_2 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    assert(ex_proof_2.as_exclusion().is_some());

    let ex_proof_3 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    assert(ex_proof_3.as_exclusion().is_some());

    let ex_proof_4 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_4.as_exclusion().is_some());

    let ex_proof_5 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    assert(ex_proof_5.as_exclusion().is_some());

    let ex_proof_6 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    assert(ex_proof_6.as_exclusion().is_some());

    let ex_proof_7 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));
    assert(ex_proof_7.as_exclusion().is_some());

    let ex_proof_8 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_1));
    assert(ex_proof_8.as_exclusion().is_some());

    let ex_proof_9 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_3));
    assert(ex_proof_9.as_exclusion().is_some());

    let ex_proof_10 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_3));
    assert(ex_proof_10.as_exclusion().is_some());

    let ex_proof_11 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_3));
    assert(ex_proof_11.as_exclusion().is_some());

    let ex_proof_12 = Proof::Exclusion(ExclusionProof::new(proof_set_4, leaf_3));
    assert(ex_proof_12.as_exclusion().is_some());
}

#[test]
fn proof_eq() {
    let mut proof_set_1: Vec<b256> = Vec::new();
    let mut proof_set_2: Vec<b256> = Vec::new();
    let mut proof_set_3: Vec<b256> = Vec::new();
    proof_set_1.push(b256::zero());
    proof_set_3.push(b256::max());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());
    proof_set_3.push(b256::zero());

    let hash_1 = b256::max();
    let hash_2 = 0x0000000000000000000000000000000000000000000000000000000000000001;
    let leaf_data_1 = ExclusionLeafData::new(hash_1, hash_2);
    let leaf_data_2 = ExclusionLeafData::new(hash_2, hash_1);
    let leaf_1 = ExclusionLeaf::Leaf(leaf_data_1);
    let leaf_2 = ExclusionLeaf::Leaf(leaf_data_2);
    let leaf_3 = ExclusionLeaf::Placeholder;

    let ex_proof_1 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    let ex_proof_2 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_1));
    let ex_proof_3 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    let ex_proof_4 = Proof::Exclusion(ExclusionProof::new(proof_set_1, leaf_2));
    let ex_proof_5 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    let ex_proof_6 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_1));
    let ex_proof_7 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    let ex_proof_8 = Proof::Exclusion(ExclusionProof::new(proof_set_2, leaf_2));
    let ex_proof_9 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    let ex_proof_10 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_1));
    let ex_proof_11 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));
    let ex_proof_12 = Proof::Exclusion(ExclusionProof::new(proof_set_3, leaf_2));

    let in_proof_1 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    let in_proof_2 = Proof::Inclusion(InclusionProof::new(proof_set_1));
    let in_proof_3 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    let in_proof_4 = Proof::Inclusion(InclusionProof::new(proof_set_2));
    let in_proof_5 = Proof::Inclusion(InclusionProof::new(proof_set_3));
    let in_proof_6 = Proof::Inclusion(InclusionProof::new(proof_set_3));

    assert(in_proof_1 == in_proof_1);
    assert(in_proof_1 == in_proof_2);
    assert(in_proof_3 == in_proof_4);
    assert(in_proof_5 == in_proof_6);

    assert(in_proof_1 != in_proof_3);
    assert(in_proof_1 != in_proof_5);

    assert(in_proof_3 != in_proof_5);
    assert(ex_proof_1 == ex_proof_1);
    assert(ex_proof_1 == ex_proof_2);
    assert(ex_proof_3 == ex_proof_4);
    assert(ex_proof_5 == ex_proof_6);
    assert(ex_proof_7 == ex_proof_8);
    assert(ex_proof_9 == ex_proof_10);
    assert(ex_proof_11 == ex_proof_12);

    assert(ex_proof_1 != ex_proof_3);
    assert(ex_proof_1 != ex_proof_5);
    assert(ex_proof_1 != ex_proof_7);
    assert(ex_proof_1 != ex_proof_9);
    assert(ex_proof_1 != ex_proof_11);

    assert(ex_proof_3 != ex_proof_5);
    assert(ex_proof_3 != ex_proof_7);
    assert(ex_proof_3 != ex_proof_9);
    assert(ex_proof_3 != ex_proof_11);

    assert(ex_proof_5 != ex_proof_7);
    assert(ex_proof_5 != ex_proof_9);
    assert(ex_proof_5 != ex_proof_11);

    assert(ex_proof_7 != ex_proof_9);
    assert(ex_proof_7 != ex_proof_11);

    assert(ex_proof_9 != ex_proof_11);

    assert(in_proof_1 != ex_proof_1);
    assert(in_proof_2 != ex_proof_1);
    assert(in_proof_3 != ex_proof_1);
    assert(in_proof_4 != ex_proof_1);
    assert(in_proof_5 != ex_proof_1);
    assert(in_proof_6 != ex_proof_1);

    assert(in_proof_1 != ex_proof_2);
    assert(in_proof_2 != ex_proof_2);
    assert(in_proof_3 != ex_proof_2);
    assert(in_proof_4 != ex_proof_2);
    assert(in_proof_5 != ex_proof_2);
    assert(in_proof_6 != ex_proof_2);

    assert(in_proof_1 != ex_proof_3);
    assert(in_proof_2 != ex_proof_3);
    assert(in_proof_3 != ex_proof_3);
    assert(in_proof_4 != ex_proof_3);
    assert(in_proof_5 != ex_proof_3);
    assert(in_proof_6 != ex_proof_3);

    assert(in_proof_1 != ex_proof_4);
    assert(in_proof_2 != ex_proof_4);
    assert(in_proof_3 != ex_proof_4);
    assert(in_proof_4 != ex_proof_4);
    assert(in_proof_5 != ex_proof_4);
    assert(in_proof_6 != ex_proof_4);

    assert(in_proof_1 != ex_proof_5);
    assert(in_proof_2 != ex_proof_5);
    assert(in_proof_3 != ex_proof_5);
    assert(in_proof_4 != ex_proof_5);
    assert(in_proof_5 != ex_proof_5);
    assert(in_proof_6 != ex_proof_5);

    assert(in_proof_1 != ex_proof_6);
    assert(in_proof_2 != ex_proof_6);
    assert(in_proof_3 != ex_proof_6);
    assert(in_proof_4 != ex_proof_6);
    assert(in_proof_5 != ex_proof_6);
    assert(in_proof_6 != ex_proof_6);

    assert(in_proof_1 != ex_proof_7);
    assert(in_proof_2 != ex_proof_7);
    assert(in_proof_3 != ex_proof_7);
    assert(in_proof_4 != ex_proof_7);
    assert(in_proof_5 != ex_proof_7);
    assert(in_proof_6 != ex_proof_7);

    assert(in_proof_1 != ex_proof_8);
    assert(in_proof_2 != ex_proof_8);
    assert(in_proof_3 != ex_proof_8);
    assert(in_proof_4 != ex_proof_8);
    assert(in_proof_5 != ex_proof_8);
    assert(in_proof_6 != ex_proof_8);

    assert(in_proof_1 != ex_proof_9);
    assert(in_proof_2 != ex_proof_9);
    assert(in_proof_3 != ex_proof_9);
    assert(in_proof_4 != ex_proof_9);
    assert(in_proof_5 != ex_proof_9);
    assert(in_proof_6 != ex_proof_9);

    assert(in_proof_1 != ex_proof_10);
    assert(in_proof_2 != ex_proof_10);
    assert(in_proof_3 != ex_proof_10);
    assert(in_proof_4 != ex_proof_10);
    assert(in_proof_5 != ex_proof_10);
    assert(in_proof_6 != ex_proof_10);

    assert(in_proof_1 != ex_proof_11);
    assert(in_proof_2 != ex_proof_11);
    assert(in_proof_3 != ex_proof_11);
    assert(in_proof_4 != ex_proof_11);
    assert(in_proof_5 != ex_proof_11);
    assert(in_proof_6 != ex_proof_11);

    assert(in_proof_1 != ex_proof_12);
    assert(in_proof_2 != ex_proof_12);
    assert(in_proof_3 != ex_proof_12);
    assert(in_proof_4 != ex_proof_12);
    assert(in_proof_5 != ex_proof_12);
    assert(in_proof_6 != ex_proof_12);
}
