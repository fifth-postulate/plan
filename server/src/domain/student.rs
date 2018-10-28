use domain::group::{Group, GroupIdentity};
use domain::subject::Subject;
use serde::de::{Deserialize, Deserializer, MapAccess, Visitor};
use std::collections::HashMap;
use std::fmt;
use std::marker::PhantomData;

#[derive(Deserialize, Debug, PartialEq)]
pub struct Student {
    identity: StudentIdentity,
    memberships: Vec<GroupIdentity>,
}

impl Student {
    pub fn new(identity: u64) -> Self {
        Student {
            identity: StudentIdentity::new(identity),
            memberships: vec![],
        }
    }

    pub fn member_of(mut self, groups: Vec<Group>) -> Self {
        groups.into_iter().for_each(|group| self.enroll_in(group));

        self
    }

    fn enroll_in(&mut self, group: Group) {
        self.memberships.push(group.identity)
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
#[serde(rename_all = "camelCase")]
pub struct StudentIdentity {
    student_number: u64,
}

impl StudentIdentity {
    pub fn new(student_number: u64) -> Self {
        StudentIdentity { student_number }
    }
}

#[cfg(test)]
mod tests {
    extern crate serde;
    extern crate serde_json;

    use super::*;

    #[test]
    fn deserialize_student() {
        let data = "{\"identity\":{\"studentNumber\":1729},\"memberships\":[{\"groupNumber\":42},{\"groupNumber\":51}]}";
        let actual: Student = serde_json::from_str(&data).unwrap();
        let expected = Student::new(1729).member_of(vec![
            Group::new(42, "Math", 3, 4),
            Group::new(51, "Spelling", 5, 2),
        ]);

        assert_eq!(actual, expected);
    }

}
