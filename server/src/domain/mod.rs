pub mod slot;
pub mod group;
pub mod teacher;
pub mod student;

use domain::slot::Slots;
use domain::group::Group;
use domain::teacher::Teacher;
use domain::student::Student;

pub struct ProblemDescription {
    available_slots: Slots,
    groups_to_teach: Vec<Group>,
    available_teachers: Vec<Teacher>,
    participating_students: Vec<Student>,
}
