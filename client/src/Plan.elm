module Plan exposing (Candidate, ProblemDefinition, Session)

{-| This module provides a machinery to solve a planning problem.
-}

import SchoolOfUnderstanding as School exposing (Dict)
import SchoolOfUnderstanding.Group exposing (Group)
import SchoolOfUnderstanding.Slot exposing (Slot, Slots, Weekday)
import SchoolOfUnderstanding.Student exposing (Student)
import SchoolOfUnderstanding.Teacher exposing (Teacher)
import Stream exposing (Stream)


{-| Definition of a specific planning problem.
-}
type alias ProblemDefinition =
    { availableSlots : Slots
    , groupsToTeach : List Group
    , availableTeachers : List Teacher
    , participatingStudents : List Student
    }


{-| A `Candidate` solution to the planning problem.
-}
type alias Candidate =
    Dict Weekday (List Session)


{-| A `Session` is `Slot` when a `Teacher` teaches a `Group`.
-}
type alias Session =
    { slot : Slot
    , teacher : Teacher
    , group : Group
    }
