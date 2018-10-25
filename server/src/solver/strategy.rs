use domain::{ProblemDefinition, Candidate};

pub trait StrategyFactory {
    fn create(problem_definition: ProblemDefinition) -> Strategy;
}

pub trait Strategy {
    fn next(&mut self) -> Candidate;
}
