use domain::{Candidate, ProblemDefinition};

pub trait StrategyFactory {
    fn create(problem_definition: ProblemDefinition) -> Strategy;
}

pub trait Strategy {
    fn next(&mut self) -> Option<Candidate>;
}
