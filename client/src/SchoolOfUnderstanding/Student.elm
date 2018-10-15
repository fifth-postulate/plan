module SchoolOfUnderstanding.Student exposing
    ( Student, StudentIdentity
    , student, memberOf
    , encode
    )

{-| Module provides student related functionality.


# Types

@docs Student, StudentIdentity


# Building

@docs student, memberOf


# Encoding

@docs encode

-}

import Dict.Any as AnyDict exposing (AnyDict)
import Json.Encode as Encode
import SchoolOfUnderstanding.Group as Group exposing (Group, GroupIdentity)
import SchoolOfUnderstanding.Subject as Subject exposing (Subject)


type alias Dict k v =
    AnyDict String k v


{-| A `Student` is person enrolled in the School of Understanding.
-}
type alias Student =
    { identity : StudentIdentity
    , memberships : Dict Subject GroupIdentity
    }


{-| A means to identity a student with.
-}
type StudentIdentity
    = StudentIdentity { studentNumber : Int }


{-| Encodes a `Student` into a `Json.Encode.Value`.
-}
encode : Student -> Encode.Value
encode aStudent =
    let
        identity =
            encodeStudentIdentity aStudent.identity

        memberships =
            encodeMemberships aStudent.memberships
    in
    Encode.object [ ( "identity", identity ), ( "memberships", memberships ) ]


{-| Encodes a `StudentIdentity` into a `Json.Encode.Value`.
-}
encodeStudentIdentity (StudentIdentity { studentNumber }) =
    Encode.object [ ( "studentNumber", Encode.int studentNumber ) ]


{-| Encodes a memberships into a `Json.Encode.Value`.
-}
encodeMemberships : Dict Subject GroupIdentity -> Encode.Value
encodeMemberships memberships =
    let
        key subject =
            Subject.toString subject

        value groupIdentity =
            Group.encodeGroupIdentity groupIdentity

        collect subject groupIdentity accumulator =
            ( key subject, value groupIdentity ) :: accumulator
    in
    memberships
        |> AnyDict.foldr collect []
        |> Encode.object


{-| Create a `Student`.
-}
student : Int -> Student
student id =
    let
        identity =
            StudentIdentity { studentNumber = id }
    in
    { identity = identity, memberships = AnyDict.empty Subject.toString }


{-| Enrolls a `Student` in a number of `Group`s.
-}
memberOf : List Group -> Student -> Student
memberOf groups aStudent =
    let
        enroll { subject, identity } ms =
            ms
                |> AnyDict.insert subject identity

        memberships =
            groups
                |> List.foldl enroll aStudent.memberships
    in
    { aStudent | memberships = memberships }
