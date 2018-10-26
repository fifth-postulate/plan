pub mod strategy;

use domain::ProblemDefinition;
use sender;
use std::sync::mpsc::{Receiver, Sender};
use std::thread;
use std::marker::PhantomData;
use self::strategy::{StrategyFactory, Strategy};

pub enum Message {
    Plan(ProblemDefinition),
}

pub struct Solver<T, S> where S: Strategy + Send, T: StrategyFactory<S> {
    rx: Receiver<Message>,
    tx: Sender<sender::Message>,
    strategy_factory: T,
    marker: PhantomData<S>,
}

impl<T, S> Solver<T, S> where S: 'static + Strategy + Send, T: StrategyFactory<S> {
    pub fn new(rx: Receiver<Message>, tx: Sender<sender::Message>, strategy_factory: T) -> Self {
        Solver { rx, tx, strategy_factory, marker : PhantomData }
    }

    pub fn run(&mut self) {
        loop {
            match self.rx.recv() {
                Ok(message) => match message {
                    Message::Plan(problem_definition) => {
                        let strategy: S = self.strategy_factory.create(problem_definition);
                        let tx: Sender<sender::Message> = self.tx.clone();
                        let worker_thread = thread::Builder::new().spawn(move ||{
                            solve_with(tx, strategy);
                        }).unwrap();

                        worker_thread.join().unwrap();
                    },
                }

                Err(error) => error!("could not receive message: {}", error),
            }
        }
    }
}

fn solve_with<S>(tx: Sender<sender::Message>, mut strategy: S) where S: Strategy {
    loop {
        if let Some(candidate) = strategy.next() {
            tx.send(sender::Message::Propose(candidate)).unwrap();
        } else {
            break;
        }
    }
}
