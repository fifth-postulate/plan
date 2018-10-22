struct Slots {}

struct Group {}

struct Teacher {}

struct Student {}

pub struct ProblemDescription {
    available_slots: Slots,
    groups_to_teach: Vec<Group>,
    available_teachers: Vec<Teacher>,
    participating_students: Vec<Student>,
}
