use domain::slot::Weekday;
use domain::{Candidate, ProblemDefinition};
use solver::strategy::{Strategy, StrategyFactory};

#[derive(Default)]
pub struct Factory {}

impl Factory {
    pub fn new() -> Factory {
        Factory {}
    }
}

impl StrategyFactory<Canned> for Factory {
    fn create(&mut self, _: ProblemDefinition) -> Canned {
        let mut first_candidate = Candidate::new();
        first_candidate.insert(Weekday::Monday, vec![]);

        let mut second_candidate = Candidate::new();
        second_candidate.insert(Weekday::Tuesday, vec![]);

        Canned::new(vec![first_candidate, second_candidate])
    }
}

pub struct Canned {
    candidates: Vec<Candidate>,
}

impl Canned {
    pub fn new(candidates: Vec<Candidate>) -> Self {
        Self { candidates }
    }
}

impl Strategy for Canned {
    fn next(&mut self) -> Option<Candidate> {
        self.candidates.pop()
    }
}
