extern crate iron;
#[macro_use]
extern crate log;
extern crate dotenv;
extern crate plan;
extern crate simplelog;

use dotenv::dotenv;
use iron::prelude::*;
use plan::sender::{self, Repeater};
use plan::server;
use plan::solver::{self, Solver};
use plan::solver::strategy::hardcoded::Factory;
use simplelog::{CombinedLogger, Config, LevelFilter, TermLogger};
use std::env;
use std::sync::mpsc::{channel, Receiver, Sender};
use std::thread;

fn main() {
    dotenv().ok();
    CombinedLogger::init(vec![
        TermLogger::new(LevelFilter::Info, Config::default()).unwrap(),
    ]).unwrap();
    info!("Logger configured");

    let (solver_tx, solver_rx): (Sender<solver::Message>, Receiver<solver::Message>) = channel();
    let (sender_tx, sender_rx): (Sender<sender::Message>, Receiver<sender::Message>) = channel();
    let iron_thread = thread::Builder::new()
        .name("iron".to_string())
        .spawn(move || {
            let server_address = env::var("address").expect("\"address\" in environment variables");
            info!("starting a server at {}", server_address);
            let chain = server::chain(solver_tx);
            Iron::new(chain).http(server_address).unwrap();
        }).unwrap();

    let solver_thread = thread::Builder::new()
        .name("solver".to_string())
        .spawn(move || {
            let mut solver = Solver::new(solver_rx, sender_tx, Factory::new());
            info!("starting a solver.");

            solver.run();
        }).unwrap();

    let sender_thread = thread::Builder::new()
        .name("sender".to_string())
        .spawn(move || {
            let socket_address = env::var("socket_address").expect("\"socket_address\" in environment variables");
            let mut repeater = Repeater::new(socket_address);
            info!("starting a sender.");

            repeater.run(sender_rx);
        }).unwrap();

    iron_thread.join().unwrap();
    solver_thread.join().unwrap();
    sender_thread.join().unwrap();
}
