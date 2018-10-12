module Plan exposing (Candidate, ProblemDefinition, Session)

{-| This module provides a machinery to solve a planning problem.
-}

import SchoolOfUnderstanding as School exposing (Dict)
import SchoolOfUnderstanding.Slot exposing (Slots, Slot, Weekday)
import Stream exposing (Stream)


{-| Definition of a specific planning problem.
-}
type alias ProblemDefinition =
    { availableSlots : Slots
    , groupsToTeach : List School.Group
    , availableTeachers : List School.Teacher
    , participatingStudents : List School.Student
    }


{-| A `Candidate` solution to the planning problem.
-}
type alias Candidate =
    Dict Weekday (List Session)


{-| A `Session` is `Slot` when a `Teacher` teaches a `Group`.
-}
type alias Session =
    { slot : Slot
    , teacher : School.Teacher
    , group : School.Group
    }
