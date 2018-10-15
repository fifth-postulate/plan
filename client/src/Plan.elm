module Plan exposing
    ( ProblemDefinition, Candidate, Session
    , problem
    , encode
    )

{-| This module provides a machinery to solve a planning problem.


# Types

@docs ProblemDefinition, Candidate, Session


# Building

@docs problem


# Encoding

@docs encode

-}

import Json.Encode as Encode
import SchoolOfUnderstanding as School exposing (Dict)
import SchoolOfUnderstanding.Group as Group exposing (Group)
import SchoolOfUnderstanding.Slot as Slot exposing (Slot, Slots, Weekday)
import SchoolOfUnderstanding.Student as Student exposing (Student)
import SchoolOfUnderstanding.Teacher as Teacher exposing (Teacher)
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


{-| Encodes a `ProblemDefinition` into a `Json.Encode.Value`.
-}
encode : ProblemDefinition -> Encode.Value
encode aPlan =
    Encode.object
        [ ( "availableSlots", Slot.encode aPlan.availableSlots )
        , ( "groupsToTeach", Encode.list Group.encode aPlan.groupsToTeach )
        , ( "availableTeachers", Encode.list Teacher.encode aPlan.availableTeachers )
        , ( "participatingStudents", Encode.list Student.encode aPlan.participatingStudents )
        ]


{-| Creates a `ProblemDefinition` from given `Slots`, `Group`s, `Teacher`s and `Students`.
-}
problem : Slots -> List Group -> List Teacher -> List Student -> ProblemDefinition
problem availableSlots groupsToTeach availableTeachers participatingStudents =
    { availableSlots = availableSlots
    , groupsToTeach = groupsToTeach
    , availableTeachers = availableTeachers
    , participatingStudents = participatingStudents
    }
