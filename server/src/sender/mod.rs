use domain::Candidate;
use serde_json;
use std::sync::mpsc::Receiver;
use std::thread;
use ws::{self, WebSocket};

pub enum Message {
    Propose(Candidate),
}

pub struct Repeater {
    socket_address: String,
}

impl Repeater {
    pub fn new<S>(socket_address: S) -> Self
    where
        S: Into<String>,
    {
        Self {
            socket_address: socket_address.into(),
        }
    }

    pub fn run(&mut self, rx: Receiver<Message>) {
        if let Ok(socket) = WebSocket::new(|out: ws::Sender| {
            move |msg| {
                info!("Server got message '{}'", msg);
                out.broadcast("")
            }
        }) {
            let broadcaster = socket.broadcaster();
            let repeater_thread = thread::Builder::new()
                .name("repeater".to_string())
                .spawn(move || loop {
                    match rx.recv() {
                        Ok(message) => match message {
                            Message::Propose(candidate) => {
                                info!("broadcasting candidate");
                                let payload = serde_json::to_string(&candidate).unwrap();
                                broadcaster.send(payload).unwrap();
                            }
                        },

                        Err(error) => error!("could not receive message: {}", error),
                    }
                }).unwrap();
            if let Err(error) = socket.listen(&self.socket_address) {
                error!("failed to listen {:?}", error);
            }
            repeater_thread.join().unwrap();
        } else {
            error!(
                "failed to connect websocket at address {}.",
                self.socket_address
            );
        }
    }
}
