pub mod group;
pub mod slot;
pub mod student;
pub mod subject;
pub mod teacher;

use domain::group::Group;
use domain::slot::{Slot, Slots, Weekday};
use domain::student::Student;
use domain::teacher::Teacher;
use std::collections::HashMap;

#[derive(Deserialize, Debug, PartialEq)]
#[serde(rename_all = "camelCase")]
pub struct ProblemDefinition {
    available_slots: Slots,
    groups_to_teach: Vec<Group>,
    available_teachers: Vec<Teacher>,
    participating_students: Vec<Student>,
}

#[derive(Serialize, Debug, PartialEq)]
pub struct Candidate {
    schedule: HashMap<Weekday, Vec<Session>>,
}

impl Candidate {
    pub fn new() -> Self {
        Self {
            schedule: HashMap::new(),
        }
    }

    pub fn insert(&mut self, weekday: Weekday, sessions: Vec<Session>) {
        self.schedule.insert(weekday, sessions);
    }
}

#[derive(Serialize, Debug, PartialEq)]
pub struct Session {
    slot: Slot,
    teacher: Teacher,
    group: Group,
}

#[cfg(test)]
mod tests {
    extern crate serde;
    extern crate serde_json;

    use super::*;
    use serde_json::Result;

    #[test]
    fn deserialize_problem_description() {
        let data = "{
  \"availableSlots\": {
    \"monday\": [
      {
        \"start\": {
          \"hour\": 8,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 9,
          \"minutes\": 15
        }
      },
      {
        \"start\": {
          \"hour\": 9,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 10,
          \"minutes\": 15
        }
      },
      {
        \"start\": {
          \"hour\": 10,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 11,
          \"minutes\": 15
        }
      }
    ],
    \"wednesday\": [
      {
        \"start\": {
          \"hour\": 8,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 9,
          \"minutes\": 15
        }
      },
      {
        \"start\": {
          \"hour\": 9,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 10,
          \"minutes\": 15
        }
      },
      {
        \"start\": {
          \"hour\": 10,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 11,
          \"minutes\": 15
        }
      }
    ],
    \"thursday\": [
      {
        \"start\": {
          \"hour\": 8,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 9,
          \"minutes\": 15
        }
      },
      {
        \"start\": {
          \"hour\": 9,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 10,
          \"minutes\": 15
        }
      },
      {
        \"start\": {
          \"hour\": 10,
          \"minutes\": 30
        },
        \"finish\": {
          \"hour\": 11,
          \"minutes\": 15
        }
      }
    ]
  },
  \"groupsToTeach\": [
    {
      \"identity\": {
        \"groupNumber\": 37
      },
      \"subject\": {
        \"identity\": \"Math\"
      },
      \"level\": 3,
      \"lessonsNeeded\": 2
    },
    {
      \"identity\": {
        \"groupNumber\": 51
      },
      \"subject\": {
        \"identity\": \"Spelling\"
      },
      \"level\": 5,
      \"lessonsNeeded\": 4
    },
    {
      \"identity\": {
        \"groupNumber\": 42
      },
      \"subject\": {
        \"identity\": \"Math\"
      },
      \"level\": 5,
      \"lessonsNeeded\": 1
    },
    {
      \"identity\": {
        \"groupNumber\": 51
      },
      \"subject\": {
        \"identity\": \"Spelling\"
      },
      \"level\": 5,
      \"lessonsNeeded\": 4
    }
  ],
  \"availableTeachers\": [
    {
      \"identity\": {
        \"nickname\": \"Alice\"
      },
      \"capabilities\": [
        {
          \"identity\": \"Math\"
        }
      ],
      \"availabilities\": [
        \"monday\",
        \"wednesday\"
      ]
    },
    {
      \"identity\": {
        \"nickname\": \"Babs\"
      },
      \"capabilities\": [
        {
          \"identity\": \"Spelling\"
        }
      ],
      \"availabilities\": [
        \"tuesday\",
        \"wednesday\",
        \"thursday\"
      ]
    }
  ],
  \"participatingStudents\": [
    {
      \"identity\": {
        \"studentNumber\": 3435
      },
      \"memberships\": [
        {
          \"groupNumber\": 37
        },
        {
          \"groupNumber\": 51
        }
      ]
    },
    {
      \"identity\": {
        \"studentNumber\": 1729
      },
      \"memberships\": [
        {
          \"groupNumber\": 42
        },
        {
          \"groupNumber\": 51
        }
      ]
    }
  ]
}";
        let result: Result<ProblemDefinition> = serde_json::from_str(&data);

        assert!(result.is_ok())
    }
}
