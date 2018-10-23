use serde::de::{Deserialize, Deserializer, MapAccess, Visitor};
use std::collections::HashMap;
use std::fmt;
use std::marker::PhantomData;

#[derive(Debug, PartialEq)]
pub struct Slots {
    slots: HashMap<Weekday, Vec<Slot>>,
}

impl Slots {
    pub fn new() -> Slots {
        Slots {
            slots: HashMap::new(),
        }
    }

    pub fn insert(&mut self, key: Weekday, value: Vec<Slot>) {
        self.slots.insert(key, value);
    }
}

struct SlotsVisitor {
    marker: PhantomData<fn() -> Slots>,
}

impl SlotsVisitor {
    fn new() -> Self {
        SlotsVisitor {
            marker: PhantomData,
        }
    }
}

impl<'de> Visitor<'de> for SlotsVisitor {
    type Value = Slots;

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        formatter.write_str("slots")
    }

    fn visit_map<M>(self, mut access: M) -> Result<Self::Value, M::Error>
    where
        M: MapAccess<'de>,
    {
        let mut slots = Slots::new();

        while let Some((key, value)) = access.next_entry()? {
            slots.insert(key, value);
        }

        Ok(slots)
    }
}

impl<'de> Deserialize<'de> for Slots {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        deserializer.deserialize_map(SlotsVisitor::new())
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq, Eq, Hash)]
#[serde(rename_all = "lowercase")]
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
        Slot { start, finish }
    }
}

#[derive(Serialize, Deserialize, Debug, PartialEq)]
pub struct TimeOfDay {
    hour: u8,
    minutes: u8,
}

impl TimeOfDay {
    pub fn new(hour: u8, minutes: u8) -> TimeOfDay {
        TimeOfDay { hour, minutes }
    }
}

#[cfg(test)]
mod tests {
    extern crate serde;
    extern crate serde_json;

    use super::*;

    #[test]
    fn deserialize_time_of_day() {
        let data = "{\"hour\": 8, \"minutes\": 30}";
        let actual: TimeOfDay = serde_json::from_str(&data).unwrap();
        let expected = TimeOfDay::new(8, 30);

        assert_eq!(actual, expected)
    }

    #[test]
    fn deserialize_slot() {
        let data =
            "{\"start\":{\"hour\": 8,\"minutes\": 30},\"finish\": {\"hour\": 9,\"minutes\": 15}}";
        let actual: Slot = serde_json::from_str(&data).unwrap();
        let expected = Slot::new(TimeOfDay::new(8, 30), TimeOfDay::new(9, 15));

        assert_eq!(actual, expected)
    }

    #[ignore]
    #[test]
    fn deserialize_weekday() {
        let data = "sunday";
        let actual: Weekday = serde_json::from_str(&data).unwrap();
        let expected = Weekday::Sunday;

        assert_eq!(actual, expected)
    }

    #[test]
    fn deserialize_slots() {
        let data = "{\"monday\":[{\"start\":{\"hour\":8,\"minutes\":30},\"finish\":{\"hour\":9,\"minutes\":15}}]}";
        let actual: Slots = serde_json::from_str(&data).unwrap();
        let mut expected = Slots::new();
        expected.insert(
            Weekday::Monday,
            vec![Slot::new(TimeOfDay::new(8, 30), TimeOfDay::new(9, 15))],
        );

        assert_eq!(actual, expected)
    }
}
