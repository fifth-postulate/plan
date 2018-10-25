use std::convert::From;

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Hash)]
pub struct Subject {
    identity: String,
}

impl Subject {
    pub fn new<S>(identity: S) -> Self
    where
        S: Into<String>,
    {
        Subject {
            identity: identity.into(),
        }
    }
}

impl From<String> for Subject {
    fn from(identity: String) -> Subject {
        Subject::new(identity)
    }
}
