module SchoolOfUnderstanding.Teacher exposing
    ( teacher, canTeach, isAvailableOn
    , encode
    , Teacher, TeacherIdentity
    )

{-| Teacher

> one whose occupation is to instruct.


# Types

@ docs Teacher, TeacherIdentity


# Building

@docs teacher, canTeach, isAvailableOn


# Encoding

@docs encode

-}

import Json.Encode as Encode
import SchoolOfUnderstanding.Slot as Slot exposing (Weekday)
import SchoolOfUnderstanding.Subject as Subject exposing (Subject)


{-| Teacher, capable of teaching subjects on certain weekdays.
-}
type alias Teacher =
    { identity : TeacherIdentity
    , capabilities : List Subject
    , availabilities : List Weekday
    }


{-| A means to identify a teacher.
-}
type TeacherIdentity
    = TeacherIdentity { nickname : String }


{-| Creates a `Teacher` from a name.
-}
teacher : String -> Teacher
teacher nickname =
    let
        identity =
            TeacherIdentity { nickname = nickname }
    in
    { identity = identity, capabilities = [], availabilities = [] }


{-| Transforms a `Teacher` into a `Teacher` with a list of capabilities.
-}
canTeach : List Subject -> Teacher -> Teacher
canTeach capabilities aTeacher =
    { aTeacher | capabilities = capabilities }


{-| Transforms a `Teacher` into a `Teacher` with is available on a list of `Weekday`.
-}
isAvailableOn : List Weekday -> Teacher -> Teacher
isAvailableOn availabilities aTeacher =
    { aTeacher | availabilities = availabilities }


{-| Encodes a `Teacher` into a `Json.Encode.Value`.
-}
encode : Teacher -> Encode.Value
encode aTeacher =
    let
        identity =
            encodeIdentity aTeacher.identity

        capabilities =
            encodeCapabilities aTeacher.capabilities

        availabilities =
            encodeAvailabilities aTeacher.availabilities
    in
    Encode.object
        [ ( "identity", identity )
        , ( "capabilities", capabilities )
        , ( "availabilities", availabilities )
        ]


encodeIdentity : TeacherIdentity -> Encode.Value
encodeIdentity (TeacherIdentity { nickname }) =
    Encode.object [ ( "nickname", Encode.string nickname ) ]


encodeCapabilities : List Subject -> Encode.Value
encodeCapabilities capabilities =
    capabilities
        |> Encode.list Subject.encode


encodeAvailabilities : List Weekday -> Encode.Value
encodeAvailabilities availabilities =
    availabilities
        |> Encode.list Slot.encodeWeekday
