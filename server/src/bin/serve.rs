extern crate iron;
#[macro_use] extern crate log;
extern crate simplelog;
extern crate plan;
extern crate dotenv;

use std::env;
use std::thread;
use std::sync::mpsc::{channel, Sender, Receiver};
use iron::prelude::*;
use simplelog::{Config, LevelFilter, TermLogger, CombinedLogger};
use dotenv::dotenv;
use plan::server;

fn main() {
    dotenv().ok();
    CombinedLogger::init(
        vec![
            TermLogger::new(LevelFilter::Info, Config::default()).unwrap(),
        ]
    ).unwrap();
    info!("Logger configured");

    let iron_thread = thread::Builder::new().name("iron".to_string()).spawn(move ||{
        let server_address = env::var("address").expect("\"address\" in environment variables");
        info!("starting a server at {}", server_address);
        let chain = plan::chain();
        Iron::new(chain).http(server_address).unwrap();
    }).unwrap();

    iron_thread.join().unwrap();
}

