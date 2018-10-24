use std::io::Read;
use router::Router;
use iron::{Request, Response, status};
use serde_json;
use serde_json::Error;

use domain::ProblemDescription;

pub fn router() -> Router {
    let mut router = Router::new();

    router.post("/", move |request: &mut Request|{
        let mut body = String::new();
        if let Ok(_) = request.body.read_to_string(&mut body) {
            let problem_description_result: Result<ProblemDescription, Error> = serde_json::from_str(&body);
            if let Ok(problem_description) = problem_description_result {
                info!("received {:?}", problem_description);

                Ok(Response::with((status::Ok, "{}")))
            } else {
                error!("unable to deserialize problem description \"{}\"", body);

                Ok(Response::with(status::BadRequest))
            }
        } else {
            Ok(Response::with(status::InternalServerError))
        }
    }, "register");

    router
}
