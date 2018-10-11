module Plan exposing (Strategy)

{-| This module provides a machinery to solve a planning problem.
-}

import SchoolOfUnderstanding as School


{-| A `Strategy` describes a way to solve a planning problem.
-}
type alias Strategy =
    ProblemDefinition -> Stream Candidate

{-| Definition of a specific planning problem. -}
type alias ProblemDefinition =
    { availableSlots : School.Slots
    , groupsToTeach : List School.Group
    , availableTeachers : List School.Teacher
    , participatingStudents : List School.Student
    }


type alias Stream a =
    List a


type alias Candidate =
    {}
