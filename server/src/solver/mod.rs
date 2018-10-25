pub mod strategy;

use domain::ProblemDefinition;
use std::sync::mpsc::{channel, Receiver, Sender};
use std::thread;

pub enum Message {
    Plan(ProblemDefinition),
}

pub struct Solver {
    rx: Receiver<Message>,
}

impl Solver {
    pub fn new(rx: Receiver<Message>) -> Self {
        Solver { rx }
    }

    pub fn run(&mut self) {
        loop {
            match self.rx.recv() {
                Ok(message) => match message {
                    Message::Plan(_problem_definition) => {
                        let worker_thread = thread::Builder::new().spawn(move ||{
                        }).unwrap();

                        worker_thread.join().unwrap();
                    },
                }

                Err(error) => error!("could not receive message: {}", error),
            }
        }
    }
}
