module Plan exposing (Strategy)

{-| This module provides a machinery to solve a planning problem.
-}


{-| A `Strategy` describes a way to solve a planning problem.
-}
type alias Strategy =
    Input -> Stream Candidate


type alias Input =
    {}


type alias Stream a =
    List a


type alias Candidate =
    {}
