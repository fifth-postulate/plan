// Server related code.
mod plan;

use std::path::Path;
use std::sync::mpsc::{Sender, Receiver};
use iron::Chain;
use logger::Logger;
use mount::Mount;
use staticfile::Static;
use solver;

pub fn chain(tx: Sender<solver::Message>) -> Chain {
    let mut chain = Chain::new(mount(tx));
    let (logger_before, logger_after) = Logger::new(None);
    chain.link_before(logger_before);
    chain.link_after(logger_after);

    chain
}

fn mount(tx: Sender<solver::Message>) -> Mount {
    let mut mounter = Mount::new();

    mounter.mount("/", Static::new(Path::new("static/")));
    mounter.mount("/plan", plan::router(tx));

    mounter
}
