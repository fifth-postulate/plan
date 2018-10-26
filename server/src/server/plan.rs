use iron::{status, Request, Response};
use router::Router;
use serde_json;
use serde_json::Error;
use std::io::Read;
use std::sync::mpsc::Sender;
use std::sync::{Arc, Mutex};

use domain::ProblemDefinition;
use solver;

pub fn router(tx: Sender<solver::Message>) -> Router {
    let mut router = Router::new();

    let tx_mutex = Arc::new(Mutex::new(tx));
    router.post(
        "/",
        move |request: &mut Request| {
            let mut body = String::new();
            if let Ok(_) = request.body.read_to_string(&mut body) {
                let problem_description_result: Result<ProblemDefinition, Error> =
                    serde_json::from_str(&body);
                if let Ok(problem_description) = problem_description_result {
                    tx_mutex
                        .lock()
                        .unwrap()
                        .send(solver::Message::Plan(problem_description))
                        .unwrap();

                    Ok(Response::with((status::Ok, "{}")))
                } else {
                    error!("unable to deserialize problem description \"{}\"", body);

                    Ok(Response::with(status::BadRequest))
                }
            } else {
                Ok(Response::with(status::InternalServerError))
            }
        },
        "register",
    );

    router
}
