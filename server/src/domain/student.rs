use serde::de::{Deserialize, Deserializer, MapAccess, Visitor};
use std::collections::HashMap;
use domain::subject::Subject;
use domain::group::{GroupIdentity, Group};
use std::fmt;
use std::marker::PhantomData;

#[derive(Deserialize, Debug, PartialEq)]
pub struct Student {
    identity: StudentIdentity,
    memberships: Memberships,

}

impl Student {
    pub fn new(identity: u64) -> Self {
        Student {
            identity: StudentIdentity::new(identity),
            memberships: Memberships::new(),
        }
    }

    pub fn member_of(mut self, groups: Vec<Group>) -> Self {
        groups.into_iter().for_each(|group|{
            self.enroll_in(group)
        });

        self
    }

    fn enroll_in(&mut self, group: Group) {
        self.memberships.enroll_in(group)
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
#[serde(rename_all="camelCase")]
pub struct StudentIdentity {
    student_number: u64,
}

impl StudentIdentity {
    pub fn new(student_number: u64) -> Self {
        StudentIdentity { student_number }
    }
}

#[derive(Debug, PartialEq)]
pub struct Memberships {
    memberships: HashMap<Subject, GroupIdentity>
}

impl Memberships {
    pub fn new() -> Memberships {
        Memberships { memberships: HashMap::new() }
    }

    pub fn enroll_in(&mut self, group: Group) {
        self.memberships.insert(group.subject, group.identity);
    }

    pub fn insert(&mut self, subject: String, group_identity: GroupIdentity) {
        self.memberships.insert(subject.into(), group_identity);
    }
}

struct MembershipsVisitor {
    marker: PhantomData<fn() -> Memberships>,
}

impl MembershipsVisitor {
    fn new() -> Self {
        MembershipsVisitor {
            marker: PhantomData,
        }
    }
}

impl<'de> Visitor<'de> for MembershipsVisitor {
    type Value = Memberships;

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        formatter.write_str("memberships")
    }

    fn visit_map<M>(self, mut access: M) -> Result<Self::Value, M::Error>
    where
        M: MapAccess<'de>,
    {
        let mut memberships = Memberships::new();

        while let Some((key, value)) = access.next_entry()? {
            memberships.insert(key, value);
        }

        Ok(memberships)
    }
}

impl<'de> Deserialize<'de> for Memberships {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        deserializer.deserialize_map(MembershipsVisitor::new())
    }
}

#[cfg(test)]
mod tests {
    extern crate serde;
    extern crate serde_json;

    use super::*;

    #[test]
    fn deserialize_student() {
        let data = "{\"identity\":{\"studentNumber\":1729},\"memberships\":{\"Math\":{\"groupNumber\":42},\"Spelling\":{\"groupNumber\":51}}}";
        let actual: Student = serde_json::from_str(&data).unwrap();
        let expected = Student::new(1729)
            .member_of(vec![
                Group::new(42, "Math", 3, 4),
                Group::new(51, "Spelling", 5, 2),
            ]);

        assert_eq!(actual, expected);
    }

}
// 
