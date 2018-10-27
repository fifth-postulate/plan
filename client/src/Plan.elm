module Plan exposing
    ( ProblemDefinition, Candidate, Session
    , problem
    , candidateFromList, candidateDecoder
    , encode
    )

{-| This module provides a machinery to solve a planning problem.


# Types

@docs ProblemDefinition, Candidate, Session


# Building

@docs problem


# Conversion

@docs candidateFromList, candidateDecoder


# Encoding

@docs encode

-}

import Dict
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import SchoolOfUnderstanding as School
import SchoolOfUnderstanding.Group as Group exposing (Group, GroupIdentity)
import SchoolOfUnderstanding.Slot as Slot exposing (Slot, Slots, Weekday)
import SchoolOfUnderstanding.Student as Student exposing (Student)
import SchoolOfUnderstanding.Teacher as Teacher exposing (Teacher, TeacherIdentity)
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
    { schedule : School.Dict Weekday (List Session)
    }


{-| A `Session` is `Slot` when a `Teacher` teaches a `Group`.
-}
type alias Session =
    { slot : Slot
    , teacher : TeacherIdentity
    , group : GroupIdentity
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


{-| Create a candidate from a `List` of a pair of `Weekday` and `List Session`.
-}
candidateFromList : List ( Weekday, List Session ) -> Candidate
candidateFromList list =
    let
        emptySchedule =
            School.empty Slot.weekdayToInt

        insert ( weekday, sessions ) partialSchedule =
            School.insert weekday sessions partialSchedule

        schedule =
            list
                |> List.foldl insert emptySchedule
    in
    Candidate schedule


{-| Decoder for a `Candidate`.
-}
candidateDecoder : Decoder Candidate
candidateDecoder =
    Decode.succeed Candidate
        |> required "schedule" scheduleDecoder


scheduleDecoder : Decoder (School.Dict Weekday (List Session))
scheduleDecoder =
    let
        toSchedule pairs =
            let
                inserter ( name, sessions ) aSchedule =
                    case Slot.weekdayFromString name of
                        Ok weekday ->
                            School.insert weekday sessions aSchedule

                        Err _ ->
                            aSchedule

                emptySchedule =
                    School.empty Slot.weekdayToInt
            in
            List.foldl inserter emptySchedule pairs
    in
    sessionDecoder
        |> Decode.list
        |> Decode.dict
        |> Decode.map Dict.toList
        |> Decode.map toSchedule


sessionDecoder : Decoder Session
sessionDecoder =
    Decode.succeed Session
        |> required "slot" Slot.slotDecoder
        |> required "teacher" Teacher.teacherIdentityDecoder
        |> required "group" Group.groupIdentityDecoder
