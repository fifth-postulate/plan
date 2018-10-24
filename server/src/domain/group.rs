use domain::subject::Subject;

#[derive(Serialize, Deserialize, Debug, PartialEq)]
#[serde(rename_all="camelCase")]
pub struct Group {
    pub identity: GroupIdentity,
    pub subject: Subject,
    level: u8,
    lessons_needed: u8,
}

impl Group {
    pub fn new<S>(identity: u8, subject: S, level: u8, lessons_needed: u8) -> Self
    where S: Into<String> {
        Group {
            identity: GroupIdentity::new(identity),
            subject: Subject::new(subject),
            level,
            lessons_needed,
        }
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
#[serde(rename_all="camelCase")]
pub struct GroupIdentity {
    group_number: u8,
}

impl GroupIdentity {
    pub fn new(group_number: u8) -> Self {
        GroupIdentity { group_number }
    }
}

#[cfg(test)]
mod test {
    extern crate serde;
    extern crate serde_json;

    use super::*;

    #[test]
    fn deserialize_group() {
        let data = "{\"identity\":{\"groupNumber\":51},\"subject\":{\"identity\":\"Spelling\"},\"level\":5,\"lessonsNeeded\":4}";
        let actual: Group = serde_json::from_str(&data).unwrap();
        let expected = Group::new(51, "Spelling", 5, 4);

        assert_eq!(actual, expected);
    }
}
