extern crate iron;
#[macro_use]
extern crate log;
extern crate dotenv;
extern crate plan;
extern crate simplelog;

use dotenv::dotenv;
use iron::prelude::*;
use plan::server;
use simplelog::{CombinedLogger, Config, LevelFilter, TermLogger};
use std::env;
use std::thread;

fn main() {
    dotenv().ok();
    CombinedLogger::init(vec![
        TermLogger::new(LevelFilter::Info, Config::default()).unwrap(),
    ]).unwrap();
    info!("Logger configured");

    let iron_thread = thread::Builder::new()
        .name("iron".to_string())
        .spawn(move || {
            let server_address = env::var("address").expect("\"address\" in environment variables");
            info!("starting a server at {}", server_address);
            let chain = server::chain();
            Iron::new(chain).http(server_address).unwrap();
        }).unwrap();

    iron_thread.join().unwrap();
}
