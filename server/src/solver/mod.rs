pub mod strategy;

use domain::ProblemDefinition;
use std::sync::mpsc::{channel, Receiver, Sender};
use std::sync::Arc;

pub struct Solver {
    rx: Receiver<Message>,
}

impl Solver {
    pub fn new(rx: Receiver<Message>) -> Self {
        Solver { rx }
    }

    pub fn run(&self) {
        loop {
            match self.rx.recv() {
                Ok(message) => match message {
                    Message::Plan(problem_definition) => {
                        info!("planning {:?}", problem_definition);
                    }
                },

                Err(error) => error!("could not receive message: {}", error),
            }
        }
    }
}

pub enum Message {
    Plan(ProblemDefinition),
}
