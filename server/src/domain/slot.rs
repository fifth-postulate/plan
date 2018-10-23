use std::collections::HashMap;

pub type Slots = HashMap<Weekday, Vec<Slot>>;

pub enum Weekday {
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Saturday,
    Sunday,
}

pub struct Slot {
    start: TimeOfDay,
    finish: TimeOfDay,
}

pub struct TimeOfDay {
    hour: u8,
    minutes: u8,
}


