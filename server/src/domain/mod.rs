pub mod group;
pub mod slot;
pub mod student;
pub mod teacher;
pub mod subject;

use domain::group::Group;
use domain::slot::Slots;
use domain::student::Student;
use domain::teacher::Teacher;

pub struct ProblemDescription {
    available_slots: Slots,
    groups_to_teach: Vec<Group>,
    available_teachers: Vec<Teacher>,
    participating_students: Vec<Student>,
}
