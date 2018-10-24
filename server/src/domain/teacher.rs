use domain::slot::Weekday;
use domain::subject::Subject;

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct Teacher {
    identity: TeacherIdentity,
    capabilities: Vec<Subject>,
    availabilities: Vec<Weekday>,
}

impl Teacher {
    pub fn new<S>(nickname: S) -> Self
    where S: Into<String> {
        Teacher {
            identity: TeacherIdentity::new(nickname),
            capabilities: vec![],
            availabilities: vec![],
        }
    }

    pub fn teaches(mut self, capabilities: Vec<Subject>) -> Self {
        self.capabilities = capabilities;

        self
    }

    pub fn available_on(mut self, availabilities: Vec<Weekday>) -> Self {
        self.availabilities = availabilities;

        self
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct TeacherIdentity {
    nickname: String
}

impl TeacherIdentity {
    pub fn new<S>(nickname: S) -> Self
    where S: Into<String>{
         TeacherIdentity { nickname : nickname.into() }
    }
}

#[cfg(test)]
mod tests {
    extern crate serde;
    extern crate serde_json;

    use super::*;

    #[test]
    fn deserialize_teacher() {
        let data = "{\"identity\":{\"nickname\":\"Alice\"},\"capabilities\":[{\"identity\":\"Math\"}],\"availabilities\":[\"monday\",\"wednesday\"]}";
        let actual: Teacher = serde_json::from_str(&data).unwrap();
        let expected =
            Teacher::new("Alice")
            .teaches(vec![Subject::new("Math")])
            .available_on(vec![Weekday::Monday, Weekday::Wednesday]);

        assert_eq!(actual, expected);
    }
}
