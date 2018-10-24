#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct Subject {
    identity: String,
}

impl Subject {
    pub fn new<S>(identity: S) -> Self
    where S: Into<String> {
        Subject { identity : identity.into() }
    }
}
