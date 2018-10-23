use std::collections::HashMap;

pub type Slots = HashMap<Weekday, Vec<Slot>>;

#[derive(Serialize, Deserialize, Debug)]
pub enum Weekday {
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Saturday,
    Sunday,
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct Slot {
    start: TimeOfDay,
    finish: TimeOfDay,
}

impl Slot {
    pub fn new(start: TimeOfDay, finish: TimeOfDay) -> Slot {
        Slot {start, finish}
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct TimeOfDay {
    hour: u8,
    minutes: u8,
}

impl TimeOfDay {
    pub fn new(hour: u8, minutes: u8) -> TimeOfDay {
        TimeOfDay {hour, minutes}
    }
}

#[cfg(test)]
mod tests {
    extern crate serde;
    extern crate serde_json;

    use super::*;

    #[test]
    fn serialize_time_of_day() {
        let data = "{\"hour\": 8, \"minutes\": 30}";
        let actual: TimeOfDay = serde_json::from_str(&data).unwrap();
        let expected = TimeOfDay::new(8, 30);

        assert_eq!(actual, expected)
    }

    #[test]
    fn serialize_slot() {
        let data = "{\"start\":{\"hour\": 8,\"minutes\": 30},\"finish\": {\"hour\": 9,\"minutes\": 15}}";
        let actual: Slot = serde_json::from_str(&data).unwrap();
        let expected = Slot::new(TimeOfDay::new(8, 30), TimeOfDay::new(9, 15));

        assert_eq!(actual, expected)
    }
}

