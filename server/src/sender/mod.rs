use std::sync::mpsc::Receiver;
use domain::Candidate;

pub enum Message {
    Propose(Candidate)
}

pub struct Repeater {
    rx: Receiver<Message>,
}

impl Repeater {
    pub fn new(rx: Receiver<Message>) -> Self {
        Self { rx }
    }

    pub fn run(&mut self) {
        loop {
            match self.rx.recv() {
                Ok(message) => match message {
                    Message::Propose(candidate) => {
                        info!("propose candidate: {:?}", candidate)
                    }
                },

                Err(error) => error!("could not receive message: {}", error),
            }
        }
    }
}
