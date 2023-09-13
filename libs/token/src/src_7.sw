library;

use src_7::Metadata;
use std::string::String;

impl Metadata {
    fn as_string(self) -> Option<String> {
        match self {
            StringData(data) => Option::Some(data),
            _ => Option::None(),
        }
    }

    fn is_string(self) -> bool {
        match self {
            StringData(data) => true,
            _ => false,
        }
    }

    fn as_u64(self) -> Option<u64> {
        match self {
            IntData(data) => Option::Some(data),
            _ => Option::None(),
        }
    }

    fn is_u64(self) -> bool {
        match self {
            IntData(data) => true,
            _ => false,
        }
    }

    fn as_bytes(self) -> Option<Bytes> {
        match self {
            BytesData(data) => Option::Some(data),
            _ => Option::None(),
        }
    }

    fn is_bytes(self) -> bool {
        match self {
            BytesData(data) => true,
            _ => false,
        }
    }
}
