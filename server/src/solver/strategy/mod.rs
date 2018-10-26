pub mod hardcoded;

use domain::{Candidate, ProblemDefinition};

pub trait StrategyFactory<S>
where
    S: Strategy,
{
    fn create(&mut self, problem_defition: ProblemDefinition) -> S;
}

pub trait Strategy {
    fn next(&mut self) -> Option<Candidate>;
}
