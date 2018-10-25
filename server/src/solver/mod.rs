use std::sync::Arc;
use std::sync::mpsc::{channel, Sender, Receiver};
use domain::ProblemDefinition;

pub struct Solver {
    rx: Receiver<Message>
}

impl Solver {
    pub fn new(rx: Receiver<Message>) -> Self {
        Solver { rx }
    }

    pub fn run(&self) {
        let state_arc = Arc::new(State::ready());
        loop {
            match self.rx.recv() {
                Ok(message) => {
                    match message {
                        Message::Plan(problem_definition) => {
                            info!("planning {:?}", problem_definition);
                        }
                    }
                }

                Err(error) => {
                    error!("could not receive message: {}", error)
                }
            }
        }
    }
}

pub enum Message {
    Plan(ProblemDefinition),
}

pub struct State<S> {
    state: S
}

impl State<Ready> {
    pub fn ready() -> Self {
        State { state : Ready::new() }
    }
}

impl From<State<Ready>> for State<Busy> {
    fn from(_: State<Ready>) -> Self {
        State {
            state: Busy::new()
        }
    }
}

impl From<State<Busy>> for State<Pauzed> {
    fn from(_: State<Busy>) -> Self {
        State {
            state: Pauzed::new()
        }
    }
}


pub struct Ready {}

impl Ready {
    pub fn new() -> Self {
        Self {}
    }
}

pub struct Busy {}

impl Busy {
    pub fn new() -> Self {
        Self {}
    }
}

pub struct Pauzed {}

impl Pauzed {
    pub fn new() -> Self {
        Self {}
    }
}

