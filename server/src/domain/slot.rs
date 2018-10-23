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

#[derive(Serialize, Deserialize, Debug)]
pub struct Slot {
    start: TimeOfDay,
    finish: TimeOfDay,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct TimeOfDay {
    hour: u8,
    minutes: u8,
}


