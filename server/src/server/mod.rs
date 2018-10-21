// Server related code.

use std::path::Path;

use iron::Chain;
use logger::Logger;
use mount::Mount;
use staticfile::Static;

use super::domain::Message;

pub fn chain() -> Chain {
    let mut chain = Chain::new(mount());
    let (logger_before, logger_after) = Logger::new(None);
    chain.link_before(logger_before);
    chain.link_after(logger_after);

    chain
}

fn mount(to_registration: Sender<Message>) -> Mount {
    let mut mounter = Mount::new();

    mounter.mount("/", Static::new(Path::new("static/")));

    mounter
}

