module Plan exposing (Candidate, ProblemDefinition, Session, Strategy, Stream)

{-| This module provides a machinery to solve a planning problem.
-}

import SchoolOfUnderstanding as School exposing (Dict)


{-| A `Strategy` describes a way to solve a planning problem.
-}
type alias Strategy =
    ProblemDefinition -> Stream Candidate


{-| Definition of a specific planning problem.
-}
type alias ProblemDefinition =
    { availableSlots : School.Slots
    , groupsToTeach : List School.Group
    , availableTeachers : List School.Teacher
    , participatingStudents : List School.Student
    }


type alias Stream a =
    List a


{-| A `Candidate` solution to the planning problem.
-}
type alias Candidate =
    Dict School.Weekday (List Session)


{-| A `Session` is `Slot` when a `Teacher` teaches a `Group`.
-}
type alias Session =
    { slot : School.Slot
    , teacher : School.Teacher
    , group : School.Group
    }
